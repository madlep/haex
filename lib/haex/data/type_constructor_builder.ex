defmodule Haex.Data.TypeConstructorBuilder do
  @moduledoc """
  generates AST representation of `Haex.Data.TypeConstructor` to return from
  `Haex.data/1` macro
  """

  alias Haex.Data.Builder
  alias Haex.Data.DataConstructor
  alias Haex.Data.DataConstructorBuilder
  alias Haex.Data.TypeConstructor

  @spec build(TypeConstructor.t(), [DataConstructor.t()]) :: Macro.output()
  def build(%TypeConstructor{name: name} = tc, data_constructors) do
    quote do
      defmodule unquote(Builder.mod(name)) do
        unquote(type_t(tc, data_constructors))

        unquote(Enum.map(data_constructors, &DataConstructorBuilder.build/1))
        unquote(Enum.map(data_constructors, &build_helper(tc, &1)))
      end
    end
    |> Haex.macro_puts()
  end

  @spec build_helper(TypeConstructor.t(), DataConstructor.t()) :: Macro.output()
  def build_helper(
        %TypeConstructor{} = tc,
        %DataConstructor{name: name, params: dc_params} = dc
      ) do
    helper_name = DataConstructor.helper_name(dc)
    type_fields = DataConstructorBuilder.type_fields(dc)
    args = Macro.generate_arguments(length(dc_params), nil)
    helper_type_t = helper_type_t(tc, dc)
    helper_when_clause = helper_when_clause(tc, dc)
    mod = Builder.mod(name)

    quote do
      @spec unquote(helper_name)(unquote_splicing(type_fields)) :: unquote(helper_type_t)
            when unquote(helper_when_clause)
      def unquote(helper_name)(unquote_splicing(args)),
        do: unquote(mod).new(unquote_splicing(args))
    end
  end

  @spec type_t(TypeConstructor.t(), [DataConstructor.t()]) :: Macro.output()
  defp type_t(%TypeConstructor{params: params}, data_constructors) do
    quoted_params = Enum.map(params, fn param -> {param, [], Elixir} end)

    dc_type_ts =
      data_constructors
      |> Enum.map(&DataConstructorBuilder.qualified_type_t/1)
      |> Builder.or_pipe_join()

    quote do
      @type t(unquote_splicing(quoted_params)) :: unquote(dc_type_ts)
    end
  end

  @spec helper_type_t(TypeConstructor.t(), DataConstructor.t()) :: Macro.output()
  defp helper_type_t(%TypeConstructor{params: params}, %DataConstructor{} = dc) do
    quoted_params =
      params
      |> Enum.map(&underscore_unused_param(&1, dc))
      |> Enum.map(fn param -> {param, [], Elixir} end)

    quote do
      t(unquote_splicing(quoted_params))
    end
  end

  defp helper_when_clause(%TypeConstructor{params: params}, %DataConstructor{} = dc) do
    Enum.map(params, fn param -> {underscore_unused_param(param, dc), {:var, [], Elixir}} end)
  end

  defp underscore_unused_param(param, %DataConstructor{} = dc) do
    if DataConstructor.has_variable?(dc, param) do
      param
    else
      :"_#{param}"
    end
  end
end
