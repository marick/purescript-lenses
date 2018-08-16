module SumTypeSolutions where

{-   If you want to try out examples, paste the following into the repl.

import SumTypeSolutions
import Data.Lens
import Data.Lens.Prism
import Data.Maybe
import Data.Either
-}

import Prelude
import Data.Lens (Prism', prism')

import Data.Maybe (Maybe(..))
import Data.Int (fromString)

-- 1: 
_intSource :: Prism' String String
_intSource =
  prism' identity focuser
  where
    focuser s = case (fromString s) of
      Just _ -> Just s
      Nothing -> Nothing

{-
The prism laws:

-- review-preview
> "3838" # review _intSource # preview _intSource
(Just "3838")


-- preview-review
> "38383" # preview _intSource <#> review _intSource
(Just "38383")
-}


-- 2:
_int :: Prism' String Int
_int =
  prism' show focuser
  where
    focuser s = case (fromString s) of
      Just i -> Just i
      Nothing -> Nothing

{-
Yes, it obeys the prism laws.

The prism laws:

-- review-preview
> 3838 # review _int # preview _int
(Just 3838)

-- preview-review
> "38383" # preview _int <#> review _int
(Just "38383")

-}



-- 3

-- Well, *I* can't figure out how. Consider this implementation:


_word :: forall a . Eq a => a -> Prism' a a 
_word focus = 
  prism' (const focus) focuser
  where
    focuser a =
      if a == focus then
        Just a
      else
        Nothing

{-

Now think about the "`preview` retrieves what was given to `review`." law.

Here's an example of `review`:

   > review (_word "Dawn") "anything"
   "Dawn"

But `preview` doesn't produce (Just "anything"): it can only produce
`(Just "Dawn")` or `Nothing`.

   > preview (_word "Dawn") "Dawn"
   (Just "Dawn")

... or, to more closely match the example in the statement of the law:

   > _dawn = _word "Dawn"
   > "anything" # review _dawn # preview _dawn 
   (Just "Dawn")

-}

-- We can get the prism to return its argument by making `identity` the constructor:

_word' :: forall a . Eq a => a -> Prism' a a 
_word' focus = 
  prism' identity focuser
         --^^^^^^         
  where
    focuser a =
      if a == focus then
        Just a
      else
        Nothing

{-
That makes `review` produce its input, but now `preview` produces nothing.

   > review (_word' "Dawn") "anything"
   "anything"

   > preview (_word' "Dawn") "anything"
   Nothing

... or:

   > _dawn = _word' "Dawn"
   > "anything" # review _dawn # preview _dawn
   Nothing
-} 
