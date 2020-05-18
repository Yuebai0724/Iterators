
module Iterator where

import Text.Printf 

class Iterator i where
  iterMap :: (a -> b) -> i a -> i b
  iterFold :: (a -> b -> a) -> a -> i b -> a

data List a = Cons a (List a)
            | Nil deriving (Eq, Show)

data Tree a = Branch a (List (Tree a))
            | Leaf deriving (Eq, Show)

data Queue a = Queue (List a) (List a) deriving (Eq, Show)

enqueue :: Queue a -> a -> Queue a
enqueue (Queue inbox outbox) x = Queue (Cons x inbox) outbox

rebalance (Queue Nil ys) = Queue Nil ys
rebalance (Queue (Cons x xs) ys) = rebalance (Queue xs (Cons x ys))

dequeue :: Queue a -> (Maybe a, Queue a)
dequeue (Queue Nil Nil) = (Nothing, Queue Nil Nil)
dequeue (Queue xs (Cons y ys)) = (Just y, Queue xs ys)
dequeue (Queue xs Nil) = dequeue (rebalance (Queue xs Nil))

instance Iterator List where 
  iterMap f Nil = Nil
  iterMap f (Cons head rest) = Cons (f head) (iterMap f rest)
  
  iterFold f a Nil = a
  iterFold f a (Cons head rest) =  iterFold f (f a head) rest
  
instance Iterator Tree where
  iterMap f Leaf  = Leaf
  iterMap f (Branch root child) = Branch (f root) (iterMap (iterMap f) child) 

  iterFold f a Leaf = a
  iterFold f a (Branch root child) = iterFold (iterFold f) (f a root) child 
  
instance Iterator Queue where
  iterMap f (Queue front end) = Queue (iterMap f front) (iterMap f end)
  iterFold f a (Queue front end) = iterFold f (iterFold f a front)  end
  