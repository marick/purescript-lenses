module Compositions where

{- The various compositions used in the catalog of compositions.
   Here if they're not explained in the text (so in a chapter's source files).
-}
import Prelude
import Data.Tuple (Tuple)
import Data.Maybe (Maybe)
import Data.Lens (Lens', Traversal', _1, traversed)
import Data.Lens.At (class At, at)

_1_1 :: forall a _1_ _2_ . Lens' (Tuple (Tuple a _1_) _2_) a
_1_1 = _1 <<< _1

_1_at :: forall keyed _2_ a .
         At keyed Int a =>
         Lens' (Tuple keyed _2_) (Maybe a)
_1_at = _1 <<< at 1


_at_trav :: forall keyed a .
            At keyed Int a =>
            Traversal' keyed a
_at_trav = at 1 <<< traversed


_at_Just :: forall keyed a .
            At keyed Int a =>
            Traversal' keyed a
_at_Just = at 1 <<< traversed

