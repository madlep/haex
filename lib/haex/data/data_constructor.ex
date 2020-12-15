defmodule Haex.Data.DataConstructor do
  @moduledoc """
  Builds data constructor modules used to implemente a data type
  """

  alias __MODULE__, as: T

  @type t() :: %T{
          name: mod_name(),
          params: [param()] | param_keywords(),
          record?: boolean()
        }
  @enforce_keys [:name, :params, :record?]
  defstruct [:name, :params, :record?]

  @type mod_name() :: [atom()]
  @type param_name() :: atom()
  @type param() :: {:variable, param_name()} | {:external_type, raw_ast :: term()}

  @type param_keywords() :: [{param_name(), param()}]

  @spec build(t()) :: Macro.output()
  def build(%T{name: name} = dc) do
    quote do
      defmodule unquote(quoted_mod(name)) do
        unquote(quoted_type_spec(dc))
        unquote(quoted_new(dc))
      end
    end
  end

  @spec build_helper(t()) :: Macro.output()
  def build_helper(%T{name: name} = dc) do
    # TODO refactor this to remove duplication with build_new
    helper_name = helper_name(name)
    variables = type_variables(dc)
    fields = quoted_type_fields(dc)

    when_clause =
      Enum.map(variables, fn {:variable, variable} -> {variable, {:var, [], Elixir}} end)

    args = Macro.generate_arguments(length(fields), nil)

    quote do
      @spec unquote(helper_name)(unquote_splicing(fields)) ::
              unquote(quoted_mod(name)).unquote(quoted_type_t(dc))
            when unquote(when_clause)
      def unquote(helper_name)(unquote_splicing(args)),
        do: unquote(quoted_mod(name)).new(unquote_splicing(args))
    end
  end

  @spec type_variables(t()) :: [param()]
  def type_variables(%T{params: params}) do
    params
    |> Enum.filter(fn {param_type, _var} -> param_type == :variable end)
    |> Enum.uniq()
  end

  @spec quoted_type_fields(t()) :: Macro.output()
  defp quoted_type_fields(%T{params: params}) do
    Enum.map(params, &param_to_quoted_typespec_param/1)
  end

  @spec quoted_mod(mod_name()) :: Macro.output()
  defp quoted_mod(name), do: {:__aliases__, [alias: false], name}

  @spec quoted_type_spec(t()) :: Macro.output()
  defp quoted_type_spec(%T{params: []} = dc) do
    quote do
      @opaque unquote(quoted_type_t(dc)) :: __MODULE__
    end
  end

  defp quoted_type_spec(%T{record?: false} = dc) do
    fields = quoted_type_fields(dc)

    quote do
      @opaque unquote(quoted_type_t(dc)) :: {__MODULE__, unquote_splicing(fields)}
    end
  end

  @spec quoted_type_t(t()) :: Macro.output()
  defp quoted_type_t(%T{params: []}) do
    quote do
      t()
    end
  end

  defp quoted_type_t(%T{record?: false} = dc) do
    quoted_type_variables =
      dc
      |> type_variables()
      |> Enum.map(&param_to_quoted_typespec_param/1)

    quote do
      t(unquote_splicing(quoted_type_variables))
    end
  end

  @spec param_to_quoted_typespec_param(param()) :: Macro.output()
  defp param_to_quoted_typespec_param({:variable, variable}), do: {variable, [], Elixir}
  defp param_to_quoted_typespec_param({:external_type, external}), do: external

  @spec quoted_new(t()) :: Macro.output()
  defp quoted_new(%T{params: []} = dc) do
    quote do
      @spec new() :: unquote(quoted_type_t(dc))
      def new(), do: __MODULE__
    end
  end

  defp quoted_new(%T{} = dc) do
    variables = type_variables(dc)
    fields = quoted_type_fields(dc)

    when_clause =
      Enum.map(variables, fn {:variable, variable} -> {variable, {:var, [], Elixir}} end)

    args = Macro.generate_arguments(length(fields), nil)

    quote do
      @spec new(unquote_splicing(fields)) :: unquote(quoted_type_t(dc))
            when unquote(when_clause)
      def new(unquote_splicing(args)), do: {__MODULE__, unquote_splicing(args)}
    end
  end

  def helper_name(%T{name: name}) do
    name
    |> List.last()
    |> Atom.to_string()
    |> Macro.underscore()
    |> String.to_atom()
  end
end
