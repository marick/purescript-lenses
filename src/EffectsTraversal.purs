module EffectsTraversal where

{- Paste the following into the repl

import Data.Maybe
import Data.Either
import Data.Lens
import Data.Lens as Lens
import Data.Tuple
import Data.List
import Data.String as String

import Data.Record.ShowRecord
import Control.Monad.Eff.Random
import Data.Traversable
-}

import Prelude
import Data.Lens
import Data.Lens as Lens
import Control.Monad.Eff.Random
import Data.Traversable

invertified = traverse (randomInt 0) [10, 20, 30] -- not the lens version
-- [6,7,11]

