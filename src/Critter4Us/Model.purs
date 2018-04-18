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
-- import Critter4Us.TagDb (TagDb)
-- import Critter4Us.TagDb as TagDb
import Data.Map (Map)
import Data.Map as Map
import Data.Lens (Lens', lens, over, setJust)
import Data.Lens.At (at)
import Data.Record.ShowRecord (showRecord)
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
  over (oneAnimal id) (map $ Animal.addTag tag)

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


{- Debug -}

-- `Show` a model when maps and records don't implement `Show`
grr :: Model -> String
grr model =
  foldMapWithIndex step model.animals
  where
    step k v =
      "(" <> show k <> "=>" <> showRecord v <> ") "

