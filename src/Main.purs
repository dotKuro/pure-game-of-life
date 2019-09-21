module Main where

import Prelude
import Control.Monad.State (StateT, execStateT, get, lift, put)
import Data.Array (fromFoldable, replicate, (!!), (:), (..))
import Data.Int (toNumber)
import Data.List.Lazy (replicateM)
import Data.Maybe (Maybe(..), maybe)
import Data.Traversable (sequence, sum)
import Effect (Effect)
import Effect.Random (randomBool)
import P5 (P5, draw, getP5, setup)
import P5.Color (background3)
import P5.Environment (frameRate2)
import P5.Rendering (createCanvas)
import P5.Shape (rect)

type Grid
  = Array (Array Boolean)

type AppState
  = { p5 :: P5
    }

initialState :: Maybe AppState
initialState = Nothing

type DrawState
  = { gridWidth :: Int
    , gridHeight :: Int
    , cellWidth :: Int
    , cellHeight :: Int
    , grid :: Grid
    }

getInitialDrawState :: Effect DrawState
getInitialDrawState = do
  grid <- initGridRandomly gridWidth gridHeight
  pure
    { gridWidth
    , gridHeight
    , cellWidth: 10
    , cellHeight: 10
    , grid
    }
  where
  gridWidth = 60

  gridHeight = 40

initGridEmpty :: Int -> Int -> Grid
initGridEmpty width height = replicate width (replicate height false)

initGridRandomly :: Int -> Int -> Effect Grid
initGridRandomly width height = do
  randomGrid <- replicateM width generateRandomColumn
  pure $ fromFoldable randomGrid
  where
  generateRandomColumn = do
    randomColumn <- replicateM height randomBool
    pure $ fromFoldable randomColumn

statefulDraw :: P5 -> DrawState -> Effect Unit
statefulDraw p5 state = do
  newState <- execStateT (stateDrawAction p5) state
  draw p5 (statefulDraw p5 newState)

stateDrawAction :: P5 -> StateT DrawState Effect Unit
stateDrawAction p5 = do
  state <- get
  put $ state { grid = calculateNextGeneration state.grid }
  lift $ background3 p5 "#000000" Nothing
  lift $ drawGrid p5 state

drawGrid :: P5 -> DrawState -> Effect Unit
drawGrid p5 state@{ grid, cellWidth, cellHeight } = drawGrid' 0 0
  where
  drawGrid' x y = case grid !! x of
    Just column -> do
      drawColumn' x y column
      drawGrid' (x + 1) y
    Nothing -> pure unit

  drawColumn' x y column = case column !! y of
    Just cell -> do
      unless cell $ rect p5 (toNumber $ x * cellWidth) (toNumber $ y * cellHeight) (toNumber cellWidth) (toNumber cellHeight) Nothing Nothing
      drawColumn' x (y + 1) column
    Nothing -> pure unit

calculateNextGeneration :: Grid -> Grid
calculateNextGeneration grid = calculateNextGeneration' 0 0
  where
  calculateNextGeneration' x y = case grid !! x of
    Just column -> calcColumn x y column : calculateNextGeneration' (x + 1) y
    Nothing -> []

  calcColumn x y column = case column !! y of
    Just cell -> willLive grid cell x y : calcColumn x (y + 1) column
    Nothing -> []

willLive :: Grid -> Boolean -> Int -> Int -> Boolean
willLive grid cell x y =
  if cell then
    3 == nsum || 4 == nsum
  else
    3 == nsum
  where
  neighbourHelper l = case l of
    [ a, b ] -> case grid !! (x + a) of
      Just column -> case column !! (y + b) of
        Just v -> boolToInt v
        Nothing -> 0
      Nothing -> 0
    _ -> 0

  nsum = (sum $ map neighbourHelper $ sequence [ (-1) .. 1, (-1 .. 1) ])

  boolToInt true = 1

  boolToInt false = 0

setupAction :: P5 -> DrawState -> Effect Unit
setupAction p5 drawState = do
  _ <- createCanvas p5 canvasWidth canvasHeight Nothing
  frameRate2 p5 2.0
  where
  canvasWidth = toNumber $ drawState.gridWidth * drawState.cellWidth

  canvasHeight = toNumber $ drawState.gridHeight * drawState.cellHeight

main :: Maybe AppState -> Effect AppState
main maybeAppState = do
  p5 <- maybe getP5 (\appState -> pure appState.p5) maybeAppState
  initialDrawState <- getInitialDrawState
  setup p5 $ setupAction p5 initialDrawState
  draw p5 $ statefulDraw p5 initialDrawState
  pure { p5 }
