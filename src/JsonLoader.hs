{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
module JsonLoader
  ( loadPensineFromPath
  , loadPensine
  )
where

-- |Persisted hierarchy on disk:
--
-- root
-- ├── thought-1_123e4567-e89b-12d3-a456-426655440000
-- │   ├── .metadata.json
-- │   ├── file1.md
-- │   └── file2.pdf
-- └── thought-2_27ba5954-09e7-4822-a06d-3f29d5ec9856
--     └── ...
--
-- .metadata.json:
-- > {
-- >   "essence": string,
-- >   "parents": [uuid],
-- > }

import           Data.Aeson
import           Data.ByteString.Lazy           ( ByteString )
import           Data.UUID
import           GHC.Generics
import           Knowledge                      ( Thought(Thought)
                                                , Attachment
                                                )

data RawThought = ParsedThought { essence :: String, parents :: [UUID] }
  deriving (Show, Generic, FromJSON)

loadPensineFromPath :: FilePath -> IO (Maybe [Thought])
loadPensineFromPath = undefined

loadPensine :: [(UUID, ByteString)] -> Maybe [Thought]
loadPensine jsonThoughts = fmap linkThoughts <$> thoughts
 where
  thoughts = sequence $ loadThought <$> jsonThoughts
  linkThoughts (_parentsUuid, partialThought) = partialThought [] [] []

loadThought
  :: (UUID, ByteString)
  -> Maybe ([UUID], [Thought] -> [Thought] -> [Attachment] -> Thought)
loadThought (uuid, jsonThought) = toPartialThought <$> rawThought
 where
  rawThought = decode jsonThought :: Maybe RawThought
  toPartialThought t = (parents t, Thought uuid $ essence t)
