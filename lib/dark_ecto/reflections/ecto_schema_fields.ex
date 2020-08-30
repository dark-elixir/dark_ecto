defmodule DarkEcto.Reflections.EctoSchemaFields do
  @moduledoc """
  Utils for introspecting an `Ecto.Schema` fields.
  """

  alias DarkEcto.Reflections.EctoSchemaReflection

  defstruct [
    :alias,
    :alias_plural,
    :module,
    :plural,
    :singular,
    :human_plural,
    :human_singular,
    import_aliases: [],
    imports: [],
    assoc_imports: [],
    embed_imports: [],
    pk_fields: [],
    fk_fields: [],
    virtual_fields: [],
    non_virtual_fields: [],
    one_relations: [],
    many_relations: [],
    embed_one_relations: [],
    embed_many_relations: [],
    required_fields: [],
    enums: [],
    command_singulars: [:update],
    blank?: true,
    persisted?: false
  ]

  @type alias_mapping() :: {module(), module_alias :: atom()}
  @type field() :: atom()
  @type field_type() :: (primative :: atom()) | (ecto_type :: module())
  @type field_typing() :: {field(), field_type()}
  @type relation_typing() :: {field(), module()}

  @type typing() :: %{
          :field => any,
          :field_type => :foreign_key | {:assoc, any},
          :type => any,
          optional(:module) => any
        }

  @type t() :: %__MODULE__{
          alias: atom(),
          alias_plural: atom(),
          module: module(),
          plural: atom(),
          singular: atom(),
          human_plural: String.t(),
          human_singular: String.t(),
          import_aliases: [alias_mapping()],
          imports: [module()],
          assoc_imports: [module()],
          embed_imports: [module()],
          pk_fields: [field_typing()],
          fk_fields: [field_typing()],
          virtual_fields: [field_typing()],
          non_virtual_fields: [field_typing()],
          one_relations: [relation_typing()],
          many_relations: [relation_typing()],
          embed_one_relations: [relation_typing()],
          embed_many_relations: [relation_typing()],
          required_fields: [atom()],
          enums: Keyword.t(),
          command_singulars: [:update, ...],
          blank?: boolean(),
          persisted?: boolean()
        }

  @fk_types [:id, :binary_id, :uuid, Ecto.UUID]
  @timestamp_fields [:inserted_at, :updated_at]

  def fk?({_field, type}) when type in @fk_types, do: true
  def fk?({_field, _type}), do: false

  @doc """
  Transform an `Ecto.Schema` module into a `t:t/0`.
  """
  @spec cast(atom()) :: t()
  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  def cast(schema) when is_atom(schema) do
    reflection = EctoSchemaReflection.describe(schema)

    %{
      assocs: ecto_assocs,
      embeds: ecto_embeds,
      virtual_fields: virtuals,
      non_virtual_fields: non_virtuals,
      primary_key_fields: primary_keys
    } = reflection

    # Assocs / Embeds
    assocs = Enum.flat_map(ecto_assocs, &cast_typing(&1, {schema, reflection}))
    embeds = Enum.flat_map(ecto_embeds, &cast_typing/1)

    # Imports / Aliases
    assoc_imports = for %{module: module} <- assocs, is_atom(module), uniq: true, do: module
    embed_imports = for %{module: module} <- embeds, is_atom(module), uniq: true, do: module
    imports = assoc_imports ++ embed_imports
    import_aliases = for module <- imports, uniq: true, do: alias_mapping(module)

    # Relations
    relations = %{
      one: for(%{field_type: {:assoc, :one}} = typing <- assocs, do: cast_field(typing)),
      many: for(%{field_type: {:assoc, :many}} = typing <- assocs, do: cast_field(typing)),
      embed_one: for(%{field_type: {:assoc, :one}} = typing <- embeds, do: cast_field(typing)),
      embed_many: for(%{field_type: {:assoc, :many}} = typing <- embeds, do: cast_field(typing))
    }

    # Fields / Virtual Fields
    fields = %{
      pk: for(typing <- primary_keys, do: cast_field_typing(typing)),
      virtual: for(typing <- virtuals, do: cast_virtual_field(typing)),
      non_virtual: for(typing <- non_virtuals, do: cast_field_typing(typing)),
      assoc_fk: for(%{field_type: :foreign_key} = typing <- assocs, do: cast_field(typing)),
      non_virtual_fk: for(typing <- non_virtuals, fk?(typing), do: cast_field_typing(typing))
    }

    # Enums
    enums =
      with true <- function_exported?(schema, :enums, 0),
           enums when is_map(enums) <- schema.enums() do
        enums |> Enum.into([]) |> Enum.sort()
      else
        _ -> []
      end

    # Required Fields
    required_fields =
      with true <- function_exported?(schema, :required_fields, 0),
           required_fields when is_map(required_fields) <- schema.required_fields() do
        required_fields |> Enum.into([]) |> Enum.sort()
      else
        _ -> []
      end

    fk_fields =
      fields.assoc_fk
      |> Keyword.merge(fields.non_virtual_fk)
      |> Keyword.drop(Keyword.keys(fields.pk))

    %__MODULE__{
      alias: module_alias(schema),
      alias_plural: schema |> module_alias() |> Inflex.pluralize() |> String.to_atom(),
      module: schema,
      plural: plural(schema),
      singular: singular(schema),
      human_plural: human_plural(schema),
      human_singular: human_singular(schema),
      import_aliases: Enum.sort(import_aliases),
      imports: Enum.sort(imports),
      assoc_imports: Enum.sort(assoc_imports),
      embed_imports: Enum.sort(embed_imports),
      pk_fields: Enum.sort(fields.pk),
      fk_fields: Enum.sort(fk_fields),
      virtual_fields: Enum.sort(fields.virtual),
      non_virtual_fields: sort_non_virtual_fields(fields, fk_fields),
      one_relations: Enum.sort(relations.one),
      many_relations: Enum.sort(relations.many),
      embed_one_relations: Enum.sort(relations.embed_one),
      embed_many_relations: Enum.sort(relations.embed_many),
      required_fields: required_fields,
      enums: enums,
      blank?:
        relations.one == [] and relations.many == [] and relations.embed_one == [] and
          relations.embed_many == [] and
          fields.non_virtual == [] and fields.pk == [] and fields.assoc_fk == [] and
          fields.non_virtual_fk == [],
      persisted?: persisted?(schema)
    }
  end

  def persisted?(schema) do
    if function_exported?(schema, :__struct__, 0) do
      meta = schema |> struct() |> Map.get(:__meta__)
      not is_nil(meta)
    else
      false
    end
  end

  def sort_non_virtual_fields(fields, fk_fields) do
    # Put timestamp fields at the end
    {timestamp_fields, non_virtual_no_k_fields} =
      Keyword.split(fields.non_virtual -- Enum.uniq(fields.pk ++ fk_fields), @timestamp_fields)

    Enum.sort(non_virtual_no_k_fields) ++ timestamp_fields
  end

  @spec module_alias(module()) :: atom()
  def module_alias(module) when is_atom(module) do
    module
    |> Module.split()
    |> List.last()
    |> String.to_atom()
  end

  @spec alias_mapping(module()) :: alias_mapping()
  def alias_mapping(module) when is_atom(module) do
    {module, module_alias(module)}
  end

  def plural(module) do
    module
    |> module_alias()
    |> Atom.to_string()
    |> Recase.to_snake()
    |> Inflex.pluralize()
    |> String.to_atom()
  end

  def singular(module) do
    module
    |> module_alias()
    |> Atom.to_string()
    |> Recase.to_snake()
    |> Inflex.singularize()
    |> String.to_atom()
  end

  def plural_atom(key) when is_atom(key) do
    key
    |> Atom.to_string()
    |> plural_atom()
  end

  def plural_atom(key) when is_binary(key) do
    key
    |> Recase.to_snake()
    |> Inflex.pluralize()
    |> String.to_atom()
  end

  def singular_atom(key) when is_atom(key) do
    key
    |> Atom.to_string()
    |> singular_atom()
  end

  def singular_atom(key) when is_binary(key) do
    key
    |> Recase.to_snake()
    |> Inflex.singularize()
    |> String.to_atom()
  end

  def human_plural(module) do
    module
    |> plural()
    |> Phoenix.Naming.humanize()
  end

  def human_singular(module) do
    module
    |> singular()
    |> Phoenix.Naming.humanize()
  end

  def singular?(atom) when is_atom(atom) do
    atom |> Atom.to_string() |> singular?()
  end

  def singular?(binary) when is_binary(binary) do
    binary == Inflex.singularize(binary)
  end

  def plural?(atom) when is_atom(atom) do
    atom |> Atom.to_string() |> plural?()
  end

  def plural?(binary) when is_binary(binary) do
    binary == Inflex.pluralize(binary)
  end

  @spec cast_field(typing()) :: field_typing()
  def cast_field(%{field_type: _field_type, field: field, type: type}) do
    {field, type}
  end

  @spec cast_field_typing(field_typing()) :: field_typing()
  def cast_field_typing({field, type}) do
    {field, type}
  end

  @spec cast_virtual_field(field :: atom) :: {field :: atom, :__ecto_virtual_field__}
  def cast_virtual_field(field) when is_atom(field) do
    {field, :__ecto_virtual_field__}
  end

  @doc """
  Provide a simple common description of embeds and schemas.

  ## Ecto.Embedded

    The association struct for a `embeds` or `embeds_many` association.

    Its fields are:
      * `:cardinality` - tells if there is one embedded schema or many
      * `:related` - name of the embedded schema
      * `:on_replace` - the action taken on embeds when the embed is replaced

  ## Ecto.Association.BelongsTo

    The association struct for a `belongs_to` association.

    Its fields are:
      * `cardinality` - The association cardinality
      * `field` - The name of the association field on the schema
      * `owner` - The schema where the association was defined
      * `owner_key` - The key on the `owner` schema used for the association
      * `related` - The schema that is associated
      * `related_key` - The key on the `related` schema used for the association
      * `queryable` - The real query to use for querying association
      * `defaults` - Default fields used when building the association
      * `relationship` - The relationship to the specified schema, default `:parent`
      * `on_replace` - The action taken on associations when schema is replaced

  ## Ecto.Association.Has

      The association struct for `has_one` and `has_many` associations.
      Its fields are:
        * `cardinality` - The association cardinality
        * `field` - The name of the association field on the schema
        * `owner` - The schema where the association was defined
        * `related` - The schema that is associated
        * `owner_key` - The key on the `owner` schema used for the association
        * `related_key` - The key on the `related` schema used for the association
        * `queryable` - The real query to use for querying association
        * `on_delete` - The action taken on associations when schema is deleted
        * `on_replace` - The action taken on associations when schema is replaced
        * `defaults` - Default fields used when building the association
        * `relationship` - The relationship to the specified schema, default is `:child`


  ## Ecto.Association.HasThrough

      The association struct for `has_one` and `has_many` through associations.
      Its fields are:
        * `cardinality` - The association cardinality
        * `field` - The name of the association field on the schema
        * `owner` - The schema where the association was defined
        * `owner_key` - The key on the `owner` schema used for the association
        * `through` - The through associations
        * `relationship` - The relationship to the specified schema, default `:child`

  ## Ecto.Association.ManyToMany

      The association struct for `many_to_many` associations.
      Its fields are:
        * `cardinality` - The association cardinality
        * `field` - The name of the association field on the schema
        * `owner` - The schema where the association was defined
        * `related` - The schema that is associated
        * `owner_key` - The key on the `owner` schema used for the association
        * `queryable` - The real query to use for querying association
        * `on_delete` - The action taken on associations when schema is deleted
        * `on_replace` - The action taken on associations when schema is replaced
        * `defaults` - Default fields used when building the association
        * `relationship` - The relationship to the specified schema, default `:child`
        * `join_keys` - The keyword list with many to many join keys
        * `join_through` - Atom (representing a schema) or a string (representing a table)
          for many to many associations
        * `join_defaults` - A list of defaults for join associations
  """
  @spec cast_typing(
          # Ecto.Association.BelongsTo.t()
          # | Ecto.Association.Has.t()
          # | Ecto.Association.HasThrough.t()
          # | Ecto.Association.ManyToMany.t()
          # | Ecto.Embedded.t()
          struct(),
          nil | {schema :: module(), reflection :: struct()}
        ) :: [typing(), ...]
  def cast_typing(struct, schema_reflection_tuple \\ nil)

  def cast_typing(%Ecto.Embedded{field: field} = embed, _schema_reflection_tuple) do
    [
      %{
        field_type: {:assoc, embed.cardinality},
        field: field,
        type: embed.related,
        module: embed.related
      }
    ]
  end

  def cast_typing(%Ecto.Association.BelongsTo{field: field} = assoc, _schema_reflection_tuple) do
    [
      %{
        field_type: :foreign_key,
        field: assoc.owner_key,
        type: :id
      },
      %{
        field_type: {:assoc, assoc.cardinality},
        field: field,
        type: assoc.related,
        module: assoc.related
      }
    ]
  end

  def cast_typing(%Ecto.Association.Has{field: field} = assoc, _schema_reflection_tuple) do
    [
      %{
        field_type: {:assoc, assoc.cardinality},
        field: field,
        type: assoc.related,
        module: assoc.related
      }
    ]
  end

  def cast_typing(
        %Ecto.Association.HasThrough{field: field, through: [from_assoc_field, to_assoc_field]} =
          assoc,
        {_schema, reflection}
      ) do
    with %{related: from_related} <-
           Enum.find(reflection.assocs, &(&1.field == from_assoc_field)),
         from_related_reflection <- EctoSchemaReflection.describe(from_related),
         %{related: releated_schema} = _to_assoc <-
           Enum.find(from_related_reflection.assocs, &(&1.field == to_assoc_field)) do
      [
        %{
          field_type: {:assoc, assoc.cardinality},
          field: field,
          type: releated_schema
        }
      ]
    else
      # %Ecto.Association.HasThrough{} = through_assoc -> cast_typing(through_assoc,  {schema, reflection})

      _ -> cast_typing(assoc, nil)
    end
  end

  def cast_typing(%Ecto.Association.HasThrough{field: field} = assoc, _schema_reflection_tuple) do
    [
      %{
        field_type: {:assoc, assoc.cardinality},
        field: field,
        type: :__ecto_join_table__
      }
    ]
  end

  def cast_typing(%Ecto.Association.ManyToMany{field: field} = assoc, _schema_reflection_tuple) do
    [
      %{
        field_type: {:assoc, assoc.cardinality},
        field: field,
        type: assoc.related,
        module: assoc.related
      }
    ]
  end
end
