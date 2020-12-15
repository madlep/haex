defmodule Haex.Data.DataConstructorBuilder do
  @moduledoc """
  generates AST representation of `Haex.Data.DataConstructor` to return from `Haex.data/1` macro
  """
  alias Haex.Data.DataConstructor

  @spec build(DataConstructor.t()) :: Macro.output()
  def build(%DataConstructor{name: name} = dc) do
    quote do
      defmodule unquote(mod(name)) do
        unquote(type_spec(dc))
        unquote(new(dc))
      end
    end
  end

  @spec build_helper(DataConstructor.t()) :: Macro.output()
  def build_helper(%DataConstructor{name: name} = dc) do
    helper_name = DataConstructor.helper_name(dc)
    type_fields = type_fields(dc)
    args = Macro.generate_arguments(length(type_fields), nil)
    type_t = type_t(dc)
    when_clause = when_clause(dc)
    mod = mod(name)

    quote do
      @spec unquote(helper_name)(unquote_splicing(type_fields)) :: unquote(mod).unquote(type_t)
            when unquote(when_clause)
      def unquote(helper_name)(unquote_splicing(args)),
        do: unquote(mod).new(unquote_splicing(args))
    end
  end

  defp when_clause(%DataConstructor{} = dc) do
    dc
    |> DataConstructor.type_variables()
    |> Enum.map(fn {:variable, variable} -> {variable, {:var, [], Elixir}} end)
  end

  @spec type_fields(DataConstructor.t()) :: Macro.output()
  defp type_fields(%DataConstructor{params: params}) do
    Enum.map(params, &param_to_typespec_param/1)
  end

  @spec mod(DataConstructor.mod_name()) :: Macro.output()
  defp mod(name), do: {:__aliases__, [alias: false], name}

  @spec type_spec(DataConstructor.t()) :: Macro.output()
  defp type_spec(%DataConstructor{params: []} = dc) do
    quote do
      @opaque unquote(type_t(dc)) :: __MODULE__
    end
  end

  @spec new(DataConstructor.t()) :: Macro.output()
  defp new(%DataConstructor{params: []} = dc) do
    type_t = type_t(dc)

    quote do
      @spec new() :: unquote(type_t)
      def new(), do: __MODULE__
    end
  end

  defp new(%DataConstructor{} = dc) do
    type_fields = type_fields(dc)
    type_t = type_t(dc)
    when_clause = when_clause(dc)
    args = Macro.generate_arguments(length(type_fields), nil)

    quote do
      @spec new(unquote_splicing(type_fields)) :: unquote(type_t)
            when unquote(when_clause)
      def new(unquote_splicing(args)), do: {__MODULE__, unquote_splicing(args)}
    end
  end

  defp type_spec(%DataConstructor{record?: false} = dc) do
    fields = type_fields(dc)

    quote do
      @opaque unquote(type_t(dc)) :: {__MODULE__, unquote_splicing(fields)}
    end
  end

  @spec type_t(DataConstructor.t()) :: Macro.output()
  defp type_t(%DataConstructor{params: []}) do
    quote do
      t()
    end
  end

  defp type_t(%DataConstructor{record?: false} = dc) do
    quoted_type_variables =
      dc
      |> DataConstructor.type_variables()
      |> Enum.map(&param_to_typespec_param/1)

    quote do
      t(unquote_splicing(quoted_type_variables))
    end
  end

  @spec param_to_typespec_param(DataConstructor.param()) :: Macro.output()
  defp param_to_typespec_param({:variable, variable}), do: {variable, [], Elixir}
  defp param_to_typespec_param({:external_type, external}), do: external
end
