module ProductSolutions where

{- To help with the second exercise, paste the following into the repl:

import Data.Tuple.Nested 
import Data.Lens
import Data.Lens as Lens
 
-}

import Product (both, Event)

import Prelude
import Data.Tuple (Tuple(..), fst, snd)
import Data.Tuple.Nested (T2, T3, T4, get1, get2, get3)
import Data.Lens (lens, set, view, over, _2, Lens, Lens')
import Data.Record.ShowRecord (showRecord)


        {- Composition Exercise -}

-- 1:

_object :: Lens' Event String
_object = lens _.object (_ { object = _ })

-- 2: showRecord

showed :: Tuple String String
showed = over _2 showRecord both

-- 3: Take your pick of these single-line solutions

solution1 :: Tuple String String
solution1 = 
  set _2 (view (_2 <<< _object) both) both

solution2 :: Tuple String String
solution2 =   
  view (_2 <<< _object) both # flip (set _2) both

solution3 :: Tuple String String
solution3 =   
  flip (set _2) both $ view (_2 <<< _object) both

-- Or, if you want to be one of those *kids these days* with your
-- "readability" and your "intention-revealing names" and all that:

solution4 :: Tuple String String
solution4 = 
  let
    new = view (_2 <<< _object) both
  in 
    set _2 new both



        {- Composition Exercise 2 -}


-- Part 1:

set1 :: forall focus rest new.
        T2 focus rest -> new -> T2 new rest
set1 (Tuple _ rest) new =
  Tuple new rest

set2 :: forall p1 focus rest new.
        T3 p1 focus rest -> new -> T3 p1 new rest
set2 (Tuple head rest) new =
  Tuple head (set1 rest new)

set3 :: forall p1 p2 focus rest new.
        T4 p1 p2 focus rest -> new -> T4 p1 p2 new rest
set3 (Tuple head rest) new =
  Tuple head (set2 rest new)

-- Part 2

_elt1 :: forall focus new rest.
          Lens (T2 focus rest) (T2 new rest) focus new
_elt1 = lens get1 set1


_elt2 :: forall p1 focus new rest.
          Lens (T3 p1 focus rest) (T3 p1 new rest) focus new
_elt2 = lens get2 set2

_elt3 :: forall p1 p2 focus new rest.
          Lens (T4 p1 p2 focus rest) (T4 p1 p2 new rest) focus new
_elt3 = lens get3 set3




        {-  Law exercise -}

-- An easy way to violate set-get is to use a different focus for the
-- setter and getter.

_setGetOops :: forall a. Lens' (Tuple a a) a
_setGetOops =
  lens getter setter
  where
    setter (Tuple _ kept) new = Tuple new kept
    getter = snd -- should be `fst`

-- > Tuple 1 2 # set _setGetOops 3333 # view _setGetOops
-- 2



-- The following satisfies set-get but not get-set:

_getSetOops :: forall a. Lens' (Tuple a a) a
_getSetOops =
  lens getter setter
  where
    getter = fst
    setter (Tuple _ _) new = Tuple new new

-- > view _getSetOops (Tuple 1 2)
-- 1

-- > set _getSetOops 1 (Tuple 1 2)
-- (Tuple 1 1)
    



-- The solution for `set-get` also violates `set-set`:

-- > set _setGetOops 333 t == set _setGetOops 3333 (set _setGetOops 3333 t)
-- false
