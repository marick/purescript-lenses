module Critter4Us.Model
  ( Model
  , initialModel
  , addAnimal
  , addAnimalTag

  , grr
  )
  where

import Prelude
import Critter4Us.Animal (Animal)
import Critter4Us.Animal as Animal
import Data.Map (Map)
import Data.Map as Map
import Data.Lens (Lens', lens, over, setJust)
import Data.Lens.At (at)
import Data.Maybe (Maybe)
import Data.Record.ShowRecord
import Data.Foldable
import Data.Maybe

type Model =
  { animals :: Map Animal.Id Animal
  }

initialModel :: Model
initialModel =
  { animals : Map.singleton startingAnimal.id startingAnimal }

addAnimalTag :: Animal.Id -> String -> Model -> Model
addAnimalTag id tag =
  updateAnimal id (Animal.addTag tag)

addAnimal :: Animal.Id -> String -> Model -> Model
addAnimal id name =
  setJust (oneAnimal id) (Animal.named name id)

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


{- Debug -}

-- `Show` a model when maps and records don't implement `Show`
-- I trust there's a better way.
grr :: Model -> String
grr {animals} =
  foldl step "" (Map.keys animals)
  where
    step acc k =
      acc <> " (" <> show k <> "=>" <> maybe "!?" showRecord (Map.lookup k animals)

