module PureScriptIssue where


{-

Give the following to the repl, and you'll see a hang. See GONE
comments below for changes that make the hang go away.

import PureScriptIssue
import Data.Map as Map

Map.keys initialModel.animals
-}

import Prelude
import Data.Map (Map)
import Data.Map as Map
import Data.Lens (Lens', lens, over, set)
import Data.Lens.At (at)
import Data.Maybe (Maybe(..))
import Data.Monoid (class Monoid, mempty)
import Data.Unfoldable (class Unfoldable, singleton)

type Id = Int
type Tags = Array String
type Ids = Array Id

type Animal =
  { id :: Id
  , name :: String
  }

type TagDb =
  { tagsById :: Map Id Tags
  , idsByTag :: Map String Ids
  }


{-
             GONE: delete `tagDb` (and its use in `empty`)
-}

type Model =
  { animals :: Map Id Animal
  , tagDb :: TagDb
  }

empty :: TagDb
empty =
  { tagsById : Map.empty
  , idsByTag : Map.empty
  }

{-
     GONE: Replace the `over` expression with this:

          over (idTags id) (const $ Just [tag])
-}


addTag :: Id -> String -> TagDb -> TagDb
addTag id tag =
  over (idTags id) (appendOrCreate tag)

-- I can't find a Lens function that does this for me. 
appendOrCreate :: forall a f. Monoid (f a) => Unfoldable f =>
                  a -> Maybe (f a) -> Maybe (f a)
appendOrCreate new (Just xs) = Just $ (xs <> singleton new)
appendOrCreate new Nothing = appendOrCreate new mempty

-- Lenses

tagsById :: Lens' TagDb (Map Id Tags)
tagsById =
  lens  _.tagsById $ _ { tagsById = _ } 

idTags :: Id -> Lens' TagDb (Maybe (Array String))
idTags id =
  tagsById <<< at id

initialModel :: Model
initialModel =
  { animals : Map.singleton startingAnimal.id startingAnimal
  , tagDb : addTag startingAnimal.id "mare" empty
  }
  where
    startingAnimal = { id : 3838, name : "Genesis" }
