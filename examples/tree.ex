import Haex

# data Tree a = Leaf | Node a (Tree a) (Tree a)
data Tree.t(a) :: Leaf | Node.t(a, Tree.t(a), Tree.t(a))
