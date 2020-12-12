defmodule Haex.Data.Parser do
  alias Haex.Data
  alias Haex.Data.DataConstructor
  alias Haex.Data.TypeConstructor

  @spec parse(Macro.t()) :: Data.t()
  def parse({:"::", _meta, [type_ast, data_asts]}) do
    type_constructor = parse_type_constructor(type_ast)

    data_constructors = parse_data_constructors(data_asts, type_constructor)

    %Data{
      type_constructor: type_constructor,
      data_constructors: data_constructors
    }
  end

  @spec parse_type_constructor(Macro.t()) :: TypeConstructor.t()
  defp parse_type_constructor({:__aliases__, _, type_name}) do
    %TypeConstructor{
      name: type_name,
      params: []
    }
  end

  defp parse_type_constructor({{:., _, [{:__aliases__, _, type_name}, :t]}, _, type_params_ast}) do
    type_params = parse_type_params(type_params_ast)

    %TypeConstructor{
      name: type_name,
      params: type_params
    }
  end

  @spec parse_type_params(Macro.t()) :: [atom()]
  defp parse_type_params([]), do: []
  defp parse_type_params(no_parens: true), do: []

  defp parse_type_params(type_params_ast) do
    Enum.map(type_params_ast, fn {type_param_name, _meta, _ctx} -> type_param_name end)
  end

  @spec parse_data_constructors(Macro.t(), TypeConstructor.t()) :: [DataConstructor.t()]
  defp parse_data_constructors({:|, _meta, _asts} = ast, type_constructor) do
    ast |> or_ast_to_list() |> parse_data_constructors(type_constructor)
  end

  defp parse_data_constructors(data_asts, type_constructor) when is_list(data_asts) do
    Enum.map(data_asts, &parse_data_constructor(&1, type_constructor))
  end

  defp parse_data_constructors(data_ast, type_constructor) when not is_list(data_ast) do
    [parse_data_constructor(data_ast, type_constructor)]
  end

  @spec or_ast_to_list(Macro.t()) :: [Macro.t()]
  defp or_ast_to_list({:|, _meta, [h_ast, t_ast]}), do: [h_ast | or_ast_to_list(t_ast)]
  defp or_ast_to_list(ast), do: [ast]

  @spec parse_data_constructor(Macro.t(), TypeConstructor.t()) :: DataConstructor.t()
  defp parse_data_constructor({:__aliases__, _, data_name}, type_constructor) do
    %DataConstructor{
      name: data_name,
      type: type_constructor.name,
      params: [],
      record?: false
    }
  end

  defp parse_data_constructor(
         {{:., _, [{:__aliases__, _, data_name}, :t]}, _, data_params_ast},
         type_constructor
       ) do
    {data_params, is_record} = parse_data_params(data_params_ast)

    %DataConstructor{
      name: data_name,
      type: type_constructor.name,
      params: data_params,
      record?: is_record
    }
  end

  @spec parse_data_params(Macro.t()) :: {[DataConstructor.param()], is_record :: boolean()}
  defp parse_data_params([data_params_ast]) when is_list(data_params_ast) do
    if Keyword.keyword?(data_params_ast) do
      params =
        Enum.map(data_params_ast, fn {param_name, data_param_ast} ->
          {param_name, parse_data_param(data_param_ast)}
        end)

      {params, true}
    else
      raise "expected a keyword list got: #{data_params_ast |> inspect}"
    end
  end

  defp parse_data_params(data_params_ast) do
    params = Enum.map(data_params_ast, &parse_data_param/1)
    {params, false}
  end

  @spec parse_data_param(Macro.t()) :: DataConstructor.param()
  defp parse_data_param({name, _, args}) when not is_list(args) do
    {:variable, name}
  end

  defp parse_data_param(external_type_ast) do
    {:external_type, external_type_ast}
  end
end
