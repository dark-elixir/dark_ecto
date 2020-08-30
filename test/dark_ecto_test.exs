# Code.require_file("support/fixture_schemas.exs", __DIR__)

defmodule DarkEctoTest do
  @moduledoc """
  DarkEcto
  """
  use ExUnit.Case, async: true
  doctest DarkEcto

  describe ".strip_ecto_assoc_not_loaded/1" do
    test "with ExampleEctoSchema" do
      struct = %ExampleEctoSchema{}

      assert DarkEcto.strip_ecto_assoc_not_loaded(struct) == %{
               struct
               | example_ecto_schema_embed: nil,
                 example_ecto_schema_has_one: nil,
                 example_ecto_schema_has_many: []
             }
    end

    test "with embed cardinality :one" do
      struct = %ExampleEctoSchema{
        example_ecto_schema_embed: %Ecto.Association.NotLoaded{__cardinality__: :one}
      }

      assert DarkEcto.strip_ecto_assoc_not_loaded(struct).example_ecto_schema_embed == nil
    end

    test "with has_one cardinality :one" do
      struct = %ExampleEctoSchema{
        example_ecto_schema_has_one: %Ecto.Association.NotLoaded{__cardinality__: :one}
      }

      assert DarkEcto.strip_ecto_assoc_not_loaded(struct).example_ecto_schema_has_one == nil
    end

    test "with has_many cardinality :many" do
      struct = %ExampleEctoSchema{
        example_ecto_schema_has_many: %Ecto.Association.NotLoaded{__cardinality__: :many}
      }

      assert DarkEcto.strip_ecto_assoc_not_loaded(struct).example_ecto_schema_has_many == []
    end

    test "with empty map it raises FunctionClauseError" do
      assert_raise(FunctionClauseError, "no function clause matching in Map.from_struct/1", fn ->
        DarkEcto.strip_ecto_assoc_not_loaded(%{})
      end)
    end
  end
end
