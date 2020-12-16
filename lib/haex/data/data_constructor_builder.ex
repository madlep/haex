defmodule Haex.Data.DataConstructorBuilder do
  @moduledoc """
  generates AST representation of `Haex.Data.DataConstructor` to return from
  `Haex.data/1` macro
  """
  alias Haex.Data
  alias Haex.Data.Builder
  alias Haex.Data.DataConstructor
  alias Haex.Data.TypeConstructor

  @spec build(DataConstructor.t()) :: Macro.output()
  def build(%DataConstructor{name: name} = dc) do
    quote do
      defmodule unquote(Builder.mod(name)) do
        unquote(type_spec(dc))
        unquote(type_struct(dc))
        unquote(new(dc))
      end
    end
  end

  @spec when_clause(DataConstructor.t()) :: Macro.output()
  defp when_clause(%DataConstructor{} = dc) do
    dc
    |> DataConstructor.type_variables()
    |> Enum.map(fn {:variable, variable} -> {variable, {:var, [], Elixir}} end)
  end

  @spec type_fields(DataConstructor.t()) :: Macro.output()
  def type_fields(%DataConstructor{params: params}) do
    Enum.map(params, &param_to_typespec_param/1)
  end

  @spec type_spec(DataConstructor.t()) :: Macro.output()
  defp type_spec(%DataConstructor{params: []} = dc) do
    type_t = type_t(dc)

    quote do
      @opaque unquote(type_t) :: __MODULE__
    end
  end

  defp type_spec(%DataConstructor{record?: false, params: params} = dc) when params != [] do
    type_t = type_t(dc)
    type_fields = type_fields(dc)

    quote do
      @opaque unquote(type_t) :: {__MODULE__, unquote_splicing(type_fields)}
    end
  end

  defp type_spec(%DataConstructor{record?: true, params: params} = dc) when params != [] do
    type_t = type_t(dc)
    type_fields = type_fields(dc)

    quote do
      @opaque unquote(type_t) :: %__MODULE__{unquote_splicing(type_fields)}
    end
  end

  defp type_struct(%DataConstructor{record?: true} = dc) do
    struct_fields =
      dc
      |> type_fields()
      |> Enum.map(fn {name, _field} -> {name, nil} end)

    quote do
      defstruct unquote(struct_fields)
    end
  end

  defp type_struct(%DataConstructor{record?: false}) do
    quote do
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

  defp new(%DataConstructor{record?: false} = dc) do
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

  defp new(%DataConstructor{record?: true} = dc) do
    type_fields = type_fields(dc)

    type_field_args =
      type_fields
      |> Enum.map(fn {name, type} -> quote(do: unquote({name, [], Elixir}) :: unquote(type)) end)

    type_field_names = type_fields |> Enum.map(fn {name, _field} -> name end)
    type_t = type_t(dc)
    when_clause = when_clause(dc)
    args = Enum.map(type_field_names, fn name -> {name, [], Elixir} end)

    struct_args =
      type_field_names
      |> Enum.zip(args)

    quote do
      @spec new(unquote_splicing(type_field_args)) :: unquote(type_t)
            when unquote(when_clause)
      def new(unquote_splicing(args)), do: %__MODULE__{unquote_splicing(struct_args)}
    end
  end

  @spec qualified_type_t(TypeConstructor.t(), DataConstructor.t()) :: Macro.output()
  def qualified_type_t(%TypeConstructor{name: tc_name}, %DataConstructor{name: name} = dc) do
    mod = Builder.mod(tc_name ++ name)
    type_t = type_t(dc)

    quote do
      unquote(mod).unquote(type_t)
    end
  end

  @spec type_t(DataConstructor.t()) :: Macro.output()
  defp type_t(%DataConstructor{params: []}) do
    quote do
      t()
    end
  end

  defp type_t(%DataConstructor{params: params} = dc) when params != [] do
    quoted_type_variables =
      dc
      |> DataConstructor.type_variables()
      |> Enum.map(&param_to_typespec_param/1)

    quote do
      t(unquote_splicing(quoted_type_variables))
    end
  end

  @spec param_to_typespec_param(Data.param()) :: Macro.output()
  defp param_to_typespec_param({:variable, variable}), do: {variable, [], Elixir}
  defp param_to_typespec_param({:external_type, external}), do: external

  defp param_to_typespec_param({param_name, {param_type, param_ast}}),
    do: {param_name, param_to_typespec_param({param_type, param_ast})}
end
