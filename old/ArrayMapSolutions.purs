module ArrayMapSolutions where

import Prelude
import Data.Array as Array
import Data.Lens.Index (ix)
import Data.Lens (Lens', lens, set)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (Tuple(..))

        {- `ix` exercise -}

mystery :: Int -> String
mystery = set (ix 1) "blue" show
-- :type showLens
-- Int -> String

{-
> mystery 0
"0"

> mystery 1
"blue"
-}

        {- At exercise -}

at' :: forall a. Int -> Lens' (Array a) (Maybe a)
at' index =
  lens getter setter
  where
    getter =
      flip Array.index index

    setter whole new =
      case Tuple new $ classify index whole of 
        Tuple _          WayPastEnd  ->  whole
        Tuple Nothing    LastElement -> Array.dropEnd 1 whole
        Tuple Nothing    _           -> whole
  
        Tuple (Just _) JustPastEnd -> setWith Array.insertAt new whole
        Tuple (Just _) _           -> setWith Array.updateAt new whole

    setWith f new whole =
      new >>= flip (f index) whole # fromMaybe whole

data IndexClassification
  = InteriorElement
  | LastElement
  | JustPastEnd
  | WayPastEnd

classify :: forall a. Int -> Array a -> IndexClassification
classify index array =
  if index < len - 1 then
     InteriorElement
  else if index == len - 1 then
     LastElement
  else if index == len then
     JustPastEnd
  else
     WayPastEnd
  where
    len = Array.length array
  

{- Step 2: But there's a problem. If we set a value way past the end of
   the array, the result will be an unchanged array.

   But the set-get law requires that what you `set` via a lens can be
   `view`ed via the same lens. But:


> set (at' 9999) (Just 555) shortArray # view (at' 9999)
Nothing

-}
