module GridTest where

import Prelude
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Grid (gridMap, replicate, (!!))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal)

gridSuite :: TestSuite
gridSuite =
  suite "Grid" do
    test "index" do
      equal (grid3by3 !! Tuple 0 0) (Just 1)
      equal (grid3by3 !! Tuple 1 2) (Just 6)
      equal (grid3by3 !! Tuple 3 3) (Nothing)
      equal (grid3by3 !! Tuple 3 0) (Nothing)
      equal (grid3by3 !! Tuple 0 3) (Nothing)
    test "replicate" do
      equal (replicate 2 2 false) ([ [ false, false ], [ false, false ] ])
      equal (replicate 1 2 false) ([ [ false, false ] ])
      equal (replicate 2 1 false) ([ [ false ], [ false ] ])
      equal (replicate 0 2 false) ([])
      equal (replicate 2 0 false) ([ [], [] ])
    test "gridMap" do
      equal (gridMap not [ [ false ] ]) ([ [ true ] ])
      equal (gridMap not $ replicate 20 20 false) (replicate 20 20 true)
      equal (gridMap (_ + 1) $ replicate 200 200 0) (replicate 200 200 1)
      equal (gridMap (_ + 1) [ [] ]) ([ [] ])
  where
  grid3by3 =
    [ [ 1, 2, 3 ]
    , [ 4, 5, 6 ]
    , [ 7, 8, 9 ]
    ]
