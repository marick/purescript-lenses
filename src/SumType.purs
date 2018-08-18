module SumType where

{-   If you want to try out examples, paste the following into the repl.

import SumType
import Data.Lens
import Data.Lens.Prism
import Color as Color
import Data.Maybe
import Data.Either
import Data.Tuple
import Data.Lens.At
import Data.Lens.Index
-}

import Prelude
import Data.Lens (Prism', Traversal, Traversal', _1, _Left, _Right, _Just, is,
                  isn't, nearly, only, preview, prism, prism', review, traversed)
import Data.Lens.At (class At, at)
import Data.Lens.Index (class Index, ix)

import Color (Color)
import Color as Color

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq as GEq
import Data.Generic.Rep.Show as GShow
import Data.Maybe (Maybe(..), maybe)
import Data.Either (Either(..))
import Data.Tuple (Tuple)
import Data.Traversable (class Traversable)


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

_solidFill :: Prism' Fill Color
_solidFill = prism' constructor focuser
  where
    constructor = Solid
    focuser fill = case fill of
      Solid color -> Just color
      otherCases -> Nothing

-- In real life, you might abbreviate the above to this:

_solidFill' :: Prism' Fill Color
_solidFill' = prism' Solid case _ of
  Solid color -> Just color
  _ -> Nothing



                {------ Basic usage: `preview`, `review`, `is`, and `isn't` ------}

-- After building a prism, you focus in on a color with `preview`:

s1 :: Maybe Color
s1 = preview _solidFill (Solid Color.white)
-- (Just rgba 255 255 255 1.0)

s2 :: Maybe Color
s2 = preview _solidFill fillRadial
-- Nothing

-- ... or you can create a Fill from a color with `review`:

s3 :: Fill
s3 = review _solidFill Color.white
-- (Solid rgba 255 255 255 1.0)

-- ... or you can ask whether a given value matches the prism:

s4 :: Boolean
s4 = is _solidFill (Solid Color.white) :: Boolean
-- true

s5 :: Boolean
s5 = isn't _solidFill (Solid Color.white) :: Boolean
-- false


                {------ Making prisms with Either and `prism` ------}

_anotherSolidFill :: Prism' Fill Color
_anotherSolidFill = prism Solid case _ of
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


n5 :: Fill
n5 = review _solidWhite' unit
-- (Solid rgba 204 204 204 1.0)



  
                {------ Multiple wrapped values ------}


-- This would violate the lens laws:

_centerPoint :: Prism' Fill Point
_centerPoint = prism' constructor focuser
  where
    focuser = case _ of
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

_centerPoint' :: Prism' Fill RadialInterchange
_centerPoint' = prism constructor focuser
  where
    focuser = case _ of
      RadialGradient color1 color2 center ->
        Right {color1, color2, center}
      otherCases ->
        Left otherCases
        
    constructor {color1, color2, center} =
      RadialGradient color1 color2 center
        

-- Even though made differently than `_solidFill`, `_centerPoint'` is
-- used the same way:

l1 :: String
l1 = preview _centerPoint' fillRadial # maybe "!" show
-- "{ color1: rgba 0 0 0 1.0, color2: rgba 255 255 255 1.0, percent: (3.3%) }"

l2 :: Fill
l2 = review _centerPoint' { color1 : Color.black
                          , color2 : Color.white
                          , center : Point 1.3 2.4
                          }



                     {------ Composition ------}

_right_solidFill :: forall ignore. 
                    Prism' (Either ignore Fill) Color
_right_solidFill = _Right <<< _solidFill

_traversed_solidFill :: forall trav .
                        Traversable trav =>
                        Traversal' (trav Fill) Color 
_traversed_solidFill = traversed <<< _solidFill


_right_traversed :: forall trav a b _1_ .
                    Traversable trav => 
                    Traversal (Either _1_ (trav a))
                              (Either _1_ (trav b))
                              a b
_right_traversed = _Right <<< traversed


_1_solidFill :: forall _1_ .
                Traversal' (Tuple Fill _1_) Color
_1_solidFill = _1 <<< _solidFill


_left_1 ::forall a b _1_ _2_.
           Traversal (Either (Tuple a _1_) _2_)
                     (Either (Tuple b _1_) _2_)
                     a b 
_left_1 = _Left <<< _1


_left_ix1 :: forall _1_ indexed a.
             Index indexed Int a => 
             Traversal' (Either indexed _1_) a 
_left_ix1 = _Left <<< ix 1


_ix1_left :: forall _1_ indexed a.
             Index indexed Int (Either a _1_) =>
             Traversal' indexed a
_ix1_left = ix 1 <<< _Left

_at1_just :: forall keyed a .
             At keyed Int a =>
             Traversal' keyed a
_at1_just = at 1 <<< _Just


      {---- Not used in chapter, but an interesting use of records. ----}

_hslaSolid :: Prism' Fill { h :: Number, s :: Number, l :: Number, a :: Number }
_hslaSolid = prism' constructor focuser
  where
    focuser = case _ of
      Solid color -> Just $ Color.toHSLA color
      _ -> Nothing

    constructor {h,s,l,a} = 
      Solid $ Color.hsla h s l a 


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


