defmodule DarkEcto.Projections.Typescript do
  @moduledoc """
  Cast `Typescript` types
  """

  alias DarkEcto.Projections.Shared
  alias DarkEcto.Projections.Types
  alias DarkEcto.Reflections.EctoSchemaFields
  alias DarkEcto.Reflections.EctoSchemaReflection

  alias DarkMatter.Inflections

  @ecto_mapping Map.get(Types.permuted_conversion_mappings(), :ecto_to_typescript)

  def cast(schema) when is_atom(schema) do
    schema_fields = EctoSchemaFields.cast(schema)
    plural = Shared.pascal(schema_fields.plural)
    singular = Shared.pascal(schema_fields.singular)
    one_relations = Shared.translate_keys(schema_fields.one_relations, &Shared.pascal/1)
    many_relations = Shared.translate_keys(schema_fields.many_relations, &Shared.pascal/1)

    embed_one_relations =
      Shared.translate_keys(schema_fields.embed_one_relations, &Shared.pascal/1)

    embed_many_relations =
      Shared.translate_keys(schema_fields.embed_many_relations, &Shared.pascal/1)

    type_d =
      schema_fields
      |> Shared.cast_schema_with_embeds(&resolve/2)
      |> Shared.translate_keys(&Shared.pascal/1)

    factory =
      []
      |> Enum.concat(one_relations |> Enum.map(&factory_one/1))
      |> Enum.concat(many_relations |> Enum.map(&factory_many/1))
      |> Enum.concat(embed_one_relations |> Enum.map(&factory_one/1))
      |> Enum.concat(embed_many_relations |> Enum.map(&factory_many/1))

    schema_fields
    |> Map.from_struct()
    |> Map.merge(%{
      plural: plural,
      singular: singular,
      one_relations: one_relations,
      many_relations: many_relations,
      embed_one_relations: embed_one_relations,
      embed_many_relations: embed_many_relations,
      type_d: type_d,
      factory: factory
    })
  end

  def template({:module, type}), do: "#{Shared.resolve_alias(type)}"
  def template({:array, type}), do: "#{type}[]"
  def template({:map, _type}), do: "Object"
  def template({:any, _type}), do: "any"
  def template({:__FALLBACK__, type}), do: template({:any, type})

  def resolve({field, {:primary_key, inner}}, opts),
    do: resolve({field, inner}, opts)

  def resolve({field, {:foreign_key, inner}}, opts),
    do: resolve({field, inner}, opts)

  def resolve({field, {:one, inner}}, opts),
    do: resolve({field, inner}, opts)

  def resolve({field, {:many, inner}}, opts),
    do: resolve({field, {:array, inner}}, opts)

  def resolve({field, {:map, inner}}, _opts),
    do: {field, template({:map, inner})}

  def resolve({field, {:array, inner}}, opts),
    do: {field, template({:array, inner({field, inner}, opts)})}

  def resolve({field, type}, opts) when is_atom(type) do
    read_ecto_type_def? = Keyword.get(opts, :read_ecto_type_def?, false)

    cond do
      Keyword.has_key?(@ecto_mapping, type) ->
        case Keyword.get(@ecto_mapping, type) do
          typing when is_atom(typing) -> {field, to_string(typing)}
          typing -> {field, typing}
        end

      read_ecto_type_def? and Shared.ecto_type?(type) ->
        # Use value from `Ecto.Type.type/0`
        resolve({field, type.type()}, opts)

      Shared.ecto_type?(type) ->
        {field, template({:module, type})}

      EctoSchemaReflection.ecto_schema?(type) ->
        {field, template({:module, type})}

      true ->
        {field, template({:__FALLBACK__, type})}
    end
  end

  def factory_one({k, :__ecto_join_table__}) do
    # {k, "#{Inflections.binary(k, :absinthe_camel)}Factory.build()"}
    {k, "#{Inflections.binary(k, :absinthe_camel)}.build()"}
  end

  def factory_one({k, v}) do
    # {k, "#{Inflections.binary(Shared.resolve_alias(v), :absinthe_camel)}Factory.build()"}
    {k, "#{Inflections.binary(Shared.resolve_alias(v), :absinthe_camel)}.build()"}
  end

  def factory_many({k, :__ecto_join_table__}) do
    # {k, "#{Inflections.binary(k, [:singular, :absinthe_camel])}Factory.buildList(0)"}
    {k, "#{Inflections.binary(k, [:singular, :absinthe_camel])}.buildList(0)"}
  end

  def factory_many({k, v}) do
    # {k, "#{Inflections.binary(Shared.resolve_alias(v), [:singular, :absinthe_camel])}Factory.buildList(0)"}
    {k,
     "#{Inflections.binary(Shared.resolve_alias(v), [:singular, :absinthe_camel])}.buildList(0)"}
  end

  def lodash("string[]") do
    "isString"
  end

  def lodash("Int[]") do
    "isSafeInteger"
  end

  def lodash(ts_type) when is_binary(ts_type) do
    # type =
    #   ts_type
    #   |> String.replace_trailing("[]", "")
    #   |> DarkMatter.Inflections.binary(:absinthe_pascal)

    # "is#{type}"
    nil
  end

  defp inner({field, inner}, opts) do
    {_field, type} = resolve({field, inner}, opts)
    type
  end

  # String Ids
  def factory_method({"id", _}) do
    "`${sequence}`"
  end

  def factory_method({k, v}) do
    if String.ends_with?(k, "Id") do
      "`${sequence}`"
    else
      "random(\"#{k}\", \"#{v}\")"
    end
  end

  # Integer Ids

  # def factory_method({"id", _}) do
  #   "sequence"
  # end

  # def factory_method({k, v}) do
  #   if String.ends_with?(k, "Id") and k not in ["shortId"] do
  #     "sequence"
  #   else
  #     "random(\"#{k}\", \"#{v}\")"
  #   end
  # end
end
