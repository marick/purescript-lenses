module Critter4Us.Model
  ( Model
  , initialModel
  , addAnimalTag
  )
  where

import Prelude
import Critter4Us.Animal (Animal)
import Critter4Us.Animal as Animal
import Data.Map (Map)
import Data.Map as Map
import Data.Lens (Lens', lens, over)
import Data.Lens.At (at)
import Data.Maybe (Maybe)

type Model =
  { animals :: Map Animal.Id Animal
  }

initialModel :: Model
initialModel =
  { animals : Map.singleton startingAnimal.id startingAnimal }

addAnimalTag :: Animal.Id -> String -> Model -> Model
addAnimalTag id tag =
  updateAnimal id (Animal.addTag tag)


{- Internal -}

animals :: Lens' Model (Map Animal.Id Animal) 
animals =
  lens _.animals $ _ { animals = _ }

oneAnimal :: Animal.Id -> Lens' Model (Maybe Animal)
oneAnimal id =
  animals <<< at id 

updateAnimal :: Animal.Id -> (Animal -> Animal) -> Model -> Model
updateAnimal id f model =
  over (oneAnimal id) (map f) model

startingAnimal :: Animal
startingAnimal =
  Animal.named "Genesis" 3838 # Animal.addTag "mare"
