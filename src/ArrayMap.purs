module ArrayMap where

{- Paste the following into the repl

import Data.Maybe
import Data.Tuple
import Data.Array as Array
import Data.Map as Map
import Data.StrMap as StrMap
import Data.Set as Set

import Data.Lens
import Data.Lens as Lens
import Data.Lens.Index (ix)
import Data.Lens.At (at)

import ArrayMap

import Data.Record.ShowRecord

-}

import Prelude
import Data.Tuple (Tuple(..))
import Data.Maybe (Maybe(..))

import Data.Map as Map
import Data.Map (Map)
import Data.StrMap as StrMap
import Data.StrMap (StrMap)

import Data.Lens (preview, view, set, over, lens, Lens', -- old
                  Traversal') -- new
import Data.Lens as Lens
import Data.Lens.Index (ix)
import Data.Lens.At (at, class At)
import Data.Foldable (and)










{- A bunch of exampls of the optic `ix` produces -}


-- applied to arrays

previewIx1 :: Maybe Int
previewIx1 = preview (ix 1) [0, 1, 2]
-- Just 1
previewIx1' :: Maybe Int
previewIx1' = preview (ix 1) [0]
-- Nothing

setIx1 :: Array Int 
setIx1 = set (ix 1) 8888 [0, 1, 2]
-- [0,8888,2]
setIx1' :: Array Int 
setIx1' = set (ix 1) 8888 [0]
-- Nothing

overIx1 :: Array Int
overIx1 = over (ix 1) negate [0, 1, 2]
-- [0,-1,2]
overIx1' :: Array Int
overIx1' = over (ix 1) negate [0]


-- Same optic, but applied to maps.

previewIx1Map :: Maybe String
previewIx1Map = preview (ix 1) $ Map.singleton 1  "found"
-- (Just "found")
previewIx2Map :: Maybe String
previewIx2Map = preview (ix 1) $ Map.singleton 99 "extra"
-- Nothing

setIx1Map :: Map Int String
setIx1Map = set (ix 1) "new" $ Map.singleton 1  "found"
-- (fromFoldable [(Tuple 1 "new")])
setIx2Map :: Map Int String
setIx2Map = set (ix 1) "new" $ Map.singleton 99 "found"
-- (fromFoldable [(Tuple 99 "found")])


-- Using `ix` with non-integer arguments.

previewIxKey :: Maybe String
previewIxKey = preview (ix "key") $ StrMap.fromFoldable [Tuple "key" "val"]
-- (Just "val")

setIxKey :: StrMap String
setIxKey = set (ix "key") "val2" $ StrMap.fromFoldable [Tuple "nokey" "val"]
-- (fromFoldable [(Tuple "nokey" "val")]) -- No change



        {- Composing optics -} 


-- Index and Index
-- If you make an `Index` that you want to compose, you probably want to
-- assign it a type. 

oneOneTyped :: forall a.
               Traversal' (Array (Array a)) a
oneOneTyped = ix 1 <<< ix 1

array2D :: forall a.
           Int -> Int -> Traversal' (Array (Array a)) a
array2D i j = ix i <<< ix j


-- Lenses and indexes

-- These aren't the same names as in the text because (1) the point of the
-- text is that you don't need annotations, but (2) `pulp build` will
-- spew warnings unless there are annotations.

lensFirst' :: forall a rest. Traversal' {first :: a | rest} a
lensFirst' = lens _.first $ _ { first = _ }

lensFirstFirst' :: forall a rest. Traversal' {first :: Array a | rest } a
lensFirstFirst' = lensFirst' <<< ix 1

ixFirstFirst' :: forall a rest. Traversal' (Array {first :: a | rest}) a 
ixFirstFirst' = ix 1 <<< lensFirst'

--- Indexes and lenses and indexes

chain :: forall key rest value . Ord key =>
         Int -> key ->
           Traversal'
             (Array { first :: Map key value | rest })
             value
chain i key = ix i <<< lensFirst' <<< ix key



        {- at -}

-- a home-grown implementation of `At.at`
upsertable :: forall key val. Ord key =>
              key -> Lens' (Map key val) (Maybe val)
upsertable key =
  lens getter setter
  where
    getter =
      Map.lookup key
    setter whole wrapped =
      case wrapped of
        Nothing -> Map.delete key whole
        Just new -> Map.insert key new whole

-- Laws
anyKey :: forall val. Lens' (Map String val) (Maybe val)
anyKey = upsertable "key"

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
      (set anyKey new whole # view anyKey) == new

get_set :: Boolean
get_set =
  and [ check mapWithKey_Present
      , check mapWithKey_Absent
      ]
  where
    check whole =
      set anyKey (view anyKey whole) whole == whole

set_set :: Boolean
set_set =
  and [ check (Just "NEW") mapWithKey_Present
      , check (Just "NEW") mapWithKey_Absent
      , check Nothing mapWithKey_Present
      , check Nothing mapWithKey_Absent
      ]
  where
    check new whole =
       (set anyKey new whole # set anyKey new) ==
       set anyKey new whole

-- An example of an `at` type declaration:
x :: forall whole part. At whole String part =>
       Lens' whole (Maybe part)
x = at "x"


-- How `at` lenses compose with last chapter's lenses:

tupleMap :: Tuple Int (Map String Int)
tupleMap = Tuple 1 $ Map.singleton "x" 1

tupleMapLens :: forall ignore val. 
                Lens'
                  (Tuple ignore (Map String val))
                 (Maybe val)
tupleMapLens = Lens.second <<< at "x"


-- How `at` lenses compose with Index optics.

arrayMap :: Array (Map String Int)
arrayMap = [Map.empty, Map.singleton "x" 1]

arrayMapTyped :: forall focus.
                 Traversal' (Array (Map String focus)) (Maybe focus)
arrayMapTyped = ix 1 <<< at "x"


-- Adding `_Just` to simplify results

arrayMapJust :: forall focus.
                Traversal' (Array (Map String focus)) focus
arrayMapJust = ix 1 <<< at "x" <<< Lens._Just

-- The versions with and without `Just` have very similar types.

whatsit :: forall focus.
             Traversal'
               (Array (Map String (Maybe focus)))
               (Maybe focus)
whatsit = ix 1 <<< at "x" <<< Lens._Just



