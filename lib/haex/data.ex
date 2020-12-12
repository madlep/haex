defmodule Haex.Data do
  alias Haex.Data.DataConstructor
  alias Haex.Data.Parser
  alias Haex.Data.TypeConstructor

  alias __MODULE__, as: T

  @type t() :: %__MODULE__{
          type_constructor: TypeConstructor.t(),
          data_constructors: [DataConstructor.t()]
        }
  @enforce_keys [:type_constructor, :data_constructors]
  defstruct [:type_constructor, :data_constructors]

  @spec data(Macro.t()) :: Macro.output()
  def data(data_ast) do
    data_ast
    |> Parser.parse()
    |> build()
  end

  @spec build(t()) :: Macro.output()
  def build(%T{type_constructor: type_constructor, data_constructors: data_constructors}) do
    TypeConstructor.build(type_constructor, data_constructors)
  end
end
