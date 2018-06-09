module ArrayMap where

{- Paste the following into the repl

import Data.Maybe
import Data.Tuple
import Data.Array as Array
import Data.Map as Map
import Data.Map (Map)
import Data.StrMap as StrMap
import Data.Set as Set

import Data.Lens
import Data.Lens.Index (ix)
import Data.Lens.At (at)

import ArrayMap

-}

import Prelude
import Data.Tuple (Tuple(..))
import Data.Maybe (Maybe(..))

import Data.Map as Map
import Data.Map (Map)

import Data.Lens (view, set, lens, Lens', _2, Traversal', _Just)
import Data.Lens.Index (ix)
import Data.Lens.At (at, class At)
import Data.Foldable (and)

        {- The type of `ix 1` -}

ix1 :: forall a. Traversal' (Array a) a
ix1 = ix 1

        {- Composing optics -} 


-- Index and Index
-- If you make an `Index` that you want to compose, you probably want to
-- assign it a type. 

_oneOneTyped :: forall a.
                Traversal' (Array (Array a)) a
_oneOneTyped = ix 1 <<< ix 1

_array2D :: forall a.
            Int -> Int -> Traversal' (Array (Array a)) a
_array2D i j = ix i <<< ix j


-- Lenses and indexes

-- These aren't the same names as in the text because (1) the point of the
-- text is that you don't need annotations, but (2) `pulp build` will
-- spew warnings unless there are annotations.

_lensFirst' :: forall a rest. Traversal' {first :: a | rest} a
_lensFirst' = lens _.first $ _ { first = _ }

_lensFirstFirst' :: forall a rest. Traversal' {first :: Array a | rest } a
_lensFirstFirst' = _lensFirst' <<< ix 1

_ixFirstFirst' :: forall a rest. Traversal' (Array {first :: a | rest}) a 
_ixFirstFirst' = ix 1 <<< _lensFirst'

--- Indexes and lenses and indexes

_chain :: forall key rest value . Ord key =>
          Int -> key ->
            Traversal'
              (Array { first :: Map key value | rest })
              value
_chain i key = ix i <<< _lensFirst' <<< ix key



        {- at -}

-- a home-grown implementation of `At.at`
_upsertable :: forall key val. Ord key =>
               key -> Lens' (Map key val) (Maybe val)
_upsertable key =
  lens getter setter
  where
    getter =
      Map.lookup key
    setter whole wrapped =
      case wrapped of
        Nothing -> Map.delete key whole
        Just new -> Map.insert key new whole

-- Laws
_someKey :: forall val. Lens' (Map String val) (Maybe val)
_someKey = _upsertable "key"

mapWithKey_Present :: Map String String
mapWithKey_Present = Map.singleton "key" "val"

mapWithKey_Absent :: Map String String
mapWithKey_Absent = Map.singleton "missing" "val2"

set_get :: Boolean
set_get =
  and [ check (Just "NEW") mapWithKey_Present
      , check (Just "NEW") mapWithKey_Absent
      , check Nothing mapWithKey_Present
      , check Nothing mapWithKey_Absent
      ]
  where
    check new whole =
      (set _someKey new whole # view _someKey) == new

get_set :: Boolean
get_set =
  and [ check mapWithKey_Present
      , check mapWithKey_Absent
      ]
  where
    check whole =
      set _someKey (view _someKey whole) whole == whole

set_set :: Boolean
set_set =
  and [ check (Just "NEW") mapWithKey_Present
      , check (Just "NEW") mapWithKey_Absent
      , check Nothing mapWithKey_Present
      , check Nothing mapWithKey_Absent
      ]
  where
    check new whole =
       (set _someKey new whole # set _someKey new) ==
       set _someKey new whole

-- An example of an `at` type declaration:
_x :: forall whole part. At whole String part =>
        Lens' whole (Maybe part)
_x = at "x"


-- Adding an `At` lens after one of last chapter's lenses

tupleMap :: Tuple Int (Map String Int)
tupleMap = Tuple 1 $ Map.singleton "x" 1

_tupleMap :: forall ignore val. 
                Lens'
                  (Tuple ignore (Map String val))
                  (Maybe val)
_tupleMap = _2 <<< at "x"










-- How `at` lenses compose with Index optics.

arrayMap :: Array (Map String Int)
arrayMap = [Map.empty, Map.singleton "x" 1]

arrayMapTyped :: forall focus.
                 Traversal' (Array (Map String focus)) (Maybe focus)
arrayMapTyped = ix 1 <<< at "x"








-- Adding `_Just` to simplify results

arrayMapJust :: forall focus.
                Traversal' (Array (Map String focus)) focus
arrayMapJust = ix 1 <<< at "x" <<< _Just

-- The versions with and without `Just` have very similar types.

whatsit :: forall focus.
             Traversal'
               (Array (Map String (Maybe focus)))
               (Maybe focus)
whatsit = ix 1 <<< at "x" <<< _Just



