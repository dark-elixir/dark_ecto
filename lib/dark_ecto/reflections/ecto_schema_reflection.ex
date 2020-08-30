defmodule DarkEcto.Reflections.EctoSchemaReflection do
  @moduledoc """
  Utils for introspecting an `Ecto.Schema`.
  """

  defstruct ecto_schema?: false,
            assocs: [],
            embeds: [],
            primary_key_fields: [],
            non_virtual_fields: [],
            virtual_fields: []

  @type field() :: atom()
  @type schema() :: module()
  @type ecto_type() :: atom()
  @type ecto_field() :: {field(), ecto_type()}
  @type assoc() ::
          %{required(:__struct__) => Ecto.Association.BelongsTo, optional(:atom) => any()}
          | %{required(:__struct__) => Ecto.Association.Has, optional(:atom) => any()}
          | %{required(:__struct__) => Ecto.Association.HasThrough, optional(:atom) => any()}
          | %{required(:__struct__) => Ecto.Association.ManyToMany, optional(:atom) => any()}

  @type embed() :: Ecto.Embedded.t()

  @type t() :: %__MODULE__{
          ecto_schema?: boolean,
          assocs: [assoc()],
          embeds: [embed()],
          primary_key_fields: [ecto_field()],
          non_virtual_fields: [ecto_field()],
          virtual_fields: [field()]
        }

  @date_types [
    :date
  ]
  @datetime_types [
    # :naive_datetime,
    # :naive_datetime_usec,
    :utc_datetime,
    :utc_datetime_usec
  ]
  @naive_datetime_types [
    :naive_datetime,
    :naive_datetime_usec
  ]

  @time_types [
    :time,
    :time_usec
  ]

  def date_type?(type) when type in @date_types, do: true
  def date_type?(_type), do: false

  def datetime_type?(type) when type in @datetime_types, do: true
  def datetime_type?(_type), do: false

  def naive_datetime_type?(type) when type in @naive_datetime_types, do: true
  def naive_datetime_type?(_type), do: false

  def decimal_type?(type) when type in [:decimal], do: true
  def decimal_type?(_type), do: false

  def time_type?(type) when type in @time_types, do: true
  def time_type?(_type), do: false

  def describe(schema) when is_atom(schema) do
    %__MODULE__{
      ecto_schema?: ecto_schema?(schema),
      assocs: assocs(schema),
      embeds: embeds(schema),
      primary_key_fields: primary_key_fields(schema),
      non_virtual_fields: non_virtual_fields(schema),
      virtual_fields: virtual_fields(schema)
    }
  end

  @doc """
  Determine if something is an `Ecto.Schema` via duck typing.
  """
  @spec ecto_schema?(any()) :: boolean()
  def ecto_schema?(%{__struct__: _, __meta__: _}) do
    true
  end

  def ecto_schema?(%{__struct__: module}) when is_atom(module) do
    ecto_schema?(module)
  end

  def ecto_schema?(module) when is_atom(module) do
    Kernel.function_exported?(module, :__schema__, 1)
  end

  def ecto_schema?(_) do
    false
  end

  @doc """
  Returns the primary key fields associated with the `schema`.
  """
  @spec primary_key_fields(schema()) :: [{field(), type :: atom()}]
  def primary_key_fields(schema) when is_atom(schema) do
    if ecto_schema?(schema) do
      for field <- schema.__schema__(:primary_key),
          type = schema.__schema__(:type, field) do
        {field, type}
      end
    else
      []
    end
  end

  @doc """
  Returns the fields by type from the given `schema`.

    Ecto type               | Elixir type             | Literal syntax in query
    :---------------------- | :---------------------- | :---------------------
    `:id`                   | `integer`               | 1, 2, 3
    `:binary_id`            | `binary`                | `<<int, int, int, ...>>`
    `:integer`              | `integer`               | 1, 2, 3
    `:float`                | `float`                 | 1.0, 2.0, 3.0
    `:boolean`              | `boolean`               | true, false
    `:string`               | UTF-8 encoded `string`  | "hello"
    `:binary`               | `binary`                | `<<int, int, int, ...>>`
    `{:array, inner_type}`  | `list`                  | `[value, value, value, ...]`
    `:map`                  | `map` |
    `{:map, inner_type}`    | `map` |
    `:decimal`              | [`Decimal`](https://github.com/ericmj/decimal) |
    `:date`                 | `Date` |
    `:time`                 | `Time` |
    `:time_usec`            | `Time` |
    `:naive_datetime`       | `NaiveDateTime` |
    `:naive_datetime_usec`  | `NaiveDateTime` |
    `:utc_datetime`         | `DateTime` |
    `:utc_datetime_usec`    | `DateTime` |
  """
  @spec non_virtual_fields(schema()) :: [{field(), type :: atom()}]
  def non_virtual_fields(schema) when is_atom(schema) do
    if ecto_schema?(schema) do
      for field <- schema.__schema__(:fields),
          # field not in Keyword.keys(primary_key_fields(schema)),
          field not in Enum.map(assocs(schema), & &1.field),
          field not in Enum.map(embeds(schema), & &1.field),
          type = schema.__schema__(:type, field) do
        {field, type}
      end
    else
      []
    end
  end

  @doc """
  List virtual fields on an `Ecto.Schema`.
  """
  @spec virtual_fields(schema()) :: [field()]
  def virtual_fields(schema) when is_atom(schema) do
    if ecto_schema?(schema) do
      for field <- keys(schema),
          field not in Keyword.keys(non_virtual_fields(schema)),
          field not in Enum.map(assocs(schema), & &1.field),
          field not in Enum.map(embeds(schema), & &1.field) do
        # type = schema.__schema__(:type, field) do
        # {field, type}
        field
      end
    else
      []
    end
  end

  @doc """
  List associations on an `Ecto.Schema`.
  """
  @spec assocs(schema()) :: [Ecto.Association.t()]
  def assocs(schema) when is_atom(schema) do
    if ecto_schema?(schema) do
      for field <- schema.__schema__(:associations),
          assoc = schema.__schema__(:association, field) do
        assoc
      end
    else
      []
    end
  end

  @doc """
  List embeds on an `Ecto.Schema`.
  """
  @spec embeds(schema()) :: [Ecto.Embedded.t()]
  def embeds(schema) when is_atom(schema) do
    if ecto_schema?(schema) do
      for field <- schema.__schema__(:embeds),
          assoc = schema.__schema__(:embed, field) do
        assoc
      end
    else
      []
    end
  end

  @doc """
  List fields by given `types`.
  """
  @spec non_virtual_fields_by_types(schema(), [type :: atom()]) :: [field()]
  def non_virtual_fields_by_types(schema, types) when is_atom(schema) and is_list(types) do
    for {field, type} <- non_virtual_fields(schema), type in types, do: field
  end

  @doc """
  List fields with types `#{inspect(@date_types)}`.
  """
  @spec non_virtual_date_fields(schema()) :: [field()]
  def non_virtual_date_fields(schema) when is_atom(schema) do
    non_virtual_fields_by_types(schema, @date_types)
  end

  @doc """
  List fields with types `#{inspect(@datetime_types)}`.
  """
  @spec non_virtual_datetime_fields(schema()) :: [field()]
  def non_virtual_datetime_fields(schema) when is_atom(schema) do
    non_virtual_fields_by_types(schema, @datetime_types)
  end

  @doc """
  List fields with types `#{inspect(@naive_datetime_types)}`.
  """
  @spec non_virtual_naive_datetime_fields(schema()) :: [field()]
  def non_virtual_naive_datetime_fields(schema) when is_atom(schema) do
    non_virtual_fields_by_types(schema, @naive_datetime_types)
  end

  @doc """
  List fields with types `#{inspect(@time_types)}`.
  """
  @spec non_virtual_time_fields(schema()) :: [field()]
  def non_virtual_time_fields(schema) when is_atom(schema) do
    non_virtual_fields_by_types(schema, @time_types)
  end

  @doc """
  List all keys on an `Ecto.Schema.t()`
  """
  @spec keys(module() | Ecto.Schema.t()) :: [field()]
  def keys(%{__struct__: _, __meta__: _} = struct) do
    struct
    |> from_struct()
    |> Map.keys()
  end

  def keys(%{__struct__: module} = struct) do
    # Handle embed case without `:__meta__`
    if ecto_schema?(module) do
      struct
      |> Map.from_struct()
      |> Map.keys()
    else
      []
    end
  end

  def keys(module) when is_atom(module) do
    module
    |> struct()
    |> keys()
  end

  @doc """
  Transform an `Ecto.Schema.t()` into a plain map.
  """
  @spec from_struct(Ecto.Schema.t()) :: %{required(:atom) => any()}
  def from_struct(%{__struct__: _, __meta__: _} = struct) do
    struct
    |> Map.from_struct()
    |> Map.drop([:__meta__])
  end
end
