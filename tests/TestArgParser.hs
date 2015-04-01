module TestArgParser (
    tests
) where

import Distribution.TestSuite
import Data.ArgParser

test_string :: String
test_string = "  --name name  --desc desc    --command   \"hello world\"  --single-quotes 'single quotes'  --mixed-quotes \"mixed 'quotes'\" a b c 'd' 'e' \"f\" \"    g    \" \"\" '' boom  --dir /tmp/dir"

t1 :: (ParseOptions, [String])
t1 = (defaultParseOptions, ["--name","name","--desc","desc","--command","hello world","--single-quotes","single quotes","--mixed-quotes","mixed 'quotes'","a","b","c","d","e","f","    g    ","","","boom","--dir","/tmp/dir"])

t2 :: (ParseOptions, [String])
t2 = ((ParseOptions { spaces = ['-'], quotes = ['"'] }), ["  ","name name  ","desc desc    ","command   ","hello world","  ","single","quotes 'single quotes'  ","mixed","quotes ","mixed 'quotes'"," a b c 'd' 'e' ","f"," ","    g    "," ",""," '' boom  ","dir /tmp/dir"])

t3 :: (ParseOptions, [String])
t3 = (defaultParseOptions, [""])

tests :: IO [Test]
tests = return [ Test test1, Test test2, Test test3 ]
    where
        test1 = TestInstance
            {
                run = return $ Finished $ test_argParser t1
              , name = "Normal Quotes"
              , tags = []
              , options = []
              , setOption = \_ _ -> Right test1
            }
        test2 = TestInstance
            {
                run = return $ Finished $ test_argParser t2
              , name = "fail"
              , tags = []
              , options = []
              , setOption = \_ _ -> Right test2
            }
        test3 = TestInstance
            {
                run = return $ Finished $ (if ((test_argParser t3) == Fail "FAIL") then Pass else Fail "FAIL")
              , name = "fail"
              , tags = []
              , options = []
              , setOption = \_ _ -> Right test3
            }

test_argParser :: (ParseOptions, [String]) -> Result
test_argParser tup = (if ((argParser (fst tup) test_string) == (snd tup)) then Pass else Fail "FAIL")
