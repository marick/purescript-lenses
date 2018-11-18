module Product where

{- Paste the following into the repl

import Product
import Data.Lens (lens, view, set, over, _1, _2)

import Data.Tuple
import Data.String as String
import Data.Array as Array
import Data.Map as Map
-}

import Prelude
import Data.Tuple (Tuple(..), fst)
import Data.Lens (lens, Lens, Lens', _2)
import Data.Profunctor.Strong (class Strong)

        {- Section: Tuple -} 

aTuple :: Tuple String Int
aTuple = Tuple "one" 1


-- For this annotation, I'm using the same type the compiler would infer:
_first :: forall p t6 t7 t8. Strong p =>
          p t6 t8 -> p (Tuple t6 t7) (Tuple t8 t7)
_first =
  lens getter setter
  where
    getter = fst
    setter (Tuple _ kept) new = Tuple new kept

-- A more readable type annotation would be this:
_first' :: forall a b ignored .
           Lens (Tuple a ignored)
                (Tuple b ignored)
                a b 
_first' = _first

        {- Section: Records -}

type Event = 
  { subject :: String
  , object :: String
  , action :: String
  , count :: Int
  }
  
duringNetflix :: Event
duringNetflix = { subject : "Brian"
                , object : "Dawn"
                , action : "cafuné"
                , count : 0
                }

-- A verbose way of defining a record lens
_action :: forall a b rest . 
           Lens {action :: a | rest }
                {action :: b | rest }
                a b
_action =
  lens getter setter
  where
    getter = _.action
    setter whole new = whole { action = new }


_count :: Lens' Event Int
-- Could also use the long form:
-- _count :: Lens Event Event Int Int
_count = lens _.count $ _ { count = _ }


        {- Section: Composing lenses -}

both :: Tuple String Event
both = Tuple "example" duringNetflix

_bothCount :: Lens' (Tuple String Event) Int
_bothCount = _2 <<< _count
