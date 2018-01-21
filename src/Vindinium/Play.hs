{-# LANGUAGE LambdaCase #-}
module Vindinium.Play
        ( playTraining
        , playArena
        )
    where

import Vindinium.Types
import Vindinium.Api
import Control.Monad.IO.Class (liftIO)
import Data.List.Split (chunksOf)

playTraining :: Maybe Int -> Maybe Board -> Bot -> Vindinium State
playTraining mt mb b = startTraining mt mb >>= playLoop b

playArena :: Bot -> Vindinium State
playArena b = startArena >>= playLoop b

playLoop :: Bot -> State -> Vindinium State
playLoop bot state = do
  liftIO $ putStrLn . drawBoard . gameBoard $ stateGame state

  if (gameFinished . stateGame) state
      then return state
      else do
          newState <- bot state >>= move state
          playLoop bot newState

drawBoard :: Board -> String
drawBoard (Board s ts)
  = unlines $ chunksOf s $ map f ts
  where f = \case
          FreeTile    -> '.'
          WoodTile    -> '#'
          TavernTile  -> 't'
          MineTile _  -> 'm'
          HeroTile (HeroId i) -> head $ show i
