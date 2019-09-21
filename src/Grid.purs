module Grid
  ( gridMap
  , index
  , (!!)
  , replicate
  ) where

import Prelude
import Data.Array as Arr
import Data.Maybe (Maybe)
import Data.Tuple (Tuple(..))

type Grid a
  = Array (Array a)

index :: forall a. Grid a -> Tuple Int Int -> Maybe a
index grid (Tuple x y) = do
  column <- Arr.index grid x
  value <- Arr.index column y
  pure value

infixl 8 index as !!

replicate :: forall a. Int -> Int -> a -> Grid a
replicate width height value = Arr.replicate width $ Arr.replicate height value

gridMap :: forall a b. (a -> b) -> Grid a -> Grid b
gridMap func grid = map (map func) grid
