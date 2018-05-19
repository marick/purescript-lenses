module Product where

{- Paste the following into the repl

import Product
import Data.Lens (lens, view, set, over)

import Data.Tuple
import Data.Record.ShowRecord (showRecord)
import Data.String as String
import Data.String.Yarn as String
-}

import Prelude
import Data.Tuple (Tuple(..), fst)
import Data.Lens (lens, Lens, Lens')

        {- Section: Tuple -} 

aTuple :: Tuple String Int
aTuple = Tuple "one" 1

_first :: forall a b ignored .
          Lens (Tuple a ignored)
               (Tuple b ignored)
               a b 
_first =
  lens getter setter
  where
    getter = fst
    setter (Tuple _ kept) new = Tuple new kept



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
   
