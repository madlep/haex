defmodule Haex.Data.Builder do
  @moduledoc """
  utility functions to generate common AST forms used in multiple places
  """
  alias Haex.Data

  @spec mod(Data.mod_name()) :: Macro.output()
  def mod(name), do: {:__aliases__, [alias: false], name}
end
