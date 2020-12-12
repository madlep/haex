defmodule Haex do
  @spec data(Macro.t()) :: Macro.output()
  defmacro data(ast) do
    ast
    # |> IO.inspect(label: "ast")
    |> Haex.Data.data()

    # |> macro_puts()
    # |> IO.inspect(label: "quoted module")
  end

  @spec macro_puts(Macro.output()) :: Macro.output()
  def macro_puts(ast) do
    ast
    |> Macro.to_string()
    |> IO.puts()

    ast
  end
end
