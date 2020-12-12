defmodule Haex do
  defmacro data(ast) do
    ast
    # |> IO.inspect(label: "ast")
    |> Haex.Data.data()
    |> macro_puts()

    # |> IO.inspect(label: "quoted module")
  end

  def macro_puts(ast) do
    ast
    |> Macro.to_string()
    |> IO.puts()

    ast
  end
end
