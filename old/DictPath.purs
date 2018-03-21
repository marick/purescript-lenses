module DictPath where

import Prelude
import Data.Tuple (Tuple(..))
import Data.Map as Map
import Data.Map (Map)
import Data.Lens.Index (ix)
import Data.Lens.At (at, class At)
import Data.Lens (preview, view, set, over, Lens', lens, _Just)
import Data.Maybe (Maybe(..))
import Data.Profunctor.Strong
import Data.Record.ShowRecord

type Animal =
  { tags :: Int
  }

type Model =
  { animals :: Map String Animal
  }

model :: Model
model =
  { animals :
      Map.fromFoldable
      [ Tuple "jake" {tags : 4}
      , Tuple "skitter" {tags : 6}
      ]
  }

modelToAnimals :: Lens' Model (Map String Animal)
modelToAnimals = lens _.animals $ _ { animals = _ }

{- The following is the type that the compiler suggests:
     mapToAnimal :: forall b a m. At m a b => a -> (forall p. Strong p => p (Maybe b) (Maybe b) -> p m m)
   Interestingly, if you uncomment that, you'll get the following error:

  35  mapToAnimal = at
                    ^^
  Could not match constrained type
  
    Strong t3 => t3 (Maybe t4) (Maybe t4) -> t3 t5 t5
  
  with type
  
    Strong p6 => p6 (Maybe b1) (Maybe b1) -> p6 m2 m2


What's up with that? Compiler error?

-}
  
animalsToAnimal = at

animalToTags :: Lens' Animal Int
animalToTags = lens _.tags $ _ { tags = _ }


{-
   What I *want* to say with these three lenses is this:

   modelToTag id =
     modelToAnimals <<< animalsToAnimal id <<< animalToTags

   I can get partway there with this:

     > :t view (modelToAnimals <<< animalsToAnimal "jake") model
     Maybe          
       { tags :: Int
       }

   ... but I don't know how to add on past that.
-}

modelToTag id =
  modelToAnimals <<< animalsToAnimal id <<< _Just <<< animalToTags

