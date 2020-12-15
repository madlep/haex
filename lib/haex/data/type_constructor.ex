defmodule Haex.Data.TypeConstructor do
  @moduledoc """
  builds type constructor module used to implement a data type
  """
  alias __MODULE__, as: T
  alias Haex.Data.DataConstructorBuilder

  @type t() :: %T{
          name: mod_name(),
          params: [param_name()]
        }
  @enforce_keys [:name, :params]
  defstruct [:name, :params]

  @type mod_name() :: [atom()]
  @type param_name() :: atom()

  @spec build(t(), [DataConstructor.t()]) :: Macro.output()
  def build(%T{name: name}, data_constructors) do
    quote do
      defmodule unquote({:__aliases__, [alias: false], name}) do
        unquote(Enum.map(data_constructors, &DataConstructorBuilder.build/1))
        unquote(Enum.map(data_constructors, &DataConstructorBuilder.build_helper/1))
      end
    end
  end
end
