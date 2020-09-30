defmodule DarkEcto.Types.CFAbsoluteTimeTest do
  @moduledoc """
  Test for `DarkEcto.Types.CFAbsoluteTimeTest`.
  """

  use ExUnit.Case, async: true

  alias DarkEcto.Types.CFAbsoluteTime

  describe ".type/0" do
    test "it returns the ecto :type" do
      assert CFAbsoluteTime.type() == :integer
    end
  end

  describe ".embed_as/0" do
    test "it returns the ecto :embed_as" do
      assert CFAbsoluteTime.embed_as(:any) == :dump
    end
  end

  describe ".cast/1" do
    @cases [
      {0, {:ok, 0}},
      {~U[2001-01-01 00:00:00.000000Z], {:ok, 0}},
      {~U[2020-09-10 15:04:13.281635Z], {:ok, 621_443_053_281_635_000}},
      {621_443_053_281_635_000, {:ok, 621_443_053_281_635_000}},
      {nil, {:ok, nil}},
      {:invalid, :error},
      {"3", :error},
      {%{}, :error},
      {"", :error}
    ]
    for {given, expected} <- @cases do
      test "with #{inspect(given)} it returns #{inspect(expected)}" do
        assert CFAbsoluteTime.cast(unquote(Macro.escape(given))) ==
                 unquote(Macro.escape(expected))
      end
    end
  end

  describe ".load/1" do
    @cases [
      {0, {:ok, ~U[2001-01-01 00:00:00.000000Z]}},
      {621_443_053_281_635_000, {:ok, ~U[2020-09-10 15:04:13.281635Z]}},
      {~U[2020-09-10 15:04:13.281635Z], {:ok, ~U[2020-09-10 15:04:13.281635Z]}},
      {nil, {:ok, nil}},
      {:invalid, :error},
      {"3", :error},
      {%{}, :error},
      {"", :error}
    ]
    for {given, expected} <- @cases do
      test "with #{inspect(given)} it returns #{inspect(expected)}" do
        assert CFAbsoluteTime.load(unquote(Macro.escape(given))) ==
                 unquote(Macro.escape(expected))
      end
    end
  end

  describe ".dump/1" do
    @cases [
      {0, {:ok, ~U[2001-01-01 00:00:00.000000Z]}},
      {621_443_053_281_635_000, {:ok, ~U[2020-09-10 15:04:13.281635Z]}},
      {~U[2020-09-10 15:04:13.281635Z], {:ok, ~U[2020-09-10 15:04:13.281635Z]}},
      {nil, {:ok, nil}},
      {:invalid, :error},
      {"3", :error},
      {%{}, :error},
      {"", :error}
    ]
    for {given, expected} <- @cases do
      test "with #{inspect(given)} it returns #{inspect(expected)}" do
        assert CFAbsoluteTime.dump(unquote(Macro.escape(given))) ==
                 unquote(Macro.escape(expected))
      end
    end
  end
end
