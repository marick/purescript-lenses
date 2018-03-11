module ProductSolutions where

{- Paste the following into the repl

import Data.Tuple.Nested 
import Data.Lens (lens, view, set, over)
import Data.Lens as Lens
 
-}

import Data.Tuple (Tuple(..))
import Data.Tuple.Nested (T2, T3, T4, get1, get2, get3)
import Data.Lens (lens)
import Data.Lens.Types (Lens)


{-                          Exercise 1                           -}

{-

object = lens _.object (_ { object = _ })

Then, take your pick of single-line solutions that are not so easy to
parse:

  set Lens.second (view (Lens.second <<< object) both) both
  view (Lens.second <<< object) both # flip (set Lens.second) both
  flip (set Lens.second) both $ view (Lens.second <<< object) both

Or, if you want to be one of those *kids these days* with your
"readability" and your "intention-revealing names" and all that:

  let
    new = Lens.view (Lens.second <<< object) both
  in 
    Lens.set Lens.second new both

-}









{-                          Exercise 2                           -}

    
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

------

lens1 :: forall focus new rest.
         Lens (T2 focus rest) (T2 new rest) focus new
lens1 = lens get1 set1


lens2 :: forall p1 focus new rest.
         Lens (T3 p1 focus rest) (T3 p1 new rest) focus new
lens2 = lens get2 set2

lens3 :: forall p1 p2 focus new rest.
         Lens (T4 p1 p2 focus rest) (T4 p1 p2 new rest) focus new
lens3 = lens get3 set3
