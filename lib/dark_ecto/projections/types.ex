defmodule DarkEcto.Projections.Types do
  @moduledoc """
  Type conversions
  """

  alias DarkEcto.Projections.PermuteConversions

  # @types [:ecto, :postgrex, :typespec, :cli, :typescript, :absinthe, :prop_schema]
  # @types [:ecto, :absinthe, :typespec, :typescript, :cli]

  @types [:ecto, :absinthe, :typespec, :typescript]
  @typings [
    # Primative
    {:binary, :string, "String.t()", "string"},
    {:string, :string, "String.t()", "string"},
    {:boolean, :boolean, "boolean()", "boolean"},

    # Numeric
    {:float, :float, "float()", "number"},
    {:integer, :integer, "integer()", "Int"},
    {:decimal, :decimal, "Decimal.t()", "Decimal"},

    # Date / Time
    {:time, :time, "Time.t()", "TimeStr"},
    {:time_usec, :time, "Time.t()", "TimeStr"},
    {:date, :date, "Date.t()", "DateStr"},
    {:naive_datetime, :naive_datetime, "NaiveDateTime.t()", "DateTimeStr"},
    {:naive_datetime_usec, :naive_datetime, "NaiveDateTime.t()", "DateTimeStr"},
    {:utc_datetime, :datetime, "DateTime.t()", "DateTimeStr"},
    {:utc_datetime_usec, :datetime, "DateTime.t()", "DateTimeStr"},

    # Compound
    {:map, :json, "map()", "Object"},

    # Nested
    # {:array, inner}
    # {:map, inner}

    # Keys
    # {:id, :id, "SFX.primary_key()", "ID"},
    {:id, :id, "SFX.foreign_key()", "ID"},
    {:binary_id, :uuid4, "Ecto.UUID.t()", "UUID4"},
    {Ecto.UUID, :uuid4, "Ecto.UUID.t()", "UUID4"},

    # Specialized
    {:inet, :inet, "Postgrex.INET()", "IPv4"},
    {EctoFields.URL, :string, "String.t()", "UrlStr"},
    {EctoNetwork.INET, :inet, "Postgrex.INET()", "IPv4"},
    {Postgrex.INET, :inet, "Postgrex.INET()", "IPv4"},

    # Custom
    {SFX.Ecto.Types.DriversLicenseNumberType, :string, "String.t()", "string"},
    {SFX.Ecto.Types.EmailType, :string, "String.t()", "string"},
    {SFX.Ecto.Types.FederalTaxIdType, :string, "String.t()", "string"},
    {SFX.Ecto.Types.ImageBase64Type, :string, "String.t()", "string"},
    {SFX.Ecto.Types.SSNType, :string, "String.t()", "string"},
    {SFX.Ecto.Types.USPhoneNumberType, :string, "String.t()", "string"},
    {SFX.Ecto.Types.JsonLogicType, :json, "SFX.Ecto.Types.JsonLogicType.t()", "JsonLogicObject"},

    # Incomplete knowledge

    {:__ecto_virtual_field__, :__EXCLUDE__, "virtual :: any()", "any"},
    {:__ecto_join_table__, :__EXCLUDE__, "join_table :: struct()", "Object"}
    # {:__ecto_virtual_field__, :__virtual__, "virtual :: any()", "any"},
    # {:__ecto_join_table__, :__join_table__, "join_table :: struct()", "Object"}
  ]

  def permuted_conversion_mappings(opts \\ []) do
    types = Keyword.get(opts, :types, [])
    typings = Keyword.get(opts, :typings, [])
    PermuteConversions.permute_conversion_mappings!(@types ++ types, @typings ++ typings)
  end

  def absinthe_field_types do
    for typing <- @typings,
        absinthe_type = elem(typing, 1),
        absinthe_type not in [:__EXCLUDE__] do
      absinthe_type
    end
  end
end
