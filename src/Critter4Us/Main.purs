module Critter4Us.Main where

{- For the repl, use these imports:

import Critter4Us.Main
import Critter4Us.Model

> initialModel
{ animals: (fromFoldable [(Tuple 3838 { id: 3838, name: "Genesis", tags: ["mare"] })]) }

> update initialModel (AddAnimal 1 "Bossy")
"(1=>{ id: 1, name: \"Bossy\", tags: [] }) (3838=>{ id: 3838, name: \"Genesis\", tags: [\"mare\"] }) "

> update initialModel (AddTag 3838 "skittish")
"(3838=>{ id: 3838, name: \"Genesis\", tags: [\"mare\",\"skittish\"] }) "

-}

import Critter4Us.Animal as Animal
import Critter4Us.Model as Model
import Critter4Us.Model (Model)

data Action
  = AddAnimal Animal.Id String
  | AddTag Animal.Id String
    

update :: Model -> Action -> Model

update model (AddAnimal animalId name) =
  Model.addAnimal animalId name model

update model (AddTag animalId tag) =
  Model.addAnimalTag animalId tag model 
