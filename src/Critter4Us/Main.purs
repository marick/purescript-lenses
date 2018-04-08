module Critter4Us.Main where

{- For the repl, use these imports:

import Critter4Us.Main
import Critter4Us.Model

-}

import Prelude
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
