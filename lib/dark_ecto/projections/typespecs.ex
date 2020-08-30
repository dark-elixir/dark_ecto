defmodule DarkEcto.Projections.Typespecs do
  @moduledoc """
  Cast typespecs
  """

  alias DarkEcto.Projections.Shared
  alias DarkEcto.Projections.Types
  alias DarkEcto.Reflections.EctoSchemaFields
  alias DarkEcto.Reflections.EctoSchemaReflection

  @ecto_mapping Map.get(Types.permuted_conversion_mappings(), :ecto_to_typespec)

  def cast(%{attrs: attrs}) when is_list(attrs) do
    schema_fields = %EctoSchemaFields{
      required_fields: Keyword.keys(attrs),
      non_virtual_fields: attrs
    }

    typespec = Shared.cast_schema(schema_fields, &resolve/2)

    schema_fields
    |> Map.from_struct()
    |> Map.merge(%{
      typespec: typespec
    })
  end

  def cast(schema) when is_atom(schema) do
    schema_fields = EctoSchemaFields.cast(schema)
    typespec = Shared.cast_schema(schema_fields, &resolve/2)

    schema_fields
    |> Map.from_struct()
    |> Map.merge(%{
      typespec: typespec
    })
  end

  # __meta__: Ecto.Schema.Metadata.t(),
  # def template({:ecto, type}), do: "#{Shared.resolve_alias(type)}.t() | Ecto.Association.NotLoaded.t() | nil"
  def template({:primary_key, :id}), do: "SFX.primary_key()"
  def template({:foreign_key, :id}), do: "SFX.foreign_key() | nil"
  def template({:module, type}), do: "#{Shared.resolve_alias(type)}.t()"
  def template({:array, type}), do: "[#{type}]"
  def template({:map, type}), do: "%{optional(any()) => #{type}}"
  def template({:text, _type}), do: "String.t()"
  def template({:any, _type}), do: "any()"
  def template({:__FALLBACK__, type}), do: template({:any, type})

  def resolve({:id, {:primary_key, :id}}, _opts),
    do: {:id, "SFX.primary_key()"}

  def resolve({field, {:foreign_key, :id}}, _opts),
    do: {field, "SFX.foreign_key() | nil"}

  def resolve({field, {:primary_key, inner}}, opts),
    do: resolve({field, inner}, opts)

  def resolve({field, {:foreign_key, inner}}, opts),
    do: resolve({field, inner}, opts)

  def resolve({field, {:one, inner}}, opts),
    do: resolve({field, inner}, opts)

  def resolve({field, {:many, inner}}, opts),
    do: resolve({field, {:array, inner}}, opts)

  def resolve({field, {:map, inner}}, opts),
    do: {field, template({:map, inner({field, inner}, opts)})}

  def resolve({field, {:array, inner}}, opts),
    do: {field, template({:array, inner({field, inner}, opts)})}

  def resolve({field, type}, opts) when is_atom(type) do
    read_ecto_type_def? = Keyword.get(opts, :read_ecto_type_def?, false)

    cond do
      Keyword.has_key?(@ecto_mapping, type) ->
        {field, Keyword.get(@ecto_mapping, type)}

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
