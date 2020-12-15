defmodule Haex.Data.TypeConstructor do
  @moduledoc """
  builds type constructor module used to implement a data type
  """
  alias __MODULE__, as: T

  @type t() :: %T{
          name: mod_name(),
          params: [param_name()]
        }
  @enforce_keys [:name, :params]
  defstruct [:name, :params]

  @type mod_name() :: [atom()]
  @type param_name() :: atom()
end
