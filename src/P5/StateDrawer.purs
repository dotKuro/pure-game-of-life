module P5.StateDrawer
  ( Action
  , StateTransformer
  , stateDrawer
  ) where

import Prelude
import Effect (Effect)
import P5 (P5, draw)

type Action a
  = P5 -> a -> Effect Unit

type StateTransformer a
  = a -> a

stateDrawer :: forall a. P5 -> a -> Action a -> StateTransformer a -> Effect Unit
stateDrawer p5 state action stateTransformer = do
  action p5 state
  draw p5 $ stateDrawer p5 (stateTransformer state) action stateTransformer
