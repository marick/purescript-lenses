module Product where

import Data.Tuple (Tuple, fst, snd)
import Data.Lens (lens', view, set, over)



first =
  lens' fst setter
  where
    setter (Tuple a b) newA = Tuple newA b
