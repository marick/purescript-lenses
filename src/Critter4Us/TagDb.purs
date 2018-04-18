module Critter4Us.TagDb
  ( empty
  , addTag
  , TagDb
  , Tags
  , Ids
  ) where 

import Prelude
import Critter4Us.Animal as Animal
import Data.Map as Map
import Data.Map (Map)
import Data.Lens (Lens', lens, over)
import Data.Lens.At (at)
import Data.Maybe (Maybe(..))
import Data.Monoid (class Monoid, mempty)
import Data.Unfoldable (class Unfoldable, singleton)

type Tags = Array String
type Ids = Array Animal.Id

type TagDb =
  { tagsById :: Map Animal.Id Tags
  , idsByTag :: Map String Ids
  }

empty :: TagDb
empty =
  { tagsById : Map.empty
  , idsByTag : Map.empty
  }


addTag :: Animal.Id -> String -> TagDb -> TagDb
addTag id tag db = 
  db
    # addTagTo id tag
    # addIdTo tag id

--- Helpers

addTagTo :: Animal.Id -> String -> TagDb -> TagDb
addTagTo id tag =
  over (idTags id) $ appendOrCreate tag

addIdTo :: String -> Animal.Id -> TagDb -> TagDb
addIdTo tag id = 
  over (tagIds tag) $ appendOrCreate id

-- I can't find a Lens function that does this for me. 
appendOrCreate :: forall a f. Monoid (f a) => Unfoldable f =>
                  a -> Maybe (f a) -> Maybe (f a)
appendOrCreate new (Just xs) = Just $ (xs <> singleton new)
appendOrCreate new Nothing = appendOrCreate new mempty

-- Lenses

tagsById :: Lens' TagDb (Map Animal.Id Tags)
tagsById =
  lens  _.tagsById $ _ { tagsById = _ } 

idsByTag :: Lens' TagDb (Map String Ids)
idsByTag =
  lens _.idsByTag $ _ { idsByTag = _ }

idTags :: Animal.Id -> Lens' TagDb (Maybe (Array String))
idTags id =
  tagsById <<< at id

tagIds :: String -> Lens' TagDb (Maybe (Array Animal.Id))
tagIds tag =
  idsByTag <<< at tag


