module Traversal where

{- Paste the following into the repl

import Traversal

import Data.Maybe
import Data.Either
import Data.Lens
import Data.Lens as Lens
import Data.Tuple
import Data.List
import Data.String as String

import Data.Record.ShowRecord
-}

import Prelude
import Data.Tuple (Tuple(..))
import Data.Maybe (Maybe(..))
import Data.Either
import Data.String as String

import Data.Lens
import Data.Lens as Lens
import Control.Monad.Eff.Random
import Data.List
import Data.Lens.Index

all1 = over traversed negate [1, 2]
-- [-1,-2]

all2 = (over traversed negate []) :: Array Int
-- [] 

all3 = set traversed 99 [1, 2]
-- [99,99]

all4 = over traversed negate (Just 3)
-- Just 3

all5 = (over traversed negate $ Right 88) :: Either Int Int
-- (Right -88)

all6 = toListOf traversed [1, 2, 3]
-- (1 : 2 : 3 : Nil)

all7 = toListOf traversed (Just 3)
-- (3 : Nil)

all8 = (toListOf traversed $ Left 5) :: List Int
-- Nil

view1 = view traversed ["D", "a", "w", "n"]
-- "Dawn"

elts1 = firstOf traversed [1, 2, 3]
-- (Just 1)

elts2 = lastOf traversed [1, 2, 3]
-- (Just 3)

elts3 = preview traversed (Right 1)
-- (Just 1)

elts4 = preview traversed [1, 2, 3]
-- (Just 1)

element1 :: Traversal' (Array String) String
element1 = element 1 traversed

elts5 = preview element1 ["no", "yes!", "no"]
-- (Just "yes!")

elts6 = over element1 String.toUpper ["no", "yes!", "no"]
-- [1,-8888,2]

ix1 :: Traversal' (Array String) String
ix1 = ix 1
