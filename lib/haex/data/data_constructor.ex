defmodule Haex.Data.DataConstructor do
  alias __MODULE__, as: T

  @type t() :: %T{
          name: module(),
          type: module(),
          params: param_list() | param_keywords(),
          record?: boolean()
        }
  @enforce_keys [:name, :type, :params, :record?]
  defstruct [:name, :type, :params, :record?]

  @type name() :: atom()
  @type param() :: {:variable, name()} | {:external_type, raw_ast :: term()}

  @type param_list() :: [param()]
  @type param_keywords() :: [{name(), param()}]

  def build(%T{name: name} = dc) do
    quote do
      defmodule unquote(mod(name)) do
        unquote(type(dc))
        unquote(new(dc))
      end
    end
  end

  def type_variables(%T{params: params}) do
    params
    |> Enum.filter(fn {param_type, _var} -> param_type == :variable end)
    |> Enum.uniq()
  end

  def quoted_type_variables(%T{} = dc) do
    dc
    |> type_variables()
    |> Enum.map(&param_to_quoted_typespec_param/1)
  end

  def type_fields(%T{params: params}), do: params

  def quoted_type_fields(%T{} = dc) do
    dc
    |> type_fields()
    |> Enum.map(&param_to_quoted_typespec_param/1)
  end

  defp mod(name), do: {:__aliases__, [alias: false], name}

  defp type(%T{params: []} = dc) do
    quote do
      @opaque unquote(type_t(dc)) :: __MODULE__
    end
  end

  defp type(%T{record?: false} = dc) do
    fields = quoted_type_fields(dc)

    quote do
      @opaque unquote(type_t(dc)) :: {__MODULE__, unquote_splicing(fields)}
    end
  end

  defp type_t(%T{params: []}) do
    quote do
      t()
    end
  end

  defp type_t(%T{record?: false} = dc) do
    quote do
      t(unquote_splicing(quoted_type_variables(dc)))
    end
  end

  defp param_to_quoted_typespec_param({:variable, variable}), do: {variable, [], Elixir}
  defp param_to_quoted_typespec_param({:external_type, external}), do: external

  defp new(%T{params: []} = dc) do
    quote do
      @spec new() :: unquote(type_t(dc))
      def new(), do: __MODULE__
    end
  end

  defp new(%T{} = dc) do
    variables = type_variables(dc)
    fields = quoted_type_fields(dc)

    when_clause =
      Enum.map(variables, fn {:variable, variable} -> {variable, {:var, [], Elixir}} end)

    args = Macro.generate_arguments(length(fields), nil)

    quote do
      @spec new(unquote_splicing(fields)) :: unquote(type_t(dc))
            when unquote(when_clause)
      def new(unquote_splicing(args)), do: {__MODULE__, unquote_splicing(args)}
    end
  end
end
