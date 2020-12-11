defmodule Haex.Data do
  alias Haex.Data.DataConstructor
  alias Haex.Data.Parser
  alias Haex.Data.TypeConstructor

  @type t() :: %__MODULE__{
          type_constructor: TypeConstructor.t(),
          data_constructors: [DataConstructor.t()]
        }
  @enforce_keys [:type_constructor, :data_constructors]
  defstruct [:type_constructor, :data_constructors]

  @type type_parameter() :: atom()

  def data(data_ast) do
    Parser.parse(data_ast)
    |> build()
  end

  def build(data) do
    TypeConstructor.build(data)
  end
end
