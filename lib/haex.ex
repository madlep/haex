defmodule Haex do
  @moduledoc """
  Haskell As Elixir - Haex (pronounced "hacks")

  Using Elixir's macro system to define a DSL that _sort of_ looks like
  Haskell's syntax for succinctly defining data types
  """

  @spec data(Macro.t()) :: Macro.output()
  defmacro data(ast) do
    ast
    |> Haex.Data.data()
  end
end
