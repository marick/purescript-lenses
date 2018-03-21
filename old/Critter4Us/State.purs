module Critter4Us.State where

import Prelude
import Data.Map as Map
import Data.Map (Map)
import Data.Lens.Index (ix)
import Data.Lens
import Critter4Us.Animal as Animal
import Critter4Us.Animal (Animal)
import Data.Array
import Data.Tuple
import Data.FoldableWithIndex


type Id = Int

type State =
  { animals :: Map Int Animal
  }

init =
  { animals : animals [ Tuple "jake" ["gelding", "skittish"]
                      , Tuple "betsy" ["first calf heifer"]
                      ]
  }
  where
    animals =
      foldlWithIndex nextAnimal Map.empty
    nextAnimal id acc description =
      Map.insert id (animal description) acc
    animal =
      uncurry Animal.make


-- addTag :: String -> String -> State
-- addTag name           

{- Lenses -}

animals :: Lens' State (Map Id Animal)
animals = lens _.animals $ _ { animals = _ }

animal :: Id -> Traversal' State Animal
animal id = animals <<< ix id

