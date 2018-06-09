module Map where

{- Paste the following into the repl

import Map

import Data.Map as Map
import Data.Map (Map)
import Data.Set as Set

import Data.Maybe
import Data.Tuple
import Data.String as String

import Data.Lens
import Data.Lens.At (at)

-}

import Prelude
import Data.Tuple (Tuple)
import Data.Maybe (Maybe(..))

import Data.Map as Map
import Data.Map (Map)
import Foreign.Object as Object
import Foreign.Object (Object)
import Data.Set as Set
import Data.Set (Set)

import Data.Lens (view, set, lens, Lens', _1, _2, Traversal', _Just)
import Data.Lens.At (at, class At)


_key :: forall focus .
        Lens' (Map String focus) (Maybe focus)
_key = 
  lens getter setter
  where
    getter = Map.lookup "key"
    setter whole wrapped = 
      case wrapped of
        Just new -> Map.insert "key" new whole
        Nothing -> Map.delete "key" whole


_atKey :: forall key focus . Ord key => 
          key -> Lens' (Map key focus) (Maybe focus)
_atKey key = 
  lens getter setter
  where
    getter = Map.lookup key
    setter whole wrapped = 
      case wrapped of
        Just new -> Map.insert key new whole
        Nothing -> Map.delete key whole



_at3 :: forall t1 t3. At t1 Int t3 =>
        Lens' t1 (Maybe t3)
_at3 = at 3        


_at3' :: forall t3. Lens' (Map Int t3) (Maybe t3)
_at3' = _at3

_element :: forall a . Ord a => a -> Lens' (Set a) (Maybe Unit)
_element x = at x

-- composed :: forall elt1 elt2 at key focus .
--             At key at focus =>
--             Lens'
--               (Tuple (Tuple (at key focus) a) b)
--                          (Maybe focus)


composed :: forall collection focus a b .
  At collection Int focus => 
  Lens'
    (Tuple (Tuple a collection) b)
    (Maybe focus)
composed = _1 <<< _2 <<< at 3
