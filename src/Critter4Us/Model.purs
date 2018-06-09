module Critter4Us.Model
  ( Model
  , initialModel
  , addAnimal
  , addAnimalTag
  )
  where

import Prelude
import Critter4Us.Animal (Animal)
import Critter4Us.Animal as Animal
-- import Critter4Us.TagDb (TagDb)
-- import Critter4Us.TagDb as TagDb
import Data.Map (Map)
import Data.Map as Map
import Data.Lens (Lens', lens, over, setJust)
import Data.Lens.At (at)
import Data.FoldableWithIndex (foldMapWithIndex)
import Data.Maybe (Maybe)

type Model =
  { animals :: Map Animal.Id Animal
  }

initialModel :: Model
initialModel =
  { animals : Map.singleton startingAnimal.id startingAnimal
  }
  where
    startingAnimal =
      Animal.named "Genesis" 3838 # Animal.addTag "mare"

addAnimalTag :: Animal.Id -> String -> Model -> Model
addAnimalTag id tag =
  over (_oneAnimal id) (map $ Animal.addTag tag)

addAnimal :: Animal.Id -> String -> Model -> Model
addAnimal id name =
  setJust (_oneAnimal id) (Animal.named name id)

{- Internal -}

_animals :: Lens' Model (Map Animal.Id Animal) 
_animals =
  lens _.animals $ _ { animals = _ }

_oneAnimal :: Animal.Id -> Lens' Model (Maybe Animal)
_oneAnimal id =
  _animals <<< at id 

