module JsonLoaderSpec where

import           Test.Hspec
import           Data.ByteString.Lazy.Char8     ( pack )
import           Data.UUID
import           Data.Maybe

import           Knowledge
import           JsonLoader

expectedUuid :: UUID
expectedUuid = fromJust $ fromString "ceb528fb-5070-44d8-b45e-af4f52df0418"

otherUuid :: UUID
otherUuid = fromJust $ fromString "c2f676d5-505b-4673-9552-98f7ceb0b86e"

spec :: Spec
spec = parallel $ describe "Json loader" $ do
  it "loads empty metadata"
    $          loadPensine [(nil :: UUID, pack "{}")]
    `shouldBe` Nothing

  it "loads basic thought" $ do
    let
      pensine = loadPensine
        [ ( expectedUuid
          , pack
            "{\"essence\": \"My thought\", \"parents\": [], \"children\": []}"
          )
        ]

    isJust pensine `shouldBe` True
    head (fromJust pensine)
      `shouldBe` Thought expectedUuid "My thought" [] [] []
