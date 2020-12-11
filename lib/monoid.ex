defmodule Monoid do
  alias __MODULE__.Proto

  @type t() :: Proto.t() | :__empty__

  @spec empty() :: t()
  def empty(), do: :__empty__

  @spec append(t(), t()) :: t()
  def append(:__empty__, m2) do
    m1 = Proto.empty_for(m2)
    append(m1, m2)
  end

  def append(m1, :__empty__) do
    m2 = Proto.empty_for(m1)
    append(m1, m2)
  end

  def append(m1, m2), do: Proto.append(m1, m2)

  defprotocol Proto do
    @spec empty_for(any()) :: t()
    def empty_for(m)

    @spec append(t(), t()) :: t()
    def append(m1, m2)
  end
end

defimpl Monoid.Proto, for: Any do
  @type t() :: Monoid.Proto.t()

  @spec empty_for(t()) :: t()
  def empty_for(m) when is_struct(m) do
    m.__struct__.empty()
  end

  @spec append(t(), t()) :: t()
  def append(m1, m2) when is_struct(m1) and is_struct(m2) do
    mod = m1.__struct__
    mod.append(m1, m2)
  end
end

defmodule Monoid.Sum do
  @derive [Monoid.Proto]

  alias __MODULE__

  @empty 0

  @opaque t() :: %Sum{v: number()}
  defstruct v: @empty

  @spec of(number()) :: t()
  def of(n), do: %Sum{v: n}

  @spec empty() :: t()
  def empty(), do: of(@empty)

  @spec append(t(), t()) :: t()
  def append(%Sum{v: s1}, %Sum{v: s2}), do: %Sum{v: s1 + s2}
end

defmodule Monoid.Product do
  @derive [Monoid.Proto]

  alias __MODULE__

  @empty 1

  @opaque t() :: %__MODULE__{v: number()}
  defstruct v: @empty

  @spec of(number()) :: t()
  def of(n), do: %Product{v: n}

  @spec empty() :: t()
  def empty(), do: of(@empty)

  @spec append(t(), t()) :: t()
  def append(%__MODULE__{v: s1}, %__MODULE__{v: s2}), do: %__MODULE__{v: s1 * s2}
end
