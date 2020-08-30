defmodule DarkEcto.Projections.Shared do
  @moduledoc """
  Shared castings
  """

  # credo:disable-for-next-line Credo.Check.Readability.AliasAs
  alias Absinthe.Utils, as: AbsintheUtils
  alias DarkEcto.Reflections.EctoSchemaFields

  @exclude_key :__EXCLUDE__

  def cast_schema(%EctoSchemaFields{required_fields: required_fields} = schema_fields, fun)
      when is_function(fun) do
    {required_non_virtual_fields, optional_non_virtual_fields} =
      Enum.split_with(schema_fields.non_virtual_fields, &(&1 in required_fields))

    []
    |> Enum.concat(cast_list(schema_fields.pk_fields, fun, modifier: :primary_key))
    |> Enum.concat(cast_list(schema_fields.fk_fields, fun, modifier: :foreign_key))
    |> Enum.concat(cast_list(required_non_virtual_fields, fun, modifier: :required))
    |> Enum.concat(cast_list(optional_non_virtual_fields, fun))
    # |> Enum.concat(cast_list(schema_fields.non_virtual_fields, fun))
    |> Enum.concat(cast_list(schema_fields.virtual_fields, fun))
    |> Enum.concat(cast_list(schema_fields.one_relations, fun, modifier: :one))
    |> Enum.concat(cast_list(schema_fields.many_relations, fun, modifier: :many))
    |> maybe_map_fields_from_struct(schema_fields, fun)
  end

  def cast_schema_with_embeds(
        %EctoSchemaFields{required_fields: required_fields} = schema_fields,
        fun
      )
      when is_function(fun) do
    {required_non_virtual_fields, optional_non_virtual_fields} =
      Enum.split_with(schema_fields.non_virtual_fields, &(&1 in required_fields))

    []
    |> Enum.concat(cast_list(schema_fields.pk_fields, fun, modifier: :primary_key))
    |> Enum.concat(cast_list(schema_fields.fk_fields, fun, modifier: :foreign_key))
    |> Enum.concat(cast_list(required_non_virtual_fields, fun, modifier: :required))
    |> Enum.concat(cast_list(optional_non_virtual_fields, fun))
    # |> Enum.concat(cast_list(schema_fields.non_virtual_fields, fun))
    |> Enum.concat(cast_list(schema_fields.virtual_fields, fun))
    |> Enum.concat(cast_list(schema_fields.one_relations, fun, modifier: :one))
    |> Enum.concat(cast_list(schema_fields.many_relations, fun, modifier: :many))
    |> Enum.concat(cast_list(schema_fields.embed_one_relations, fun, modifier: :one))
    |> Enum.concat(cast_list(schema_fields.embed_many_relations, fun, modifier: :many))
    |> maybe_map_fields_from_struct(schema_fields, fun)
  end

  def maybe_map_fields_from_struct([], %EctoSchemaFields{module: module}, fun) do
    module
    |> struct_fields()
    |> Enum.map(&{&1, :map})
    |> cast_list(fun)
  end

  def maybe_map_fields_from_struct(mapped_fields, _, _) do
    mapped_fields
  end

  def struct_fields(module) when is_atom(module) do
    if function_exported?(module, :__struct__, 0) do
      module
      |> struct()
      |> Map.from_struct()
      |> Map.keys()
    else
      []
    end
  end

  def cast_list(field_typings, cast, opts \\ [])
      when is_list(field_typings) and is_function(cast) do
    for {field, ecto_type} <- field_typings,
        {field, typing} = cast_typing(cast, {field, ecto_type}, opts),
        not excluded?(typing) do
      {field, typing}
    end
  end

  def cast_typing(cast, {field, ecto_type}, opts) do
    ecto_type_with_opts =
      case Enum.into(opts, %{}) do
        %{modifier: modifier} -> {modifier, ecto_type}
        _ -> ecto_type
      end

    cast.({field, ecto_type_with_opts}, opts)
  end

  @doc """
  Determine if a `module` implements the `Ecto.Type` behaviour.
  """
  @spec ecto_type?(any) :: boolean
  def ecto_type?(module) when is_atom(module) do
    function_exported?(module, :__info__, 1) and
      function_exported?(module, :cast, 1) and
      function_exported?(module, :type, 0)
  end

  def ecto_type?(_), do: false

  def excluded?(typing) do
    String.contains?(inspect(typing), "#{@exclude_key}")
  end

  def translate_keys(list, fun) do
    for {k, v} <- list, do: {fun.(k), v}
  end

  def translate_values(list, fun) do
    for {k, v} <- list, do: {k, fun.(v)}
  end

  def resolve_alias(type) when is_atom(type) do
    "#{EctoSchemaFields.module_alias(type)}"
  end

  def resolve_alias(type) when is_binary(type) do
    type
  end

  def resolve_singular(type) do
    EctoSchemaFields.singular(type)
  end

  def pascal(atom, opts \\ [lower: true])

  def pascal(atom, opts) when is_atom(atom) do
    atom |> Atom.to_string() |> pascal(opts)
  end

  def pascal(binary, opts) when is_binary(binary) do
    AbsintheUtils.camelize(binary, opts)
  end

  def camel(atom, opts \\ [lower: true])

  def camel(atom, opts) when is_atom(atom) do
    atom |> Atom.to_string() |> camel(opts)
  end

  def camel(binary, opts) when is_binary(binary) do
    AbsintheUtils.camelize(binary, opts)
  end

  def snake(atom) when is_atom(atom) do
    atom |> Atom.to_string() |> snake()
  end

  def snake(binary) when is_binary(binary) do
    Macro.underscore(binary)
  end
end
