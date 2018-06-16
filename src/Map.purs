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
import Foreign.Object as Object

-}

import Prelude
import Data.Tuple (Tuple)
import Data.Maybe (Maybe(..))

import Data.Map as Map
import Data.Map (Map)
import Data.Set (Set)

import Data.Lens (lens, Lens', _1, _2)
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

composed :: forall collection focus a b .
  At collection Int focus => 
  Lens'
    (Tuple (Tuple a collection) b)
    (Maybe focus)
composed = _1 <<< _2 <<< at 3
