module Traversal where

{- Paste the following into the repl

import Traversal

import Data.Maybe
import Data.Either
import Data.Lens
import Data.Lens as Lens
import Data.Tuple
import Data.List
import Data.String as String
import Data.Map as Map
import Data.Lens.Index (ix)
import Data.Lens.At (at)

import Data.Record.ShowRecord
-}

import Prelude
import Data.Tuple (Tuple(..))
import Data.Maybe (Maybe(..))
import Data.Either
import Data.String as String

import Data.Lens
import Data.Lens as Lens
import Control.Monad.Eff.Random
import Data.List
import Data.Lens.Index
import Data.Traversable
import Data.Lens.At
import Data.Map
import Data.Map as Map


element1 :: Traversal' (Array String) String
element1 = element 1 traversed

ix1 :: Traversal' (Array String) String
ix1 = ix 1


--                    Composition
firsts :: forall focus ignore traversable. Traversable traversable =>
          Traversal' (traversable (Tuple focus ignore)) focus
firsts = traversed <<< _1


firsts' :: forall trav a b ignore. Traversable trav => 
           Traversal (trav (Tuple a ignore)) (trav (Tuple b ignore))
           a b
firsts' = traversed <<< _1



firstThenTraverse :: forall trav a b ignore.
                     Traversable trav =>
                     Traversal (Tuple (trav a) ignore) (Tuple (trav b) ignore)
                     a b 
firstThenTraverse = _1 <<< traversed



depth2 :: forall t1 t2 a b.
          Traversable t1 => Traversable t2 =>
          Traversal (t1 (t2 a)) (t1 (t2 b)) a b
depth2 = traversed <<< traversed



traverse2ix :: forall a. Traversal' (Array (Array a)) a
traverse2ix = traversed <<< ix 0

traverse2ix' :: forall t1 t2 a.
                Traversable t1 => 
                Index (t2 a) Int a => 
                Traversal' (t1 (t2 a)) a
traverse2ix' = traversed <<< ix 0

traverse2ix'' :: forall t1 t2 index a.
                 Traversable t1 => 
                 Index (t2 a) index a => 
                 index -> Traversal' (t1 (t2 a)) a
traverse2ix'' index = traversed <<< ix index

-- The following will not compile because a traversal containing an
-- `Index` can't change types.

{-
ixBogus :: forall t1 t2 index a b.
           Traversable t1 => 
           Index (t2 a) index a => 
           index -> Traversal (t1 (t2 a)) (t1 (t2 b)) a b
ixBogus index = traversed <<< ix index

-}


ix2traverse :: forall t1 t2 a.
               Index (t1 (t2 a)) Int (t2 a) =>
               Traversable t2 =>
               Traversal' (t1 (t2 a)) a
ix2traverse = ix 0 <<< traversed


traverse2at :: forall v trav at.
               Traversable trav =>
               At (at String v) String v =>
               Traversal' (trav (at String v)) (Maybe v)
traverse2at = traversed <<< at "key"


at2traverse = at "key" <<< traversed

at2_1 = Map.singleton "key" [1, 2, 3]

deeper :: Traversal' (Map String (Array String)) String
deeper = at2traverse <<< traversed

deeper' :: forall v trav at .
           Traversable trav =>
           At (at String (trav v)) String (trav v) =>
           Traversal' (at String (trav v)) v
deeper' = at "key" <<< _Just <<< traversed
