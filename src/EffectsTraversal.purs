module EffectsTraversal where

{- Paste the following into the repl

import Data.Maybe
import Data.Either
import Data.Lens
import Data.Lens as Lens
import Data.Tuple
import Data.List
import Data.String as String

import Control.Monad.Eff.Random
import Data.Traversable
-}

import Prelude
import Data.Lens
import Data.Lens as Lens
import Effect.Random
import Data.Traversable
import Data.Maybe

invertified = traverse (randomInt 0) [10, 20, 30] -- not the lens version
-- [6,7,11]


{- 
sequenceOf traversed $ map (randomInt 3) [10, 20, 30]


> (traverseOf traversed pure [10, 20, 30]) :: Maybe (Array Int)
(Just [10,20,30])

> pure [10, 20, 30] :: Maybe (Array Int)
(Just [10,20,30])


traverseOf traversed pure ≡ pure

-}

-- t :: (Int -> Maybe Int) -> Array Int -> Maybe (Array Int)
t = traverseOf traversed

t1 :: forall f. Applicative f => f Int -> Maybe (f Int)
t1 = Just

t2 :: Int -> Maybe Int
t2 = Just <<< ((-) 3)

