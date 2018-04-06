module Critter4Us.Animal
  ( Animal
  , Id
  , Tags
  , named
  , addTag
  , clearTags
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
  , tags :: Tags
  }

named :: String -> Id -> Animal
named name id =
  { id, name, tags : [] }

clearTags :: Animal -> Animal
clearTags = set tags []

-- Note: let's make it the UI's job to disallow duplicate tags.
addTag :: String -> Animal -> Animal
addTag tag = 
  over tags (flip snoc tag)


{- Internal -}

tags :: Lens' Animal Tags
tags = lens _.tags $ _ { tags = _ }
