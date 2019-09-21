module Draw
  ( DrawState
  , calculateNextState
  , drawAction
  , getInitialDrawState
  , setupAction
  ) where

import Prelude
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Random (randomBool)
import GameOfLife (calculateNextGeneration)
import Grid ((!!), Grid, getGridFromEffect)
import P5.Color (background3)
import P5.Environment (frameRate2)
import P5.Rendering (createCanvas)
import P5.Shape (rect)
import P5.StateDrawer (Action, StateTransformer)

type DrawState
  = { gridWidth :: Int
    , gridHeight :: Int
    , cellWidth :: Int
    , cellHeight :: Int
    , frameRate :: Number
    , grid :: Grid Boolean
    }

getInitialDrawState :: Int -> Int -> Int -> Int -> Number -> Effect DrawState
getInitialDrawState gridWidth gridHeight cellWidth cellHeight frameRate = do
  grid <- getGridFromEffect gridWidth gridHeight randomBool
  pure
    { gridWidth
    , gridHeight
    , cellWidth
    , cellHeight
    , frameRate
    , grid
    }

setupAction :: Action DrawState
setupAction p5 { gridWidth, gridHeight, cellWidth, cellHeight, frameRate } = do
  let
    canvasWidth = toNumber $ gridWidth * cellWidth
  let
    canvasHeight = toNumber $ gridHeight * cellHeight
  _ <- createCanvas p5 canvasWidth canvasHeight Nothing
  frameRate2 p5 frameRate

drawAction :: Action DrawState
drawAction p5 drawState = do
  background3 p5 "#000000" Nothing
  drawGrid p5 drawState

drawGrid :: Action DrawState
drawGrid p5 { gridHeight, cellWidth, cellHeight, grid } = traverseGrid 0 0
  where
  traverseGrid x y
    | y >= gridHeight = pure unit
    | otherwise = case grid !! Tuple x y of
      Just value -> do
        unless value $ rect p5 (toNumber $ x * cellWidth) (toNumber $ y * cellHeight) (toNumber cellWidth) (toNumber cellHeight) Nothing Nothing
        traverseGrid (x + 1) y
      Nothing -> traverseGrid 0 (y + 1)

calculateNextState :: StateTransformer DrawState
calculateNextState state@{ grid } = state { grid = calculateNextGeneration grid }
