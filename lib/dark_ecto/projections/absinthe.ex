defmodule DarkEcto.Projections.Absinthe do
  @moduledoc """
  Cast `Absinthe` types
  """

  alias DarkEcto.Projections.Shared
  alias DarkEcto.Projections.Types
  alias DarkEcto.Reflections.EctoSchemaFields
  alias DarkEcto.Reflections.EctoSchemaReflection

  @ecto_mapping Map.get(Types.permuted_conversion_mappings(), :ecto_to_absinthe)

  def cast(schema) when is_atom(schema) do
    schema_fields = EctoSchemaFields.cast(schema)
    # plural = Shared.pascal(schema_fields.plural)
    # singular = Shared.pascal(schema_fields.singular)
    # one_relations = Shared.translate_keys(schema_fields.one_relations, &Shared.pascal/1)
    # many_relations = Shared.translate_keys(schema_fields.many_relations, &Shared.pascal/1)

    absinthe_type = schema_fields |> Shared.cast_schema(&resolve/2)
    #  |> Shared.translate_keys(&Shared.pascal/1)

    schema_fields
    |> Map.from_struct()
    |> Map.merge(%{
      # plural: plural,
      # singular: singular,
      # one_relations: one_relations,
      # many_relations: many_relations,
      absinthe_type: absinthe_type
    })
  end

  def template({:module, type}), do: ":#{Shared.resolve_singular(type)}"
  def template({:non_null, type}), do: "non_null(#{type})"
  def template({:required, type}), do: "non_null(#{type})"
  def template({:array, type}), do: "list_of(#{type})"
  def template({:map, _type}), do: ":json"
  def template({:json, _type}), do: ":json"
  def template({:__FALLBACK__, type}), do: template({:json, type})

  def resolve({field, {:primary_key, :id}}, _opts),
    do: {field, "non_null(:id)"}

  def resolve({field, {:foreign_key, :id}}, _opts),
    do: {field, ":id"}

  def resolve({field, {:primary_key, inner}}, opts),
    do: resolve({field, {:non_null, inner}}, opts)

  def resolve({field, {:foreign_key, inner}}, opts),
    do: resolve({field, inner}, opts)

  def resolve({field, {:one, inner}}, opts),
    do: resolve({field, inner}, opts)

  def resolve({field, {:many, inner}}, opts),
    do: resolve({field, {:array, inner}}, opts)

  def resolve({field, {:map, inner}}, _opts),
    do: {field, template({:map, inner})}

  def resolve({field, {:non_null, inner}}, opts),
    do: {field, template({:non_null, inner({field, inner}, opts)})}

  def resolve({field, {:array, inner}}, opts),
    do: {field, template({:array, inner({field, {:non_null, inner}}, opts)})}

  def resolve({field, type}, opts) when is_atom(type) do
    read_ecto_type_def? = Keyword.get(opts, :read_ecto_type_def?, false)

    cond do
      Keyword.has_key?(@ecto_mapping, type) ->
        case Keyword.get(@ecto_mapping, type) do
          typing when is_atom(typing) -> {field, inspect(typing)}
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

  defp inner({field, inner}, opts) do
    {_field, type} = resolve({field, inner}, opts)
    type
  end
end
