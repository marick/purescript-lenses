module Traversal where

{- Paste the following into the repl

import Traversal

import Data.Maybe
import Data.Lens
import Data.Lens as Lens
import Data.Tuple
import Data.List
import Data.String as String
import Data.Map as Map
import Data.Lens.Index (ix)
import Data.Lens.At (at)

import Data.Record.ShowRecord (showRecord)
-}

import Prelude
import Data.Tuple (Tuple)
import Data.Maybe (Maybe)

import Data.Lens ( _1 -- old
                 , Traversal, Traversal', _Just, element, traversed -- new
                 )
import Data.Lens.Index (class Index, ix)
import Data.Traversable (class Traversable)
import Data.Lens.At (class At, at)
import Data.Map (Map)
import Data.Map as Map

element1 :: Traversal' (Array String) String
element1 = element 1 traversed

_ix1 :: Traversal' (Array String) String
_ix1 = ix 1


--                    Composition
_firsts :: forall focus ignore traversable. Traversable traversable =>
           Traversal' (traversable (Tuple focus ignore)) focus
_firsts = traversed <<< _1


_firsts' :: forall trav a b ignore. Traversable trav => 
            Traversal (trav (Tuple a ignore)) (trav (Tuple b ignore))
            a b
_firsts' = traversed <<< _1



_firstThenTraverse :: forall trav a b ignore.
                      Traversable trav =>
                      Traversal (Tuple (trav a) ignore) (Tuple (trav b) ignore)
                      a b 
_firstThenTraverse = _1 <<< traversed



_depth2 :: forall t1 t2 a b.
           Traversable t1 => Traversable t2 =>
           Traversal (t1 (t2 a)) (t1 (t2 b)) a b
_depth2 = traversed <<< traversed



_traverse2ix :: forall a. Traversal' (Array (Array a)) a
_traverse2ix = traversed <<< ix 0

_traverse2ix' :: forall t1 t2 a.
                 Traversable t1 => 
                 Index (t2 a) Int a => 
                 Traversal' (t1 (t2 a)) a
_traverse2ix' = traversed <<< ix 0

_traverse2ix'' :: forall t1 t2 index a.
                  Traversable t1 => 
                  Index (t2 a) index a => 
                  index -> Traversal' (t1 (t2 a)) a
_traverse2ix'' index = traversed <<< ix index

-- The following will not compile because a traversal containing an
-- `Index` can't change types.

{-
_ixBogus :: forall t1 t2 index a b.
            Traversable t1 => 
            Index (t2 a) index a => 
            index -> Traversal (t1 (t2 a)) (t1 (t2 b)) a b
_ixBogus index = traversed <<< ix index

-}


_ix2traverse :: forall t1 t2 a.
                Index (t1 (t2 a)) Int (t2 a) =>
                Traversable t2 =>
                Traversal' (t1 (t2 a)) a
_ix2traverse = ix 0 <<< traversed


_traverse2at :: forall v trav at.
                Traversable trav =>
                At (at String v) String v =>
                Traversal' (trav (at String v)) (Maybe v)
_traverse2at = traversed <<< at "key"



_at2traverse :: Traversal' (Map String (Array String)) (Array String)
_at2traverse = at "key" <<< traversed

at2_1 :: Map String (Array Int)
at2_1 = Map.singleton "key" [1, 2, 3]

_deeper :: Traversal' (Map String (Array String)) String
_deeper = _at2traverse <<< traversed

_deeper' :: forall v trav at .
            Traversable trav =>
            At (at String (trav v)) String (trav v) =>
            Traversal' (at String (trav v)) v
_deeper' = at "key" <<< _Just <<< traversed
