defmodule DarkEcto.Reflections.ExMachinaFactoryReflection do
  @moduledoc """
  Reflect on `ExMachina` factories.
  """

  alias DarkEcto.Projections.Typescript
  alias DarkEcto.Reflections.EctoSchemaFields

  def factories(module) when is_atom(module) do
    for {fun_atom, arity} <- module.__info__(:functions),
        binding = cast_factory(module, {fun_atom, arity}) do
      binding
    end
  end

  def factory_modules(module) when is_atom(module) do
    for [module, _factory_atom, _data] <- factories(module), uniq: true do
      module
    end
  end

  def factory_named_modules(module) when is_atom(module) do
    for [module, _factory_atom, _data] <- factories(module), uniq: true do
      %{
        alias: EctoSchemaFields.module_alias(module),
        singular: EctoSchemaFields.singular(module),
        plural: EctoSchemaFields.plural(module),
        module: module
      }
    end
  end

  def factory_entries(module) when is_atom(module) do
    module
    |> factories()
    |> Enum.map(fn [module, factory_atom, data] ->
      %{module: module, factory_atom: factory_atom, data: data, default: false}
    end)
    |> Enum.group_by(& &1.module)
    |> Enum.map(fn {key, related} ->
      [default_item | rest] =
        Enum.sort_by(
          related,
          fn factory_item ->
            factory_item.factory_atom |> Atom.to_string() |> String.length()
          end,
          :asc
        )

      {key, [%{default_item | default: true} | rest]}
    end)
  end

  def cast_factory(module, {fun_atom, 0}) when is_atom(fun_atom) do
    with fun_string <- Atom.to_string(fun_atom),
         true <- String.ends_with?(fun_string, "_factory"),
         factory_string <- String.replace_trailing(fun_string, "_factory", ""),
         binding <- bindings_for(module, factory_string) do
      binding
    else
      _ -> nil
    end
  end

  def cast_factory(_, _), do: nil

  def bindings_for(module, factory_string) when is_binary(factory_string) do
    factory_atom = String.to_atom(factory_string)

    case module.build(factory_atom) do
      %{__struct__: module} = data ->
        [module, factory_atom, data]

      _ ->
        nil
    end
  end

  def typescript_types(factory) when is_atom(factory) do
    for named_module <- factory_named_modules(factory),
        typescript = Typescript.cast(named_module.module),
        %{type_d: type_d} = typescript,
        type_d != [] do
      typescript
    end
  end
end
