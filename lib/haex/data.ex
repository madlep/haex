defmodule Haex.Data do
  @moduledoc """
  Parses and builds modules to implement data types
  """

  alias Haex.Data.DataBuilder
  alias Haex.Data.DataConstructor
  alias Haex.Data.Parser
  alias Haex.Data.TypeConstructor

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
    |> DataBuilder.build()
  end
end
