defmodule DarkEcto.Changesets do
  @moduledoc """
  Helpers for working with an `Ecto.Changeset`.
  """

  # import Ecto.Changeset

  @doc """
  A helper that traverses changeset changes.

      assert changeset = User.changeset(%User{}, %{first_name: "Walter"})
      assert changes_on(changeset) == %{first_name: "Walter"}
  """

  def changes_on(%Ecto.Changeset{changes: changes}) do
    do_changes_on(changes)
  end

  def do_changes_on(%Ecto.Changeset{changes: changes}) do
    do_changes_on(changes)
  end

  def do_changes_on(%{__struct__: _} = changes) do
    changes
  end

  def do_changes_on(changes) when is_map(changes) do
    for {key, value} <- changes, into: %{}, do: {key, do_changes_on(value)}
  end

  def do_changes_on(list) when is_list(list) do
    for item <- list, do: do_changes_on(item)
  end

  def do_changes_on(any) do
    any
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)
  """
  def errors_on(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
