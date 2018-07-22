module Index where

{- Paste the following into the repl

import Index

import Data.Maybe
import Data.Lens
import Data.Map as Map
import Data.Lens.At (at)
import Data.Lens.Index (ix)
import Data.String as String

-}

import Prelude
import Data.Maybe (Maybe)
import Data.Lens (Lens', Traversal', _1, traversed)
import Data.Lens.At (class At, at)
import Data.Lens.Index (class Index, ix)
import Data.Traversable (class Traversable)
import Data.Tuple (Tuple)


_at1 :: forall s a . At s Int a =>
       Lens' s (Maybe a)
_at1 = at 1

_ix1 :: forall s a . Index s Int a =>
        Traversal' s a
_ix1 = ix 1

                                 {- Composition -}

_trav_ix1 :: forall trav indexed a.
             Traversable trav => Index indexed Int a =>
               Traversal' (trav indexed) a

_trav_ix1 = traversed <<< ix1


_ix1_trav :: forall indexed trav a.
             Index indexed Int (trav a) => Traversable trav =>
               Traversal' indexed a
_ix1_trav = ix 1 <<< traversed


_at1_ix1 :: forall keyed indexed a.
            At keyed Int indexed => Index indexed Int a =>
            Traversal' keyed a 
_at1_ix1 = at 1 <<< traversed <<< ix 1


{- Composition exercise -}

_1_ix1 :: forall indexed a _1_ .
          Index indexed Int a => 
            Traversal' (Tuple indexed _1_) a
_1_ix1 = _1 <<< ix 1


_ix1_1 :: forall indexed a _1_ .
          Index indexed Int (Tuple a _1_) =>
            Traversal' indexed a
_ix1_1 = ix 1 <<< _1


_ix1_at1 :: forall indexed keyed a.
            Index indexed Int keyed => At keyed Int a => 
            Traversal' indexed (Maybe a)
_ix1_at1 = ix 1 <<< at 1
