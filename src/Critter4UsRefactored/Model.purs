module Critter4UsRefactored.Model
  ( Model
  , initialModel
  , addAnimal
  , addAnimalTag

  , grr
  )
  where

import Prelude
import Critter4UsRefactored.Animal (Animal)
import Critter4UsRefactored.Animal as Animal
import Critter4Us.TagDb (TagDb)
import Critter4Us.TagDb as TagDb
import Data.Map (Map)
import Data.Map as Map
import Data.Lens (Lens', lens, over, setJust)
import Data.Lens.At (at)
import Data.Record.ShowRecord (showRecord)
import Data.FoldableWithIndex (foldMapWithIndex)
import Data.Maybe (Maybe)

type Model =
  { animals :: Map Animal.Id Animal
  , tagDb :: TagDb
  }

initialModel :: Model
initialModel =
  { animals : Map.singleton startingAnimal.id startingAnimal
  , tagDb : TagDb.addTag startingAnimal.id "mare" TagDb.empty
  }
  where
    startingAnimal =
      Animal.named "Genesis" 3838 

addAnimalTag :: Animal.Id -> String -> Model -> Model
addAnimalTag id tag =
  over tagDb $ TagDb.addTag id tag

addAnimal :: Animal.Id -> String -> Model -> Model
addAnimal id name =
  setJust (oneAnimal id) (Animal.named name id)

{- Internal -}

animals :: Lens' Model (Map Animal.Id Animal) 
animals =
  lens _.animals $ _ { animals = _ }

tagDb :: Lens' Model TagDb 
tagDb =
  lens _.tagDb $ _ { tagDb = _ }

oneAnimal :: Animal.Id -> Lens' Model (Maybe Animal)
oneAnimal id =
  animals <<< at id 


{- Debug -}

-- `Show` a model when maps and records don't implement `Show`. When changing this
-- to show TagDb, replace the first line with the commented lines below.
grr :: Model -> String
grr model =
  "ANIMALS  " <>
  foldMapWithIndex step model.animals <> 
  " === TAGDB " <>
  TagDb.grr model.tagDb
  where
    step k v =
      "(" <> show k <> "=>" <> showRecord v <> ")"
