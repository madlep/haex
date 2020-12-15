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

  @spec type_variables(t()) :: [param()]
  def type_variables(%T{params: params}) do
    params
    |> Enum.filter(fn {param_type, _var} -> param_type == :variable end)
    |> Enum.uniq()
  end

  def helper_name(%T{name: name}) do
    name
    |> List.last()
    |> Atom.to_string()
    |> Macro.underscore()
    |> String.to_atom()
  end
end
