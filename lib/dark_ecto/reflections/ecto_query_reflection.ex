defmodule DarkEcto.Reflections.EctoQueryReflection do
  @moduledoc """
  Utils for introspecting an `Ecto.Query`.
  """
  alias Ecto.Adapters.SQL

  @doc """
  Transform an `Ecto.Query` into an sql string.
  """
  @spec to_sql(module(), Ecto.Queryable.t(), Keyword.t()) :: {String.t(), [any]}
  def to_sql(repo, query, opts \\ [])

  def to_sql(repo, query, opts) when is_atom(repo) and is_list(opts) do
    type = Keyword.get(opts, :type, :all)
    SQL.to_sql(type, repo, query)
  end
end
