defmodule Haex.Data.DataConstructor do
  @moduledoc """
  Builds data constructor modules used to implemente a data type
  """

  alias __MODULE__, as: T
  alias Haex.Data

  @type t() :: %T{
          name: Data.mod_name(),
          params: [Data.param()] | Data.param_keywords(),
          record?: boolean()
        }
  @enforce_keys [:name, :params, :record?]
  defstruct [:name, :params, :record?]

  @spec type_variables(t()) :: [Data.param()]
  def type_variables(%T{params: params, record?: false}) do
    params
    |> Enum.filter(fn {param_type, _var} -> param_type == :variable end)
    |> Enum.uniq()
  end

  def type_variables(%T{params: params, record?: true}) do
    params
    |> Enum.filter(fn {_param_name, {param_type, _var}} -> param_type == :variable end)
    |> Enum.uniq()
  end

  @spec has_variable?(t(), Data.param_name()) :: boolean()
  def has_variable?(%T{params: params}, variable_name) do
    Enum.any?(params, fn {param_type, param_name} ->
      param_type == :variable && param_name == variable_name
    end)
  end

  def helper_name(%T{name: name}) do
    name
    |> List.last()
    |> Atom.to_string()
    |> Macro.underscore()
    |> String.to_atom()
  end
end
