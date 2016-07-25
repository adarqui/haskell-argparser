module Data.ArgParserSpec (
  main,
  spec
) where



import           Data.ArgParser
import           Test.Hspec



test_string :: String
test_string = "  --name name  --desc desc    --command   \"hello world\"  --single-quotes 'single quotes'  --mixed-quotes \"mixed 'quotes'\" a b c 'd' 'e' \"f\" \"    g    \" \"\" '' boom  --dir /tmp/dir"



t1 :: [String]
t1 = ["--name","name","--desc","desc","--command","hello world","--single-quotes","single quotes","--mixed-quotes","mixed 'quotes'","a","b","c","d","e","f","    g    ","","","boom","--dir","/tmp/dir"]



t2 :: [String]
t2 = ["  ","name name  ","desc desc    ","command   ","hello world","  ","single","quotes 'single quotes'  ","mixed","quotes ","mixed 'quotes'"," a b c 'd' 'e' ","f"," ","    g    "," ",""," '' boom  ","dir /tmp/dir"]



main :: IO ()
main = hspec spec



spec :: Spec
spec = do

  describe "tests" $ do
    it "1" $ do
      argParser defaultParseOptions test_string                               `shouldBe` t1
      argParser (ParseOptions { spaces = ['-'], quotes = ['"'] }) test_string `shouldBe` t2
      argParser defaultParseOptions ""                                        `shouldBe` []
