defmodule Haex.Data.Builder do
  @moduledoc """
  utility functions to generate common AST forms used in multiple places
  """
  alias Haex.Data

  @spec mod(Data.mod_name()) :: Macro.output()
  def mod(name), do: {:__aliases__, [alias: false], name}

  @spec or_pipe_join([Macro.output()]) :: Macro.output()
  def or_pipe_join([ast]) do
    ast
  end

  def or_pipe_join([ast | asts]) do
    {:|, [], [ast, or_pipe_join(asts)]}
  end
end
