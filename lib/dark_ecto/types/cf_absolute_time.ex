defmodule DarkEcto.Types.CFAbsoluteTime do
  @moduledoc """
  Representation for a datetime stored as a unix epoch integer
  """

  alias DarkMatter.DateTimes

  @typedoc """
  Stored as an `t:pos_integer/0` in the database but used at runtime as a `t:DateTime.t/0`.
  """
  @type t() :: DateTime.t()
  @type t_db() :: pos_integer()

  @behaviour Ecto.Type

  @opts [
    unit: :nanosecond,
    epoch: ~U[2001-01-01 00:00:00.000000Z]
  ]

  @doc """
  Ecto storage type
  """
  @spec type() :: :integer
  def type, do: :integer

  @doc """
  Ecto embed type
  """
  @spec embed_as(format :: atom()) :: :dump
  def embed_as(_), do: :dump

  @doc """
  Cast runtime values.
  """
  @spec cast(any) :: {:ok, t_db()} | :error
  def cast(nil) do
    {:ok, nil}
  end

  def cast(integer) when is_integer(integer) and integer >= 0 do
    {:ok, integer}
  end

  def cast(value) do
    unit = Keyword.fetch!(@opts, :unit)
    epoch = Keyword.fetch!(@opts, :epoch)
    epoch_time = DateTime.to_unix(epoch, unit)

    case DateTimes.cast_datetime(value) do
      %DateTime{} = datetime ->
        unix = DateTime.to_unix(datetime, unit) - epoch_time
        {:ok, unix}

      _ ->
        :error
    end
  rescue
    _ -> :error
  end

  @doc """
  Load database data.
  """
  @spec load(any()) :: {:ok, t()} | :error
  def load(nil), do: {:ok, nil}

  def load(integer) when is_integer(integer) and integer >= 0 do
    unit = Keyword.fetch!(@opts, :unit)
    epoch = Keyword.fetch!(@opts, :epoch)
    epoch_time = DateTime.to_unix(epoch, unit)

    case DateTime.from_unix(integer + epoch_time, unit) do
      {:ok, %DateTime{} = datetime} -> {:ok, datetime}
      _ -> :error
    end
  end

  def load(value) do
    case DateTimes.cast_datetime(value) do
      %DateTime{} = datetime -> {:ok, datetime}
      _ -> :error
    end
  rescue
    _ -> :error
  end

  @doc """
  Dump values into the database.
  """
  @spec dump(any()) :: {:ok, t()} | :error
  def dump(value) do
    load(value)
  end

  @doc """
  Implement equality.
  """
  @spec equal?(any, any) :: boolean()
  def equal?(left, right) do
    with {:ok, left} <- cast(left),
         {:ok, right} <- cast(right) do
      left == right
    else
      :error -> false
    end
  end
end
