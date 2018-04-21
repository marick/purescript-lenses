module Critter4UsRefactored.Main where

{- For the repl, use these imports:

import Critter4UsRefactored.Main
import Critter4UsRefactored.Model
import Critter4Us.TagDb (tagsFor, idsFor)

grr initialModel
grr $ update initialModel (AddAnimal 1 "Bossy")
grr $ update initialModel (AddTag 3838 "skittish")

m = update initialModel (AddTag 3838 "skittish")
tagsFor 3838 m.tagDb
idsFor "skittish" m.tagDb
idsFor "missing" m.tagDb

-}

import Critter4UsRefactored.Animal as Animal
import Critter4UsRefactored.Model as Model
import Critter4UsRefactored.Model (Model)

data Action
  = AddAnimal Animal.Id String
  | AddTag Animal.Id String
    

update :: Model -> Action -> Model

update model (AddAnimal animalId name) =
  Model.addAnimal animalId name model

update model (AddTag animalId tag) =
  Model.addAnimalTag animalId tag model 
