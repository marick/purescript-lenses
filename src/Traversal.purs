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


ixTraversable :: forall a. Traversal' (Array (Array a)) a
ixTraversable = traversed <<< ix 0

ixTraversable' :: forall t1 t2 a.
                  Traversable t1 => 
                  Index (t2 a) Int a => 
                  Traversal' (t1 (t2 a)) a
ixTraversable' = traversed <<< ix 0

ixTraversable'' :: forall t1 t2 index a.
                   Traversable t1 => 
                   Index (t2 a) index a => 
                   index -> Traversal' (t1 (t2 a)) a
ixTraversable'' index = traversed <<< ix index

-- The following will not compile because a traversal containing an
-- `Index` can't change types.

{-
ixBogus :: forall t1 t2 index a b.
           Traversable t1 => 
           Index (t2 a) index a => 
           index -> Traversal (t1 (t2 a)) (t1 (t2 b)) a b
ixBogus index = traversed <<< ix index

-}
