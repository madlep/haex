defmodule Haex.Data.DataBuilder do
  @moduledoc """
  generates AST representation of `Haex.Data` to return from `Haex.data/1` macro
  """

  alias Haex.Data
  alias Haex.Data.TypeConstructorBuilder

  @spec build(Data.t()) :: Macro.output()
  def build(%Data{type_constructor: type_constructor, data_constructors: data_constructors}) do
    TypeConstructorBuilder.build(type_constructor, data_constructors)
  end
end
