module SumType where

{-   If you want to try out examples, paste the following into the repl.

import SumType
import Data.Lens
import Data.Lens.Prism
import Color as Color
import Data.Maybe
import Data.Either
import Data.Tuple
import Data.Record.ShowRecord (showRecord)
-}

import Prelude
import Data.Lens

import Color (Color)
import Color as Color

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq as GEq
import Data.Generic.Rep.Show as GShow
import Data.Record.ShowRecord (showRecord)
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

solidFocus :: Prism' Fill Color
solidFocus = prism' constructor focus
  where
    constructor = Solid
    focus fill = case fill of
      Solid color -> Just color
      otherCases -> Nothing

-- In real life, you might abbreviate the above to this:

solidFocus' :: Prism' Fill Color
solidFocus' = prism' Solid case _ of
  Solid color -> Just color
  _ -> Nothing


                {------ Basic usage: `preview`, `review`, `is`, and `isn't` ------}

-- After building a prism, you focus in on a color with `preview`:

s1 :: Maybe Color
s1 = preview solidFocus (Solid Color.white)
-- (Just rgba 255 255 255 1.0)

s2 :: Maybe Color
s2 = preview solidFocus fillRadial
-- Nothing

-- ... or you can create a Fill from a color with `review`:

s3 :: Fill
s3 = review solidFocus Color.white
-- (Solid rgba 255 255 255 1.0)

-- ... or you can ask whether a given value matches the prism:

s4 :: Boolean
s4 = is solidFocus (Solid Color.white) :: Boolean
-- true

s5 :: Boolean
s5 = isn't solidFocus (Solid Color.white) :: Boolean
-- false


                {------ Making prisms with Either and `prism` ------}

anotherSolidFocus :: Prism' Fill Color
anotherSolidFocus = prism Solid case _ of
  Solid color -> Right color
  otherCases -> Left otherCases


                {------ Making prisms with Eq and `only` ------}

onlySolidWhite :: Prism' Fill Unit
onlySolidWhite = only (Solid Color.white)


                {------ Multiple wrapped values ------}


-- This would violate the lens laws:

radialPointFocus :: Prism' Fill Point
radialPointFocus = prism' constructor focus
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

radialFocus :: Prism' Fill RadialInterchange
radialFocus = prism constructor focus
  where
    focus = case _ of
      RadialGradient color1 color2 center ->
        Right {color1, color2, center}
      otherCases ->
        Left otherCases
        
    constructor {color1, color2, center} =
      RadialGradient color1 color2 center
        



-- Even though made differently than `solidFocus`, `radialFocus` is
-- used the same way:

l1 :: String
l1 = preview radialFocus fillRadial # maybe "!" showRecord
-- "{ color1: rgba 0 0 0 1.0, color2: rgba 255 255 255 1.0, percent: (3.3%) }"

l2 :: Fill
l2 = review radialFocus { color1 : Color.black
                        , color2 : Color.white
                        , center : Point 1.3 2.4
                        }


hslaFocus = prism' constructor focus
  where
    focus = case _ of
      Solid color -> Just $ Color.toHSLA color
      _ -> Nothing

    constructor {h,s,l,a} = 
      Solid $ Color.hsla h s l a 





deepSolidFocus :: forall ignore. 
                  Prism' (Either ignore Fill) Color
deepSolidFocus = _Right <<< solidFocus

-- tupleSolidFocus :: forall ignore.
--                    APrism' (Tuple Fill ignore) Color
tupleSolidFocus = _1 <<< solidFocus

eitherTupleFocus = _Left <<< _1


                {------ Constructing more specific prisms ------}

-- `only` is used to check for a specific value:

whiteToBlackFocus :: Prism' Fill Unit
whiteToBlackFocus = only fillWhiteToBlack

o1 :: Boolean
o1 = is whiteToBlackFocus fillWhiteToBlack :: Boolean
-- true

o2 :: Boolean
o2 = is whiteToBlackFocus fillBlackToWhite :: Boolean
-- false

o3 :: Boolean
o3 = is whiteToBlackFocus fillRadial :: Boolean
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

brightSolidFocus :: Prism' Fill Unit
brightSolidFocus = nearly (Solid referenceColor) predicate
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
n1 = preview brightSolidFocus (Solid Color.white)
-- (Just unit)

n2 :: Maybe Unit
n2 = preview brightSolidFocus (Solid Color.black)
-- Nothing

n3 :: Maybe Unit
n3 = preview brightSolidFocus NoFill
--  Nothing


-- ... so you probably want to use `is` or `isn't`:

n4 :: Boolean
n4 = is brightSolidFocus (Solid Color.white) :: Boolean
-- true

-- You can recover the reference value with `review`:

n5 :: Fill
n5 = review brightSolidFocus unit
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
