defmodule DataTest do
  @moduledoc false

  use ExUnit.Case
  doctest Haex

  describe "enum sum data type with constant data constructors" do
    alias Haex.Example.Color
    # data Color :: Red | Green | Blue | BlueSteel

    test "has type spec defined" do
      {:ok,
       [
         type:
           {:t,
            {:type, m, :union,
             [
               {:remote_type, m, [{:atom, 0, Haex.Example.Color.Red}, {:atom, 0, :t}, []]},
               {:remote_type, m, [{:atom, 0, Haex.Example.Color.Green}, {:atom, 0, :t}, []]},
               {:remote_type, m, [{:atom, 0, Haex.Example.Color.Blue}, {:atom, 0, :t}, []]},
               {:remote_type, m, [{:atom, 0, Haex.Example.Color.BlueSteel}, {:atom, 0, :t}, []]}
             ]}, []}
       ]} = Code.Typespec.fetch_types(Color)
    end

    test "can create data using data module constructors" do
      assert Color.Red.new() == Color.Red
      assert Color.Green.new() == Color.Green
      assert Color.BlueSteel.new() == Color.BlueSteel
    end

    test "can create data using type module constructors" do
      assert Color.red() == Color.Red
      assert Color.green() == Color.Green
      assert Color.blue_steel() == Color.BlueSteel
    end
  end

  describe "sum data type with mix of constant and unnamed constructor parameters" do
    # data  Maybe a  =  Nothing | Just a
    alias Haex.Example.Maybe

    test "has sum type defined" do
      {:ok,
       [
         type:
           {:t,
            {:type, m, :union,
             [
               {:remote_type, m, [{:atom, 0, Haex.Example.Maybe.Nothing}, {:atom, 0, :t}, []]},
               {:remote_type, m,
                [{:atom, 0, Haex.Example.Maybe.Just}, {:atom, 0, :t}, [{:var, m, :a}]]}
             ]}, [{:var, m, :a}]}
       ]} = Code.Typespec.fetch_types(Maybe)
    end

    test "can create data using data module constructors" do
      assert Maybe.Nothing.new() == Maybe.Nothing
      assert Maybe.Just.new("foobar") == {Maybe.Just, "foobar"}
    end

    test "can create data using type module constructors" do
      assert Maybe.nothing() == Maybe.Nothing
      assert Maybe.just("foobar") == {Maybe.Just, "foobar"}
    end
  end

  describe "sum data type with unnamed constructor parameters" do
    # data  Either a b  =  Left a | Right b
    alias Haex.Example.Either

    test "has sum type defined" do
      {:ok,
       [
         type:
           {:t,
            {:type, m, :union,
             [
               {:remote_type, m,
                [{:atom, 0, Haex.Example.Either.Left}, {:atom, 0, :t}, [{:var, m, :a}]]},
               {:remote_type, m,
                [{:atom, 0, Haex.Example.Either.Right}, {:atom, 0, :t}, [{:var, m, :b}]]}
             ]}, [{:var, m, :a}, {:var, m, :b}]}
       ]} = Code.Typespec.fetch_types(Either)
    end

    test "can create data using data module constructors" do
      assert Either.Left.new(:fail) == {Either.Left, :fail}
      assert Either.Right.new("success") == {Either.Right, "success"}
    end

    test "can create data using type module constructors" do
      assert Either.left(:fail) == {Either.Left, :fail}
      assert Either.right("success") == {Either.Right, "success"}
    end
  end

  # data Maybe, a, do: Nothing | (Just :: a)
  # datacase some_value do
  #   Nothing -> "Nothing"
  #   Just :: a -> "Just a"
  # end
  #
  # # data  Either a b  =  Left a | Right b
  # data Either, [a, b], do: (Left :: a) | (Right :: b)
  # data Either, [a, b] do
  #   Left :: a
  #   Right :: b
  # end

  # # data Shape = Circle Float Float Float | Rectangle Float Float Float Float
  # data Shape, do: (Circle :: [float(), float(), float()]) | (Rectangle :: [float(), float(), float(), float()])
  # data Shape do
  #   Circle :: [float(), float(), float()]
  #   Rectangle :: [float(), float(), float()]
  # end

  # # data Point = Point Float Float
  # data Point, do: [float(), float()]

  # # data Shape = Circle Point Float | Rectangle Point Point
  # data Shape, do: (Circle :: [Point.t(), float()]) | (Rectangle :: [Point.t(), Point.t()])
  # data Shape do
  #   Circle :: [Point.t(), float()]
  #   Rectangle :: [Point.t(), Point.t()]
  # end

  # # data Person = Person String String Int Float String String
  # data Person, do: [String.t(), String.t(), integer(), float(), String.t(), String.t()]

  # # data Person = Person { firstName :: String
  # #                      , lastName :: String
  # #                      , age :: Int
  # #                      , height :: Float
  # #                      , phoneNumber :: String
  # #                      , flavor :: String
  # #                      }
  # data Person, do: [
  #   first_name: String.t(),
  #   last_name: String.t(),
  #   age: integer(),
  #   height: float(),
  #   phone_number: String.t(),
  #   flavor: String.t()
  # ]
end
