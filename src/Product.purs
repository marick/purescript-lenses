module Product where

{- Paste the following into the repl

import Data.Tuple (Tuple(..), fst, snd)
import Data.String.Yarn as String
import Data.Record.ShowRecord
import Data.String as String

import Data.Lens (lens, view, set, over)
import Data.Lens as Lens

-}


import Data.Tuple (Tuple(..), fst)
import Data.Lens (lens)
import Data.Lens.Types (Lens, Lens')

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

action :: forall a b ignored . 
          Lens {action :: a | ignored }
               {action :: b | ignored }
               a b
action =
  lens getter setter
  where
    getter = _.action
    setter whole new = whole { action = new }

-- count :: Lens Event Event Int Int
count :: Lens' Event Int    
count = lens _.count (_ { count = _ })


both :: Tuple String Event
both = Tuple "example" duringNetflix

