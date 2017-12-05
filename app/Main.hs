module Main where

import System.Environment (lookupEnv)
import Network.Wai.Handler.Warp (run)

import Api (app)

main :: IO ()
main = do
  port <- maybe 8080 read <$> lookupEnv "PORT"
  run port app
