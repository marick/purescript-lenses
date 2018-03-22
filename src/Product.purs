module Product where

{- Paste the following into the repl

import Data.Tuple (Tuple(..), fst, snd)
import Data.String.Yarn as String
import Data.Record.ShowRecord
import Data.String as String

import Data.Lens (lens, view, set, over)
import Data.Lens as Lens

import Product

-}

import Prelude
import Data.Tuple (Tuple(..), fst)
import Data.Lens (lens, Lens, Lens')

        {- First example of creating a lens. There are terser ways -} 

aTuple :: Tuple String Int
aTuple = Tuple "one" 1

first :: forall a b ignored .
         Lens (Tuple a ignored)
              (Tuple b ignored)
              a b 
first =
  lens getter setter
  where
    getter = fst
    setter (Tuple _ kept) new = Tuple new kept



        {- Record lenses -}

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
action :: forall a b rest . 
          Lens {action :: a | rest }
               {action :: b | rest }
               a b
action =
  lens getter setter
  where
    getter = _.action
    setter whole new = whole { action = new }


count :: Lens' Event Int
-- Could also use the long form:
-- count :: Lens Event Event Int Int
count = lens _.count $ _ { count = _ }


        {- To demonstrate composition -}

both :: Tuple String Event
both = Tuple "example" duringNetflix
   
