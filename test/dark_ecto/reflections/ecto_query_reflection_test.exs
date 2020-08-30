defmodule DarkEcto.Reflections.EctoQueryReflectionTest do
  @moduledoc """
  Test for DarkEcto.Reflections.EctoQueryReflection
  """

  use ExUnit.Case, async: true

  alias DarkEcto.Reflections.EctoQueryReflection
  require Ecto.TestRepo, as: TestRepo

  describe ".ecto_Query?/1" do
    test "given a valid :query" do
      import Ecto.Query

      query = from(p in "posts", select: [p.id])
      assert {_sql, []} = EctoQueryReflection.to_sql(TestRepo, query)

      # Not working with `Ecto.TestRepo`
      # assert is_binary(sql)
    end
  end
end
