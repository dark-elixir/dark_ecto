defmodule DarkEcto.OKRepo do
  @moduledoc """
  Utils for normalizing repo calls to return either:
  """

  import Ecto.Query

  @type result() :: {:ok, Ecto.Schema.t()} | {:ok, [Ecto.Schema.t()]} | {:error, query_error()}

  @typedoc """
  Error tuple returned.
  """
  @type query_error() ::
          {resource_atom :: atom(), error_reason()}
          | {queryable :: Ecto.Queryable.t(), error_reason()}

  @typedoc """
  Error tuple reasons.
  """
  @type error_reason() :: :not_found | :invalid_id

  @doc """
  A callback that dispatches to the repo `.all/2`.

  Given a `queryable` and `opts`.
  Returns an {:ok, results}.
  """
  @callback all_ok(queryable :: Ecto.Queryable.t(), opts :: Keyword.t()) ::
              {:ok, [Ecto.Schema.t()]}

  @doc """
  A callback that dispatches to the repo `.get/3`.

  Given a `queryable`, `id`, and `opts`.
  Returns an {:ok, result} or `query_error`.
  """
  @callback get_ok(queryable :: Ecto.Queryable.t(), id :: term, opts :: Keyword.t()) ::
              {:ok, Ecto.Schema.t()} | {:error, query_error()}

  @doc """
  A callback that dispatches to the repo `.get_by/3`.

  Given a `queryable`, `clauses`, and `opts`.
  Returns an {:ok, result} or `query_error`.
  """
  @callback get_by_ok(
              queryable :: Ecto.Queryable.t(),
              clauses :: Keyword.t() | map,
              opts :: Keyword.t()
            ) :: {:ok, Ecto.Schema.t()} | {:error, query_error()}

  @doc """
  A callback that dispatches to the repo `.one/2`.

  Given a `queryable` and `opts`.
  Returns an {:ok, result} or`query_error`.
  """
  @callback one_ok(queryable :: Ecto.Queryable.t(), opts :: Keyword.t()) ::
              {:ok, Ecto.Schema.t()} | {:error, query_error()}

  @doc false
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour DarkEcto.OKRepo
      alias DarkEcto.OKRepo

      def all_ok(queryable, opts \\ []) do
        query = OKRepo.apply_query_opts(queryable, opts)
        OKRepo.wrap_ok(queryable, all(query, opts))
      end

      def get_ok(queryable, id, opts \\ [])

      def get_ok(queryable, nil, _opts) do
        OKRepo.wrap_ok(queryable, nil)
      end

      def get_ok(queryable, id, opts) when is_binary(id) do
        case Integer.parse(id) do
          {integer_id, ""} -> get_ok(queryable, integer_id, opts)
          _ -> OKRepo.wrap_ok(queryable, {:error, :invalid_id})
        end
      end

      def get_ok(queryable, id, opts) when is_integer(id) do
        query = OKRepo.apply_query_opts(queryable, opts)
        OKRepo.wrap_ok(queryable, get(query, id, opts))
      end

      def get_by_ok(queryable, clauses, opts \\ []) do
        query = OKRepo.apply_query_opts(queryable, opts)
        OKRepo.wrap_ok(queryable, get_by(query, clauses, opts))
      end

      def one_ok(queryable, opts \\ []) do
        query = OKRepo.apply_query_opts(queryable, opts)
        OKRepo.wrap_ok(queryable, one(query, opts))
      end
    end
  end

  @doc """
  Applies `opts` to a `t:Ecto.Queryable.t/0` query.
  """
  @spec apply_query_opts(Ecto.Queryable.t(), Keyword.t()) :: Ecto.Queryable.t()
  def apply_query_opts(queryable, opts) when is_list(opts) do
    preloads = Keyword.get(opts, :preload, [])
    limit = Keyword.get(opts, :limit)

    if is_integer(limit) do
      queryable |> preload(^preloads) |> limit(^limit)
    else
      queryable |> preload(^preloads)
    end
  end

  @doc """
  Wraps an `t:Ecto.Queryable.t/0` result into an `:ok` or `:error` tuple.
  """
  @spec wrap_ok(
          queryable :: Ecto.Queryable.t(),
          result :: Ecto.Schema.t() | [Ecto.Schema.t()] | nil | {:error, reason :: atom()}
        ) ::
          {:ok, [Ecto.Schema.t()]} | {:ok, Ecto.Schema.t()} | {:error, query_error()}
  def wrap_ok(queryable, nil) do
    {:error, wrap_query_error(queryable, :not_found)}
  end

  def wrap_ok(queryable, {:error, reason}) when is_atom(reason) do
    {:error, wrap_query_error(queryable, reason)}
  end

  def wrap_ok(_queryable, result) when is_list(result) or is_map(result) do
    {:ok, result}
  end

  @doc """
  Wraps an `t:Ecto.Queryable.t/0` error into a normalized format.
  """
  @spec wrap_query_error(queryable :: Ecto.Queryable.t(), reason :: atom()) :: query_error()
  def wrap_query_error(%Ecto.Query{from: {_, resource}}, reason)
      when is_atom(resource) and is_atom(reason) do
    {resource, reason}
  end

  def wrap_query_error(query, reason) when is_atom(reason) do
    {query, reason}
  end
end
