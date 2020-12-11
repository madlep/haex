defmodule Haex.Data.TypeConstructor do
  alias __MODULE__, as: T
  alias Haex.Data, as: Data
  alias Haex.Data.DataConstructor, as: DataConstructor

  @type t() :: %T{
          name: name(),
          params: [param()]
        }
  @enforce_keys [:name, :params]
  defstruct [:name, :params]

  @type name() :: atom()
  @type param() :: atom()

  def build(%Data{type_constructor: %T{name: name}, data_constructors: dcs}) do
    quote do
      defmodule unquote({:__aliases__, [alias: false], name}) do
        unquote(Enum.map(dcs, &DataConstructor.build/1))
      end
    end
  end
end
