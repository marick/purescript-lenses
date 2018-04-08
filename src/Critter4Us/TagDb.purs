module Critter4Us.TagDb where 

import Prelude
import Critter4Us.Animal as Animal
import Data.Map as Map
import Data.Map (Map)
import Data.Lens
import Data.Lens.At (at)
import Data.Maybe
import Data.Array (snoc)

type IdToTags = Map Animal.Id (Array String)
type TagToIds = Map String (Array Animal.Id)

type TagDb =
  { allTags :: IdToTags
  , allIds :: TagToIds
  }

empty :: TagDb
empty =
  { allTags : Map.empty
  , allIds : Map.empty
  }

-- addAnimal : Animal.Id -> List String -> TagDb -> TagDb
-- addAnimal id tags db =
--   let
--     withId =
--       Lens.set (Support.idTags_upsert id) (Just Array.empty) db
--   in
--     List.foldl (addTag id) withId tags
  

addTag :: Animal.Id -> String -> TagDb -> TagDb
addTag id tag db = 
  db
    # addTagTo id tag
    # addIdTo tag id

-- --- Helpers

-- type alias StringsMapper = Array String -> Array String
-- type alias IdsMapper = Array Animal.Id -> Array Animal.Id

-- updateIdTags : Animal.Id -> StringsMapper -> TagDb -> TagDb
-- updateIdTags id = 
--   Lens.update (Support.idTags id)

-- updateTagIds: String -> IdsMapper -> TagDb -> TagDb
-- updateTagIds tag =
--   Lens.updateWithDefault (Support.tagIds_upsert tag) Array.empty

addTagTo :: Animal.Id -> String -> TagDb -> TagDb
addTagTo id tag =
  over (idTags id) (map (flip snoc tag))

addIdTo :: String -> Animal.Id -> TagDb -> TagDb
addIdTo tag id = 
  over (tagIds tag) (map (flip snoc id))  
         
-- Lenses

allTags :: Lens' TagDb IdToTags
allTags =
  lens  _.allTags $ _ { allTags = _ } 

allIds :: Lens' TagDb TagToIds
allIds =
  lens _.allIds $ _ { allIds = _ }


idTags :: Animal.Id -> Lens' TagDb (Maybe (Array String))
idTags id =
  allTags <<< at id


tagIds :: String -> Lens' TagDb (Maybe (Array Animal.Id))
tagIds tag =
  allIds <<< at tag

