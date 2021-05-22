defmodule DarkEcto.Parsers.ModuleTypespecs do
  @forma_parsers %{}

  def attributes(module) when is_atom(module) do
    with {:ok, field_typespecs} <- field_typespecs(module),
         {:ok, fields} <- parse_fields(field_typespecs),
         {:ok, grouping} <- group_fields(fields) do
      grouping =
        grouping
        |> replace_assocs()

      {:ok, grouping}
    end
  end

  def parse_fields(typespecs) when is_map(typespecs) do
    attributes =
      for {field, typespec} <- Map.values(typespecs) do
        {field, cast(typespec)}
      end

    {:ok, attributes}
  end

  def group_fields(fields) when is_list(fields) do
    grouping = Enum.group_by(fields, &elem(elem(&1, 1), 0), &{elem(&1, 0), elem(elem(&1, 1), 1)})

    case grouping do
      %{ignore: [_ | _] = ignore} ->
        {:error, ignore}

      grouping ->
        {:ok,
         %{
           attributes: Map.get(grouping, :attribute, []),
           relationships: Map.get(grouping, :relationship, [])
         }}
    end
  end

  def replace_assocs(%{attributes: _attributes, relationships: relationships} = grouping) do
    relationships |> Enum.reduce(grouping, &do_replace_assoc/2)
  end

  def do_replace_assoc(
        {field, {:assoc_one, opts}},
        %{attributes: attributes, relationships: relationships} = grouping
      ) do
    belongs_to_fk = :"#{field}_id"

    if Keyword.has_key?(attributes, belongs_to_fk) do
      grouping
      |> Map.put(:attributes, Keyword.delete(attributes, belongs_to_fk))
      |> Map.put(:relationships, Keyword.put(relationships, field, {:belongs_to, opts}))
    else
      grouping
      |> Map.put(:relationships, Keyword.put(relationships, field, {:has_one, opts}))
    end
  end

  def do_replace_assoc(
        {field, {:assoc_many, opts}},
        %{attributes: attributes, relationships: relationships} = grouping
      ) do
    grouping
    |> Map.put(:relationships, Keyword.put(relationships, field, {:has_many, opts}))
  end

  def do_replace_assoc(_relationship, grouping) do
    grouping
  end

  def cast({:float, opts}), do: {:attribute, {:float, opts}}
  def cast({:integer, opts}), do: {:attribute, {:float, opts}}
  def cast({{String, :t}, opts}), do: {:attribute, {:string, opts}}

  # should really check some config? or something to do embedded or has/belongs based on additional keys
  def cast({{type, :t}, opts}), do: {:relationship, {:assoc_one, cast(type), opts}}

  def cast({:list, type}), do: {:relationship, {:assoc_many, cast(type)}}
  def cast({:union, [atom: true, atom: false]}), do: {:attribute, {:boolean, []}}

  def cast({:union, types}) do
    case types |> Enum.map(&cast/1) |> Enum.map(&elem(elem(&1, 1), 0)) |> Enum.uniq() do
      [type] -> {:attribute, type}
    end
  end

  def cast(attribute), do: {:ignore, attribute}

  def field_typespecs(module) when is_atom(module) do
    with {:ok, typespecs} <- typespecs(module),
         {:struct, ^module, field_typespecs} <- Map.get(typespecs, {module, :t}) do
      {:ok, field_typespecs}
    else
      _ -> :error
    end
  end

  def typespecs(module) when is_atom(module) do
    case Forma.Typespecs.compile(module) do
      typespecs when is_map(typespecs) -> {:ok, typespecs}
      _ -> :error
    end
  end
end
