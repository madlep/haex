defmodule MonoidTest do
  use ExUnit.Case
  doctest Monoid

  describe "for Monoid.Sum" do
    test "empty/0 is 0" do
      assert Monoid.Sum.empty() == %Monoid.Sum{v: 0}
    end
  end
end

defmodule Monoid.SumTest do
  use ExUnit.Case
  doctest Monoid.Sum

  describe "of/1" do
    test "builds a value" do
      assert Monoid.Sum.of(123) == %Monoid.Sum{v: 123}
    end
  end

  describe "empty/0" do
    test "is empty" do
      assert Monoid.Sum.empty() == %Monoid.Sum{v: 0}
    end
  end

  describe "append/2" do
    test "adds values" do
      m1 = %Monoid.Sum{v: 123}
      m2 = %Monoid.Sum{v: 234}
      assert Monoid.Sum.append(m1, m2) == %Monoid.Sum{v: 123 + 234}
    end
  end

  describe "laws" do
    import Monoid.Sum, only: [of: 1]
    import Monoid, only: [empty: 0, append: 2]

    test "identity" do
      m = of(123)

      assert append(empty(), m) == m
      assert append(m, empty()) == m
    end

    test "associativity" do
      m1 = of(123)
      m2 = of(234)
      m3 = of(345)

      assert append(append(m1, m2), m3) == append(m1, append(m2, m3))
    end
  end
end

defmodule Monoid.ProductTest do
  use ExUnit.Case
  doctest Monoid.Product

  describe "of/1" do
    test "builds a value" do
      assert Monoid.Product.of(123) == %Monoid.Product{v: 123}
    end
  end

  describe "empty/0" do
    test "is empty" do
      assert Monoid.Product.empty() == %Monoid.Product{v: 1}
    end
  end

  describe "append/2" do
    test "multiplies values" do
      m1 = %Monoid.Product{v: 123}
      m2 = %Monoid.Product{v: 234}
      assert Monoid.Product.append(m1, m2) == %Monoid.Product{v: 123 * 234}
    end
  end

  describe "laws" do
    import Monoid.Product, only: [of: 1]
    import Monoid, only: [empty: 0, append: 2]

    test "identity" do
      m = of(123)

      assert append(empty(), m) == m
      assert append(m, empty()) == m
    end

    test "associativity" do
      m1 = of(123)
      m2 = of(234)
      m3 = of(345)

      assert append(append(m1, m2), m3) == append(m1, append(m2, m3))
    end
  end
end
