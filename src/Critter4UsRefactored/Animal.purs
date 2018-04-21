module Critter4UsRefactored.Animal
  ( Animal
  , Id
  , Tags
  , named
  )
  where

import Prelude
import Data.Lens (Lens', lens, over, set)
import Data.Array (snoc)

type Id = Int
type Tags = Array String

type Animal =
  { id :: Id
  , name :: String
  }

named :: String -> Id -> Animal
named name id =
  { id, name }

