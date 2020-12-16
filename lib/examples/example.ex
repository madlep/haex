defmodule Haex.Example do
  @moduledoc false

  import Haex

  # data Bool = False | True
  data Color :: Red | Green | Blue | BlueSteel

  data Foo.t(a) :: Bar.t(a, integer()) | Baz.t(boolean(), integer())

  # data  Maybe a  =  Nothing | Just a
  data Maybe.t(a) :: Nothing | Just.t(a)

  # data  Either a b  =  Left a | Right b
  data Either.t(a, b) :: Left.t(a) | Right.t(b)

  # data Tree a = Leaf | Node a (Tree a) (Tree a)
  # data Tree.t(a) :: Leaf | Node.t(a, Tree.t(a), Tree.t(a))

  # data Person = Person String String Int Float String String
  data Person :: Person.t(String.t(), String.t(), integer(), float(), String.t(), String.t())

  data SocialMedia :: Twitok.t(String.t()) | Facepalm.t(String.t()) | Watzap.t(String.t())

  data PersonRec ::
         PersonRec.t(
           name: String.t(),
           social_media: SocialMedia.t(),
           age: integer(),
           height: float(),
           favourite_ice_cream: String.t(),
           standard_quote: String.t()
         )
end

#   defmodule Maybe do
#     @type t(a) :: Nothing.t() | Just.t(a)
#
#     @spec nothing() :: Maybe.t(_a) when _a: var
#     def nothing(), do: Maybe.Nothing.new()
#
#     @spec just(a) :: Maybe.t(a) when a: var
#     def just(a), do: Maybe.Just.new(a)
#
#     defmodule Nothing do
#       @opaque t() :: %__MODULE__{__type__: Maybe}
#       defstruct __type__: Maybe
#
#       @spec new() :: Maybe.t(_a) when _a: var
#       def new(), do: %__MODULE__{}
#
#       defmacro m() do
#         quote do
#           %__MODULE__{__type__: Maybe}
#         end
#       end
#     end
#
#     defmodule Just do
#       @opaque t(a) :: %__MODULE__{__type__: Maybe, __1__: a}
#       defstruct __type__: Maybe, __1__: nil
#
#       @spec new(a) :: Maybe.t(a) when a: var
#       def new(v), do: %__MODULE__{__1__: v}
#
#       defmacro m(a) do
#         quote do
#           %unquote(__MODULE__){__type__: Maybe, __1__: unquote(a)}
#         end
#       end
#     end
#   end
# end

#   defprotocol Functor do
#     @type t(_a) :: any()
#
#     @spec map(t(a), (a -> b)) :: t(b) when a: var, b: var
#     def map(fa, f)
#   end
#
#   defimpl Functor, for: Maybe.Nothing do
#     @spec map(Functor.t(a), (a -> b)) :: Functor.t(b) when a: var, b: var
#     def map(nothing, _f), do: nothing
#   end
#
#   defimpl Functor, for: Maybe.Just do
#     require Maybe.Just
#
#     @spec map(Functor.t(a), (a -> b)) :: Functor.t(b) when a: var, b: var
#     def map(@for.m(a), f), do: @for.new(f.(a))
#   end
