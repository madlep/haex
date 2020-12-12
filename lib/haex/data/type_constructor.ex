defmodule Haex.Data.TypeConstructor do
  alias __MODULE__, as: T
  alias Haex.Data.DataConstructor, as: DataConstructor

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
        unquote(Enum.map(data_constructors, &DataConstructor.build/1))
      end
    end
  end
end
