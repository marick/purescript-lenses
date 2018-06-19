module Intro where

{- Paste the following into the repl

import Intro
import Data.Map as Map
import Critter4Us.Animal as Animal
import Data.Maybe
import Data.Lens as Lens
-}

-- Examples used in the introduction.
-- This file isn't mentioned in the book.

import Prelude
import Critter4Us.Animal as Animal
import Critter4Us.Animal (Animal)
import Critter4Us.Model as Model
import Critter4Us.Model (Model)

import Data.Maybe (Maybe)
import Data.Map as Map
import Data.Map (Map)

import Data.Lens.At (at)
import Data.Lens (Lens', lens)

model :: Model
model = Model.initialModel

viewAnimal :: Animal.Id -> Model -> Maybe Animal
viewAnimal id = _.animals >>> Map.lookup id  

_animal :: Animal.Id -> Model -> Maybe Animal
_animal id = _.animals >>> Map.lookup id  

view :: forall whole part . (whole -> part) -> whole -> part
view optic whole = optic whole

_animals :: Lens' Model (Map Animal.Id Animal)
_animals =
  lens _.animals $ _ { animals = _ }

_animal' :: Animal.Id -> Lens' Model (Maybe Animal)
_animal' id = _animals <<< at id
