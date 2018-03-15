module DictPath where

import Prelude

import Data.Lens (Lens', Traversal', _Just, lens)
import Data.Lens.At (at)
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe)
import Data.Tuple (Tuple(..))

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

modelToAnimals :: Lens' Model (Map String Animal)
modelToAnimals = lens _.animals $ _ { animals = _ }

animalsToAnimal :: String -> Lens' (Map String Animal) (Maybe Animal)
animalsToAnimal k = at k

animalToTags :: Lens' Animal Int
animalToTags = lens _.tags $ _ { tags = _ }

modelToTag :: String -> Traversal' Model Int
modelToTag k = modelToAnimals <<< animalsToAnimal k <<< _Just <<< animalToTags
