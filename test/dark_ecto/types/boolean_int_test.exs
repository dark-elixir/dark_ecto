defmodule DarkEcto.Types.BooleanIntTest do
  @moduledoc """
  Test for `DarkEcto.Types.BooleanIntTest`.
  """

  use ExUnit.Case, async: true

  alias DarkEcto.Types.BooleanInt

  describe ".type/0" do
    test "it returns the ecto :type" do
      assert BooleanInt.type() == :integer
    end
  end

  describe ".embed_as/0" do
    test "it returns the ecto :embed_as" do
      assert BooleanInt.embed_as(:any) == :dump
    end
  end

  describe ".cast/1" do
    @cases [
      {0, {:ok, 0}},
      {1, {:ok, 1}},
      {"0", {:ok, 0}},
      {"1", {:ok, 1}},
      {true, {:ok, 1}},
      {false, {:ok, 0}},
      {"true", {:ok, 1}},
      {"false", {:ok, 0}},
      {nil, {:ok, nil}},
      {:invalid, :error},
      {2, :error},
      {"3", :error},
      {%{}, :error},
      {"", :error}
    ]
    for {given, expected} <- @cases do
      test "with #{inspect(given)} it returns #{inspect(expected)}" do
        assert BooleanInt.cast(unquote(Macro.escape(given))) == unquote(expected)
      end
    end
  end

  describe ".load/1" do
    @cases [
      {0, {:ok, false}},
      {1, {:ok, true}},
      {"0", {:ok, false}},
      {"1", {:ok, true}},
      {true, {:ok, true}},
      {false, {:ok, false}},
      {"true", {:ok, true}},
      {"false", {:ok, false}},
      {nil, {:ok, nil}},
      {:invalid, :error},
      {2, :error},
      {"3", :error},
      {%{}, :error},
      {"", :error}
    ]
    for {given, expected} <- @cases do
      test "with #{inspect(given)} it returns #{inspect(expected)}" do
        assert BooleanInt.load(unquote(Macro.escape(given))) == unquote(expected)
      end
    end
  end

  describe ".dump/1" do
    @cases [
      {0, {:ok, false}},
      {1, {:ok, true}},
      {"0", {:ok, false}},
      {"1", {:ok, true}},
      {true, {:ok, true}},
      {false, {:ok, false}},
      {"true", {:ok, true}},
      {"false", {:ok, false}},
      {nil, {:ok, nil}},
      {:invalid, :error},
      {2, :error},
      {"3", :error},
      {%{}, :error},
      {"", :error}
    ]
    for {given, expected} <- @cases do
      test "with #{inspect(given)} it returns #{inspect(expected)}" do
        assert BooleanInt.dump(unquote(Macro.escape(given))) == unquote(expected)
      end
    end
  end
end
