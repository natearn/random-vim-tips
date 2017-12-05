{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module Api where

import GHC.Generics     (Generic)
import Data.Aeson.Types (ToJSON,FromJSON)
import Network.Wai      (Application)

import Servant

data VimTip = VimTip
  { title         :: String
  , articleURL    :: String
  } deriving (Eq, Show, Generic)

instance ToJSON VimTip
instance FromJSON VimTip

type RandomAPI =    "random" :> Get '[JSON] VimTip
               :<|> "random" :> Capture "size" Int :> Get '[JSON] [VimTip]

server :: Server RandomAPI
server = oneTip :<|> manyTips

oneTip :: Handler VimTip
oneTip = return $ head tips

manyTips :: Int -> Handler [VimTip]
manyTips n = return $ take n tips

tips :: [VimTip]
tips = [ VimTip "Look at my website!" "http://natearn.info"
       , VimTip "Here are some tricks!" "https://vimtricks.com"
       ]

app :: Application
app = serve api server

api :: Proxy RandomAPI
api = Proxy
