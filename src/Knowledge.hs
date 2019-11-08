module Knowledge where

import           Data.UUID

data Thought = Thought { uuid :: UUID, essence :: String, parents :: [Thought], children :: [Thought], attachments :: [Attachment] }
  deriving (Eq, Show)

newtype Attachment = Attachment FilePath
  deriving (Eq, Show)
