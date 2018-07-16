module TraversalStart where

{-

import Prelude
import Data.Tuple (Tuple)
import Data.Maybe (Maybe)
import Data.Lens (Traversal', Traversal, _1, traversed)
import Data.Traversable (class Traversable)
import Data.Lens.At (class At, at)
import Data.Map (Map)


_trav_trav :: 
_trav_trav = traversed <<< traversed


_1_trav :: 
_1_trav = _1 <<< traversed

_trav_at3 :: 
_trav_at3 = traversed <<< at 3

-- Convert the following so that it makes no explicit reference to `Map`

_at3_trav_1' :: forall a _1_ . 
               Traversal' (Map Int (Tuple a _1_)) a
_at3_trav_1' = at 3 <<< traversed <<< _1

-}

