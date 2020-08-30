defmodule DarkEcto.Projections.PermuteConversions do
  @moduledoc """
  Type conversions
  """

  @type types() :: [atom(), ...]
  @type typings() :: [tuple(), ...]
  @type typing() :: atom() | String.t()

  @type conversion() :: {source :: atom(), dest :: atom()}
  @type conversion_mapping() :: [{typing(), typing()}, ...]
  @type permuted_conversion_mappings() :: %{required(:atom) => conversion_mapping()}

  @doc """
  Generate a name for permuted conversion maps

  ## Example

      iex> name_conversion({:source, :sink})
      :source_to_sink
  """
  @spec name_conversion(conversion()) :: atom()
  def name_conversion({source, dest}) do
    :"#{source}_to_#{dest}"
  end

  @doc """
  Gets the conversion map from the permuted conversion maps

  Raises an `ArgumentError` if the named conversion is not present

  ## Example

      iex> get_conversion_mapping!(%{source_to_sink: %{t: :t}}, {:source, :sink})
      %{t: :t}

      iex> get_conversion_mapping!(%{missing_name: %{t: :t}}, {:source, :sink})
      ** (KeyError) key :source_to_sink not found in: %{missing_name: %{t: :t}}
  """
  @spec get_conversion_mapping!(permuted_conversion_mappings(), conversion()) ::
          conversion_mapping()
  def get_conversion_mapping!(permuted_conversion_mappings, {source, dest})
      when is_map(permuted_conversion_mappings) do
    name = name_conversion({source, dest})
    Map.fetch!(permuted_conversion_mappings, name)
  end

  @doc """
  Permutes named conversion maps according to `.name_converion/1` and the provided `types` and `typings`

  Raises an `ArgumentError` if the size of all typing tuples are not consisten with the number of `types` provided.

  ## Example

      iex> permute_conversion_mappings!([:t1, :t2], [{:t11, :t12}])
      %{t1_to_t2: [t11: :t12], t2_to_t1: [t12: :t11]}


      iex> permute_conversion_mappings!([:t1, :t2], [{:t11}])
      ** (ArgumentError) Invalid :typings "non uniform"
  """
  @spec permute_conversion_mappings!(types(), typings()) :: permuted_conversion_mappings()
  def permute_conversion_mappings!(types, typings) when is_list(types) and is_list(typings) do
    :ok = validate!(types, typings)
    indexed_types = Enum.with_index(types)

    for {source, source_index} <- indexed_types,
        {dest, dest_index} <- indexed_types,
        source != dest,
        into: %{} do
      name = name_conversion({source, dest})
      mapping = Enum.into(typings, [], &{elem(&1, source_index), elem(&1, dest_index)})
      {name, mapping}
    end
  end

  @doc """
  Validates `types` and `typings` according to cardinality and requires at least 2 permutable types and at least 1 typing definition.

  ## Example

      iex> validate([:t1, :t2], [{:t11, :t12}])
      :ok

      iex> validate([:t1], [{:t11}])
      {:error, {:types, "min 2"}}

      iex> validate([:t1, :t2], [])
      {:error, {:typings, "empty"}}

      iex> validate(["t1", :t2], [[:t11, :t12]])
      {:error, {:types, "expected atoms"}}

      iex> validate([:t1, :t2], [[:t11, :t12]])
      {:error, {:typings, "expected tuples"}}

      iex> validate([:t1, :t2], [{:t11}])
      {:error, {:typings, "non uniform"}}
  """
  @spec validate(types(), typings()) :: :ok | {:error, {:type | :typings, message :: String.t()}}
  def validate(types, typings) when is_list(types) and is_list(typings) do
    cond do
      length(types) < 2 ->
        {:error, {:types, "min 2"}}

      typings == [] ->
        {:error, {:typings, "empty"}}

      not Enum.all?(types, &is_atom/1) ->
        {:error, {:types, "expected atoms"}}

      not Enum.all?(typings, &is_tuple/1) ->
        {:error, {:typings, "expected tuples"}}

      not Enum.all?(typings, &(tuple_size(&1) == length(types))) ->
        {:error, {:typings, "non uniform"}}

      true ->
        :ok
    end
  end

  @doc """
  Validates `types` and `typings` according to cardinality and requires at least 2 permutable types and at least 1 typing definition.

  Raises an `ArgumentError` if the size of all typing tuples are not consisten with the number of `types` provided.

  ## Example

      iex> validate!([:t1, :t2], [{:t11, :t12}])
      :ok

      iex> validate!([:t1], [{:t11}])
      ** (ArgumentError) Invalid :types "min 2"

      iex> validate!([:t1, :t2], [])
      ** (ArgumentError) Invalid :typings "empty"

      iex> validate!(["t1", :t2], [[:t11, :t12]])
      ** (ArgumentError) Invalid :types "expected atoms"

      iex> validate!([:t1, :t2], [[:t11, :t12]])
      ** (ArgumentError) Invalid :typings "expected tuples"

      iex> validate!([:t1, :t2], [{:t11}])
      ** (ArgumentError) Invalid :typings "non uniform"
  """
  @spec validate!(types(), typings()) :: :ok
  def validate!(types, typings) when is_list(types) and is_list(typings) do
    types
    |> validate(typings)
    |> do_validate!()
  end

  defp do_validate!(:ok), do: :ok

  defp do_validate!({:error, {key, message}}) do
    raise ArgumentError, "Invalid #{inspect(key)} \"#{message}\""
  end

  # @spec convert!(permuted_conversion_mappings(), conversion()) :: typing()()
  # def convert!(permuted_conversion_mappings, {source, dest}, {source_type, dest_type}) do
  #   conversion_mapping = get_conversion_mapping!(permuted_conversion_mappings, {source, dest})

  #   if Map.has_key?(map, source_type) do
  #     Map.get(map, source_type)
  #   else
  #     "N/A"
  #   end
  # end
end
