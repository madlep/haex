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

  # defmacro data({:"::", _, [typec_ast, datac_ast]}) do
  #   {type, type_params} = constructor(typec_ast)

  #   data_constructors = constructors(datac_ast)

  #   quote do
  #     defmodule unquote(type) do
  #       @type t(unquote_splicing(type_params)) :: unquote(datac_ast)
  #       (unquote_splicing(for dc <- data_constructors, do: data_constructor_mod(type, dc)))
  #     end
  #   end
  #   |> puts_macro_to_s()
  # end

  # # handle type constructors with params (or called with `.t()`)
  # # e.g. `Maybe.t(a)` `Either.t(l,r)` `Just.t(a)`
  # defp constructor({{:., _, [{:__aliases__, _, _alias} = name, :t]}, _, params}) do
  #   {name, params}
  # end

  # # handle case of plain type name without params
  # # e.g. `Color` `Nothing`
  # defp constructor({:__aliases__, _, _alias} = name) do
  #   {name, []}
  # end

  # defp constructors({:|, _, [c, rest]}), do: [constructor(c)] ++ constructors(rest)
  # defp constructors(c), do: [constructor(c)]

  # defp data_constructor_mod(_type, {name, []}) do
  #   quote do
  #     defmodule unquote(name) do
  #       @opaque t() :: unquote(name)

  #       def new(), do: unquote(name)
  #     end

  #     unquote(build_type_module_constructor(name, []))
  #   end
  # end

  # defp data_constructor_mod(type, {name, params}) do
  #   args = Macro.generate_arguments(length(params), __MODULE__)

  #   qualified_name = mod_ast_concat(type, name)

  #   quote do
  #     defmodule unquote(name) do
  #       @opaque t(unquote_splicing(params)) :: {unquote(qualified_name), unquote_splicing(params)}

  #       def new(unquote_splicing(args)), do: {unquote(name), unquote_splicing(args)}
  #     end

  #     unquote(build_type_module_constructor(name, params))
  #   end
  # end

  # defp build_type_module_constructor(data_type, params) do
  #   args = Macro.generate_arguments(length(params), __MODULE__)

  #   quote do
  #     def unquote(snake_case(data_type))(unquote_splicing(args)) do
  #       unquote(data_type).new(unquote_splicing(args))
  #     end
  #   end
  # end

  # defp snake_case(value) do
  #   value
  #   |> Macro.expand(__ENV__)
  #   |> Macro.underscore()
  #   |> String.to_atom()
  # end

  # defp mod_ast_concat(
  #        {:__aliases__, _, _} = mod1,
  #        {:__aliases__, _, _} = mod2
  #      ) do
  #   quote(do: unquote(mod1).unquote(mod2))
  # end
end
