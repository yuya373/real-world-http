{-# LANGUAGE OverloadedStrings #-}
module Main where

import Network.Wai (responseBuilder, responseLBS, Application, requestBody, Request)
import Network.HTTP.Types (status200)
import Network.Wai.Handler.Warp (run, Port)
import System.Environment (getEnvironment)
import Data.Maybe
import Blaze.ByteString.Builder

main :: IO ()
main = do
  port <- getPort
  putStr "Server Started http://localhost:"
  print port
  run port helloApp

helloApp :: Application
helloApp req respond = do
  putStrLn $ show req
  respond $
    responseLBS status200
    [ ("Content-Type", "text/html;charset=utf-8")
    , ("X-Content-Type-Options", "nosniff")
    ]
    "<html><body>Hello Wai</body></html>"

buildResponse :: Request -> IO Builder
buildResponse req = do
  body <- requestBody req
  return $ fromByteString body

getPort :: IO Port
getPort = do
  env <- getEnvironment
  return $ fromMaybe defaultPort $ fmap read (lookup "PORT" env)

defaultPort :: Port
defaultPort = 18888
