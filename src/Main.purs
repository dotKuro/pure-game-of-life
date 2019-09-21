module Main (main) where

import Prelude
import Default as Def
import Draw (calculateNextState, drawAction, getInitialDrawState, setupAction)
import Effect (Effect)
import P5 (draw, getP5, setup)
import P5.StateDrawer (stateDrawer)

main :: Effect Unit
main = do
  p5 <- getP5
  initialDrawState <- getInitialDrawState Def.gridWidth Def.gridHeight Def.cellWidth Def.cellHeight Def.frameRate
  setup p5 $ setupAction p5 initialDrawState
  draw p5 $ stateDrawer p5 initialDrawState drawAction calculateNextState
