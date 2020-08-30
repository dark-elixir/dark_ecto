defmodule ExampleEctoSchemaEmbed do
  @moduledoc false
  use Ecto.Schema

  embedded_schema do
  end
end

defmodule ExampleEctoSchemaHasOne do
  @moduledoc false
  use Ecto.Schema

  schema "example" do
  end
end

defmodule ExampleEctoSchemaHasMany do
  @moduledoc false
  use Ecto.Schema

  schema "example" do
  end
end

defmodule ExampleEctoSchema do
  @moduledoc false
  use Ecto.Schema

  schema "example" do
    field :decimal, :decimal
    field :float, :float
    field :integer, :integer
    field :string, :string
    field :naive_datetime, :naive_datetime
    field :naive_datetime_usec, :naive_datetime_usec
    field :utc_datetime, :utc_datetime
    field :utc_datetime_usec, :utc_datetime_usec
    field :date, :date
    field :time, :time
    field :time_usec, :time_usec
    field :virtual_decimal, :decimal, virtual: true
    field :virtual_float, :float, virtual: true
    field :virtual_integer, :integer, virtual: true
    field :virtual_string, :string, virtual: true
    field :virtual_naive_datetime, :naive_datetime, virtual: true
    field :virtual_naive_datetime_usec, :naive_datetime_usec, virtual: true
    field :virtual_utc_datetime, :utc_datetime, virtual: true
    field :virtual_utc_datetime_usec, :utc_datetime_usec, virtual: true
    field :virtual_date, :date, virtual: true
    field :virtual_time, :time, virtual: true
    field :virtual_time_usec, :time_usec, virtual: true

    embeds_one :example_ecto_schema_embed, ExampleEctoSchemaEmbed
    has_one :example_ecto_schema_has_one, ExampleEctoSchemaHasOne
    has_many :example_ecto_schema_has_many, ExampleEctoSchemaHasMany
  end
end
