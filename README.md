# Haex

"Haskell as Elixir" _(pronounced "hacks")_

Provides a DSL for implementing Haskell style data types to generate Elixir
data structure and modules implementing those patterns.

A succinct statement generates a number of modules, and helper functions,
along with valid dialyzer type and specs to work with those data structures.

The goal is to make it quicker and easier to work with rich types without having to implement a lot of boilerplate code to build common patterns. This is particularly true in the case of Elixir structs, which to be used properly, require a `defstruct` call, `@type` declaration (which is _almost but not quite_ identical), and an `@enforce_keys` annotaiton. All of these can be automated away.

A secondary goal is to encourage good use of types that are understand by dialzyer. This makes it easier to work with and reason about the code, and aids documentation of what functions expect and return.
### Basics
```elixir
import Haex

data Maybe.t(a) :: Nothing | Just.t(a)

Maybe.just("cheese")
# {Maybe.Just, "cheese"}

Maybe.Just.new("cheese")
# {Maybe.Just, "cheese"}

Maybe.nothing()
# Maybe.Nothing

Maybe.Nothing.new()
# Maybe.Nothing
```

When compiled from file, and loaded in iex...

```elixir
iex(1)> t Maybe
@type t(a) :: Maybe.Nothing.t() | Maybe.Just.t(a)

iex(2) h Maybe.just
def just(arg1)
@spec just(a) :: t(a) when a: var

iex(3) h Maybe.nothing
def nothing()
@spec nothing() :: t(_a)
```

This one line statement (`Maybe.t(a) :: Nothing | Just.t(a)`) generated code that looks something like...
```elixir
defmodule Maybe do
  @type t(a) :: Maybe.Nothing.t() | Maybe.Just.t(a)

  defmodule Nothing  do
    @opaque t() :: __MODULE__

    @spec(new() :: t())
    def new()  do
      __MODULE__
    end
  end

  defmodule Just do
    @opaque t(a) :: {__MODULE__, a}

    @spec(new(a) :: t(a) when a: var)
    def new(arg1) do
      {__MODULE__, arg1}
    end
  end

  @spec nothing() :: t(_a) when _a: var
  def nothing() do
    Nothing.new()
  end

  @spec just(a) :: t(a) when a: var)
  def just(arg1) do
    Just.new(arg1)
  end
end
```

...saving you a lot of keyboard wear

### Enum Types
```elixir
data Color :: Red | Green | Blue | BlueSteel
```

### Sum Types
```elixir
data SocialMediaAccount ::
        Twitok.t(String.t())
        | Facepalm.t(String.t())
        | Watzap.t(String.t())
        | Instaban.t(String.t())
```

### Product Types
```elixir
data Pair.t(a, b) :: Pair.t(a, b)

data Either.t(a, b) :: Left.t(a) | Right.t(b)

data Person::
        Person.t(
          name: String.t(),
          social_media: [SocialMediaAccount.t()],
          age: integer(),
          height: float(),
          favourite_ice_cream: String.t(),
          standard_quote: String.t()
        )
```
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `haex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:haex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/haex](https://hexdocs.pm/haex).

