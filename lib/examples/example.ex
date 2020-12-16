defmodule Haex.Example do
  @moduledoc false

  import Haex

  # data Bool = False | True
  data Color :: Red | Green | Blue | BlueSteel

  data Foo.t(a) :: Bar.t(a, integer()) | Baz.t(boolean(), integer())

  # data  Maybe a  =  Nothing | Just a
  data Maybe.t(a) :: Nothing | Just.t(a)

  # data Pair a b = Pair a b
  data Pair.t(a, b) :: Pair.t(a, b)

  # data  Either a b  =  Left a | Right b
  data Either.t(a, b) :: Left.t(a) | Right.t(b)

  # data Tree a = Leaf | Node a (Tree a) (Tree a)
  # data Tree.t(a) :: Leaf | Node.t(a, Tree.t(a), Tree.t(a))

  # data Person = Person String String Int Float String String
  data Person :: Person.t(String.t(), String.t(), integer(), float(), String.t(), String.t())

  data SocialMedia ::
         Twitok.t(String.t())
         | Facepalm.t(String.t())
         | Watzap.t(String.t())
         | Instaban.t(String.t())

  data PersonRec ::
         PersonRec.t(
           name: String.t(),
           social_media: [SocialMedia.t()],
           age: integer(),
           height: float(),
           favourite_ice_cream: String.t(),
           standard_quote: String.t()
         )
end
