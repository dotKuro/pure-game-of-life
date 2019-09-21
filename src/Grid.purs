module Grid
  ( Grid
  , getGridFromEffect
  , gridMap
  , gridNeighbours
  , index
  , (!!)
  , replicate
  ) where

import Prelude
import Data.Array (concat, singleton)
import Data.Array as Arr
import Data.List.Lazy (replicateM)
import Data.Maybe (Maybe(..), isJust, maybe)
import Data.Tuple (Tuple(..))
import Effect (Effect)

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

getGridFromEffect :: forall a. Int -> Int -> Effect a -> Effect (Grid a)
getGridFromEffect width height effValue = do
  gridFromEffect <- replicateM width getColumnFromEffect
  pure $ Arr.fromFoldable gridFromEffect
  where
  getColumnFromEffect = do
    columnFromEffect <- replicateM height effValue
    pure $ Arr.fromFoldable columnFromEffect

gridNeighbours :: forall a. Grid a -> Int -> Int -> Array a
gridNeighbours grid x y =
  concat
    $ map (maybe [] singleton)
        [ grid !! Tuple (x - 1) (y + 1)
        , grid !! Tuple (x) (y + 1)
        , grid !! Tuple (x + 1) (y + 1)
        , grid !! Tuple (x - 1) (y)
        , grid !! Tuple (x + 1) (y)
        , grid !! Tuple (x - 1) (y - 1)
        , grid !! Tuple (x) (y - 1)
        , grid !! Tuple (x + 1) (y - 1)
        ]
