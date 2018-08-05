module SumTypeSolutions where

{-   If you want to try out examples, paste the following into the repl.

import SumTypeSolutions
import Data.Lens
import Data.Lens.Prism
import Data.Maybe
import Data.Either
-}

import Prelude
import Data.Lens

import Data.Maybe (Maybe(..))
import Data.Int (fromString)


_word :: forall a . Eq a => a -> Prism' a a 
_word focus = 
  prism' identity focuser
  where
    focuser a =
      if a == focus then
        Just a
      else
        Nothing

_intSource :: Prism' String String
_intSource =
  prism' identity focuser
  where
    focuser s = case (fromString s) of
      Just _ -> Just s
      Nothing -> Nothing

_int :: Prism' String Int
_int =
  prism' show focuser
  where
    focuser s = case (fromString s) of
      Just i -> Just i
      Nothing -> Nothing
