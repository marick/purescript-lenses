module DictPath where

{- Paste the following into the repl

import Data.Array as Array
import Data.Map as Map

import Data.Lens
import Data.Lens as Lens
import Data.Lens.Index (ix)
import Data.Record.ShowRecord

-}

import Prelude
import Data.Array as Array
import Data.Tuple
import Data.Map as Map
import Data.Map (Map)
import Data.Lens.Index (ix)
import Data.Lens.At (at, class At)
import Data.Lens (preview, view, set, over, Lens', lens)
import Data.Maybe (Maybe(..))
import Data.Profunctor.Strong

type Animal =
  { tags :: Int
  }

type Model =
  { animals :: Map String Animal
  }

model :: Model
model =
  { animals :
      Map.fromFoldable
      [ Tuple "jake" {tags : 4}
      , Tuple "skitter" {tags : 6}
      ]
  }

modelToMap :: Lens' Model (Map String Animal)
modelToMap = lens _.animals $ _ { animals = _ }


-- mapToAnimal :: forall b a m. At m a b => a -> (forall p. Strong p => p (Maybe b) (Maybe b) -> p m m)
mapToAnimal = at

animalToTags :: Lens' Animal Int
animalToTags = lens _.tags $ _ { tags = _ }



