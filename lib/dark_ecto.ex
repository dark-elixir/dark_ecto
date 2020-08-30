defmodule DarkEcto do
  @moduledoc """
  Documentation for `DarkEcto`.
  """

  @doc """
  Replaces `Ecto.Association.NotLoaded` values with `nil` or `[]` depending on cardinality.
  """
  @spec strip_ecto_assoc_not_loaded(struct()) :: struct()
  def strip_ecto_assoc_not_loaded(struct) do
    params =
      struct
      |> Map.from_struct()
      |> Map.drop([:__meta__])
      |> Enum.into(%{}, fn
        {field, %Ecto.Association.NotLoaded{__cardinality__: :one}} -> {field, nil}
        {field, %Ecto.Association.NotLoaded{__cardinality__: :many}} -> {field, []}
        {field, value} -> {field, value}
      end)

    Map.merge(struct, params)
  end
end
