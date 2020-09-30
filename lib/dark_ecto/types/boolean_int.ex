defmodule DarkEcto.Types.BooleanInt do
  @moduledoc """
  Representation for a boolean stored as an integer.
  """

  @typedoc """
  Stored as an `t:pos_integer/0` in the database but used at runtime as a `t:boolean/0`.
  """
  @type t() :: boolean()
  @type t_db() :: pos_integer()

  @behaviour Ecto.Type

  @falsey [0, "0", false, "false"]
  @truthy [1, "1", true, "true"]

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
  def cast(nil), do: {:ok, nil}
  def cast(value) when value in @falsey, do: {:ok, 0}
  def cast(value) when value in @truthy, do: {:ok, 1}
  def cast(_), do: :error

  @doc """
  Load database data.
  """
  @spec load(any()) :: {:ok, t()} | :error
  def load(nil), do: {:ok, nil}
  def load(value) when value in @falsey, do: {:ok, false}
  def load(value) when value in @truthy, do: {:ok, true}
  def load(_), do: :error

  @doc """
  Dump values into the database.
  """
  @spec dump(any()) :: {:ok, t()} | :error
  def dump(nil), do: {:ok, nil}
  def dump(value) when value in @falsey, do: {:ok, false}
  def dump(value) when value in @truthy, do: {:ok, true}
  def dump(_), do: :error

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
