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
import Data.Lens (Traversal', Traversal, _1, traversed, element)
import Data.Traversable (class Traversable)
import Data.Lens.At (class At, at)
import Data.Map (Map)
import Data.Map as Map


              {- Useful structures -}

tupleMap :: Map Int (Tuple Int String)
tupleMap = Map.fromFoldable [ (Tuple 3 (Tuple 8 "s"))
                            , (Tuple 4 (Tuple 1 "_2_"))]

mapArray :: Array (Map Int String)
mapArray = [ Map.singleton 3 "3"
           , Map.empty
           , Map.singleton 4 "4"
           ]

              {- Lenses -}

_element1 :: Traversal' (Array String) String
_element1 = element 1 traversed


{- Solution to exercise about use of `traversed <<< traversed`

> view (traversed <<< traversed) [["1"], ["2", "3"]]
"123"

> _trav_trav = traversed <<< traversed
> view _trav_trav $ over _trav_trav Additive [[1], [2, 3]]
(Additive 6)

-}

_trav_1 :: forall traversable a b _1_.
          Traversable traversable => 
          Traversal (traversable (Tuple a _1_))
                    (traversable (Tuple b _1_))
                    a b
_trav_1 = traversed <<< _1

{- Solution to exercise about use of `traversed <<< _1`

> preview _trav_1 [ Tuple 1 2, Tuple 3 4 ]
(Just 1)

-}

_at3_trav_1 :: forall a _1_ atlike . 
               At atlike Int (Tuple a _1_) =>
               Traversal' (Map Int (Tuple a _1_)) a
_at3_trav_1 = at 3 <<< traversed <<< _1



-- Exercise solutions

_trav_trav :: forall a b trav1 trav2 .
              Traversable trav1 => Traversable trav2 =>
              Traversal (trav1 (trav2 a))
                        (trav1 (trav2 b))
                        a b
_trav_trav = traversed <<< traversed


_1_trav :: forall trav a b _1_ .
           Traversable trav =>
           Traversal (Tuple (trav a) _1_)
                     (Tuple (trav b) _1_)
                     a b
_1_trav = _1 <<< traversed


_trav_at3 :: forall trav keyed a.
             Traversable trav => At keyed Int a =>
               Traversal' (trav keyed) (Maybe a)
_trav_at3 = traversed <<< at 3

-- Why must `s` be the same as `t` and `a` be the same as `b`?
--
-- Consider this:
--
-- set _trav_at3 5 [Map.singleton 3 "3", Map.singleton 4 "4"]
--
-- If the optic could change the type, the result would be
-- this nonsensical array:
--
-- [Map.singleton 3 5, Map.singleton 4 "4"]


_at3_trav_1' :: forall a _1_ keyed .
                At keyed Int a => 
                  Traversal' (Map Int (Tuple a _1_)) a
_at3_trav_1' = at 3 <<< traversed <<< _1

