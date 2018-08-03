module SumType where

{-   If you want to try out examples, paste the following into the repl.

import SumType
import Data.Lens
import Data.Lens.Prism
import Color as Color
import Data.Maybe
import Data.Either
import Data.Tuple
-}

import Prelude
import Data.Lens

import Color (Color)
import Color as Color

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq as GEq
import Data.Generic.Rep.Show as GShow
import Data.Maybe (Maybe(..), maybe)
import Data.Either (Either(..))
import Data.Tuple


                {- The types in question -}

newtype Percent = Percent Number
data Point = Point Number Number

data Fill -- think of a paint program filling a shape
  = Solid Color
  | LinearGradient Color Color Percent
  | RadialGradient Color Color Point
  | NoFill

                {------ Some samples to work with ------}

fillBlackToWhite :: Fill
fillBlackToWhite = LinearGradient Color.black Color.white $ Percent 3.3

fillWhiteToBlack :: Fill
fillWhiteToBlack = LinearGradient Color.white Color.black $ Percent 3.3

fillRadial :: Fill
fillRadial = RadialGradient Color.white Color.black $ Point 1.0 3.4


                {------ Making prisms with Maybe and `prism'` ------}

-- `prism'` (note the apostrophe) takes two functions. One is a data
-- constructor for the type in question. The other converts your
-- desired case to a `Just <wrapped values>` or `Nothing`.

_solidFocus :: Prism' Fill Color
_solidFocus = prism' constructor focus
  where
    constructor = Solid
    focus fill = case fill of
      Solid color -> Just color
      otherCases -> Nothing

-- In real life, you might abbreviate the above to this:

_solidFocus' :: Prism' Fill Color
_solidFocus' = prism' Solid case _ of
  Solid color -> Just color
  _ -> Nothing


                {------ Basic usage: `preview`, `review`, `is`, and `isn't` ------}

-- After building a prism, you focus in on a color with `preview`:

s1 :: Maybe Color
s1 = preview _solidFocus (Solid Color.white)
-- (Just rgba 255 255 255 1.0)

s2 :: Maybe Color
s2 = preview _solidFocus fillRadial
-- Nothing

-- ... or you can create a Fill from a color with `review`:

s3 :: Fill
s3 = review _solidFocus Color.white
-- (Solid rgba 255 255 255 1.0)

-- ... or you can ask whether a given value matches the prism:

s4 :: Boolean
s4 = is _solidFocus (Solid Color.white) :: Boolean
-- true

s5 :: Boolean
s5 = isn't _solidFocus (Solid Color.white) :: Boolean
-- false


                {------ Making prisms with Either and `prism` ------}

_anotherSolidFocus :: Prism' Fill Color
_anotherSolidFocus = prism Solid case _ of
  Solid color -> Right color
  otherCases -> Left otherCases


                {------ Making prisms with `only` ------}

_solidWhite :: Prism' Fill Unit
_solidWhite = only (Solid Color.white)

-- To make the above work, I had to make `Fill` implement `class Eq`. See the
-- end of the file for how. (There may be easier methods these days.)

                {------ Making prisms with `nearly` ------}

_solidWhite' :: Prism' Fill Unit
_solidWhite' =
  nearly (Solid Color.white) case _ of
    Solid color -> color == Color.white
    _ -> false
    
  









    


                {------ Multiple wrapped values ------}


-- This would violate the lens laws:

_radialPointFocus :: Prism' Fill Point
_radialPointFocus = prism' constructor focus
  where
    focus = case _ of
      RadialGradient _ _ point -> Just point
      _ -> Nothing
    
    constructor point =
      RadialGradient Color.black Color.white point

-- So we must bundle all the `RadialGradient` values. I'll use a record:

type RadialInterchange =
  { color1 :: Color
  , color2 :: Color
  , center :: Point
  }

_radialFocus :: Prism' Fill RadialInterchange
_radialFocus = prism constructor focus
  where
    focus = case _ of
      RadialGradient color1 color2 center ->
        Right {color1, color2, center}
      otherCases ->
        Left otherCases
        
    constructor {color1, color2, center} =
      RadialGradient color1 color2 center
        



-- Even though made differently than `_solidFocus`, `_radialFocus` is
-- used the same way:

l1 :: String
l1 = preview _radialFocus fillRadial # maybe "!" show
-- "{ color1: rgba 0 0 0 1.0, color2: rgba 255 255 255 1.0, percent: (3.3%) }"

l2 :: Fill
l2 = review _radialFocus { color1 : Color.black
                         , color2 : Color.white
                         , center : Point 1.3 2.4
                         }


_hslaFocus = prism' constructor focus
  where
    focus = case _ of
      Solid color -> Just $ Color.toHSLA color
      _ -> Nothing

    constructor {h,s,l,a} = 
      Solid $ Color.hsla h s l a 





_deepSolidFocus :: forall ignore. 
                  Prism' (Either ignore Fill) Color
_deepSolidFocus = _Right <<< _solidFocus

-- tupleSolidFocus :: forall ignore.
--                    APrism' (Tuple Fill ignore) Color
_tupleSolidFocus = _1 <<< _solidFocus

_eitherTupleFocus = _Left <<< _1


                {------ Constructing more specific prisms ------}

-- `only` is used to check for a specific value:

_whiteToBlackFocus :: Prism' Fill Unit
_whiteToBlackFocus = only fillWhiteToBlack

o1 :: Boolean
o1 = is _whiteToBlackFocus fillWhiteToBlack :: Boolean
-- true

o2 :: Boolean
o2 = is _whiteToBlackFocus fillBlackToWhite :: Boolean
-- false

o3 :: Boolean
o3 = is _whiteToBlackFocus fillRadial :: Boolean
-- false

-- Note that `only` requires `Fill` to implement `Eq`.
-- It's the only prism constructor that does.


-- `nearly` is typically used to look for a specific case (like other
-- prisms), but also accepts only values that are close to some target
-- value. It takes two values: a reference value, and a predicate that
-- determines whether the wrapped value(s) are close enough to the
-- reference. Note that the predicate takes the "whole" type (here,
-- `Fill`), not the unwrapped values inside the case you care about.

-- In this example, we want to focus on solid colors that are "bright
-- enough."

_brightSolidFocus :: Prism' Fill Unit
_brightSolidFocus = nearly (Solid referenceColor) predicate
  where
    referenceColor = Color.graytone 0.8
    predicate = case _ of
      Solid color ->
        Color.brightness color >= Color.brightness referenceColor
      _ ->
        false

-- Because a `nearly` prism focuses into `Unit`, you can get only two
-- values from `preview`:

n1 :: Maybe Unit
n1 = preview _brightSolidFocus (Solid Color.white)
-- (Just unit)

n2 :: Maybe Unit
n2 = preview _brightSolidFocus (Solid Color.black)
-- Nothing

n3 :: Maybe Unit
n3 = preview _brightSolidFocus NoFill
--  Nothing


-- ... so you probably want to use `is` or `isn't`:

n4 :: Boolean
n4 = is _brightSolidFocus (Solid Color.white) :: Boolean
-- true

-- You can recover the reference value with `review`:

n5 :: Fill
n5 = review _brightSolidFocus unit
-- (Solid rgba 204 204 204 1.0)



                {------ Eq and Show are always nice ------}

-- ... although Eq is only required for `only`.

derive instance genericPercent :: Generic Percent _
instance eqPercent :: Eq Percent where
  eq = GEq.genericEq
instance showPercent :: Show Percent where
  show (Percent f) = "(" <> show f <> "%)"

derive instance genericPoint :: Generic Point _
instance eqPoint :: Eq Point where
  eq = GEq.genericEq
instance showPoint :: Show Point where
  show (Point x y) = "(" <> show x <> ", " <> show y <> ")"

derive instance genericFill :: Generic Fill _
instance eqFill :: Eq Fill where
  eq = GEq.genericEq
instance showFill :: Show Fill where
  show x = GShow.genericShow x
