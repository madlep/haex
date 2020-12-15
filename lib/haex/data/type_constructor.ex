defmodule Haex.Data.TypeConstructor do
  @moduledoc """
  builds type constructor module used to implement a data type
  """
  alias __MODULE__, as: T
  alias Haex.Data

  @type t() :: %T{
          name: Data.mod_name(),
          params: [Data.param_name()]
        }
  @enforce_keys [:name, :params]
  defstruct [:name, :params]
end
