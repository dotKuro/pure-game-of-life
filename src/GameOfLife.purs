module GameOfLife
  ( calculateNextGeneration
  , willLive
  ) where

import Prelude
import Data.Array (filter, length, (:))
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Grid (Grid, gridNeighbours, (!!))

calculateNextGeneration :: Grid Boolean -> Grid Boolean
calculateNextGeneration grid = traverseGrid 0
  where
  traverseGrid x
    | x >= length grid = []
    | otherwise = traverseColumn x 0 : traverseGrid (x + 1)

  traverseColumn x y = case grid !! Tuple x y of
    Just value -> willLive grid x y : traverseColumn x (y + 1)
    Nothing -> []

willLive :: Grid Boolean -> Int -> Int -> Boolean
willLive grid x y = case grid !! Tuple x y of
  Just false -> livingNeigbours == 3
  Just true -> livingNeigbours == 2 || livingNeigbours == 3
  Nothing -> false
  where
  livingNeigbours = length $ filter (\b -> b) $ gridNeighbours grid x y
