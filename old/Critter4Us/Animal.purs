module Critter4Us.Animal where

import Prelude
import Data.Lens
import Data.Array

type Name = String

type Animal =
  { name :: Name
  , tags :: Array String
  }

make :: Name -> Array String -> Animal
make name tags = { name : name, tags : tags }

addTag :: String -> Animal -> Animal
addTag tag animal = over tags (insert tag) animal
  

{- Lenses -}  

name :: Lens' Animal String
name = lens _.name $ _ { name = _ }

tags :: Lens' Animal (Array String)
tags = lens _.tags $ _ { tags = _ }

