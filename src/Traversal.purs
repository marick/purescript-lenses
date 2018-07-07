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
import Data.Map as Map
import Data.Lens.At (at)
import Data.Monoid
import Data.Monoid.Additive

-}

import Prelude
import Data.Tuple (Tuple(..))
import Data.Maybe (Maybe)
import Data.Lens ( _1
                 , Traversal, Traversal', _Just, element, traversed -- new
                 )
import Data.Traversable (class Traversable)
import Data.Lens.At (class At, at)
import Data.Map (Map)
import Data.Map as Map

_element1 :: Traversal' (Array String) String
_element1 = element 1 traversed


{-                    Composition          -}

-- Types explained in the text

_trav_1 :: forall traversable a b _1_.
          Traversable traversable => 
          Traversal (traversable (Tuple a _1_))
                    (traversable (Tuple b _1_))
                    a b
_trav_1 = traversed <<< _1

_at_trav_1 :: forall a _1_ . 
             Traversal' (Map Int (Tuple a _1_)) a
_at_trav_1 = at 3 <<< traversed <<< _1

tupleMap = Map.fromFoldable [ (Tuple 3 (Tuple 8 "s"))
                            , (Tuple 4 (Tuple 1 "_2_"))]


_trav_at :: forall trav keyed a.
            Traversable trav => At keyed Int a =>
            Traversal' (trav keyed) (Maybe a)
_trav_at = traversed <<< at 3




mapArray = [ Map.singleton 3 "3"
           , Map.empty
           , Map.singleton 4 "4"
           ]



-- Exercise solutions

_trav_trav :: forall a b trav1 trav2 .
              Traversable trav1 => Traversable trav2 =>
              Traversal (trav1 (trav2 a))
                        (trav1 (trav2 b))
                        a b
_trav_trav = traversed <<< traversed


_1_trav :: forall trav a _1_ .
           Traversable trav =>
           Traversal' (Tuple (trav a) _1_) a
_1_trav = _1 <<< traversed
