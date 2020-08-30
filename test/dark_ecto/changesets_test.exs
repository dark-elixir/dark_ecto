defmodule DarkEcto.ChangesetsTest do
  @moduledoc """
  Test for DarkEcto.Changesets
  """

  use ExUnit.Case, async: true

  import Ecto.Changeset

  alias DarkEcto.Changesets

  describe ".changes_on/1" do
    test "with idempotent changeset" do
      data = %{}
      types = %{name: :string}
      params = %{name: "Sitch"}

      changeset =
        {data, types}
        |> cast(params, Map.keys(types))

      assert Changesets.changes_on(changeset) == %{
               name: params[:name]
             }
    end

    test "with changes in changeset" do
      data = %{}
      types = %{name: :string, content: :string}
      params = %{name: "Sitch", content: "content"}

      changeset =
        {data, types}
        |> cast(params, Map.keys(types))
        |> validate_required(Map.keys(types))

      assert Changesets.changes_on(changeset) == %{
               name: params[:name],
               content: params[:content]
             }
    end
  end

  describe ".errors_on/1" do
    test "with idempotent changeset" do
      data = %{}
      types = %{name: :string}
      params = %{name: "Sitch"}

      changeset =
        {data, types}
        |> cast(params, Map.keys(types))

      assert Changesets.errors_on(changeset) == %{}
    end

    test "with error changeset" do
      data = %{}
      types = %{name: :string, content: :string}
      params = %{}

      changeset =
        {data, types}
        |> cast(params, Map.keys(types))
        |> validate_required(Map.keys(types))
        |> validate_length(:content, min: 100)

      assert Changesets.errors_on(changeset) == %{
               name: ["can't be blank"],
               content: ["can't be blank"]
             }
    end
  end
end
