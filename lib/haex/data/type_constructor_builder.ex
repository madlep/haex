defmodule Haex.Data.TypeConstructorBuilder do
  @moduledoc """
  generates AST representation of `Haex.Data.TypeConstructor` to return from
  `Haex.data/1` macro
  """

  alias Haex.Data.Builder
  alias Haex.Data.DataConstructor
  alias Haex.Data.DataConstructorBuilder
  alias Haex.Data.TypeConstructor

  @spec build(TypeConstructor.t(), [DataConstructor.t()]) :: Macro.output()
  def build(%TypeConstructor{name: name}, data_constructors) do
    quote do
      defmodule unquote(Builder.mod(name)) do
        unquote(Enum.map(data_constructors, &DataConstructorBuilder.build/1))
        unquote(Enum.map(data_constructors, &DataConstructorBuilder.build_helper/1))
      end
    end
  end
end
