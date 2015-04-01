{-# LANGUAGE RecordWildCards #-}

module Data.ArgParser (
    ParseOptions (..),
    defaultParseOptions,
    argParser
) where

data ParseStateType = NONE | CHAR | QUOTE

data ParseState = ParseState {
    quoteChar :: Char
}

data ParseOptions = ParseOptions {
    spaces :: [Char],
    quotes :: [Char]
}

defaultParseOptions :: ParseOptions
defaultParseOptions = ParseOptions { spaces = [' '], quotes = ['"', '\''] }

defaultParseState :: ParseState
defaultParseState = ParseState { quoteChar = '"' }

argParser :: ParseOptions -> String -> [String]
argParser po string = argParser' NONE defaultParseState po [] string

argParser' :: ParseStateType -> ParseState -> ParseOptions -> [String] -> String -> [String]
argParser' _ _ _ accum [] = accum
argParser' state ps@ParseState{..} po@ParseOptions{..} accum cs@(x:_) = do
    case state of
        NONE ->
            let v = dropWhile (\c -> elem c spaces) cs
            in argParser' (if (elem (head v) quotes) then QUOTE else CHAR) ps po accum v
        CHAR ->
            let
                char = takeWhile (\c -> (not (elem c spaces)) && (not (elem c quotes))) cs
                rest = dropWhile (\c -> (not (elem c spaces)) && (not (elem c quotes))) cs
            in argParser' NONE ps po (accum ++ [char]) rest
        QUOTE ->
            let
                quote = takeWhile (/= x) $ tail cs
                rest = dropWhile (/= x) $ tail cs
            in argParser' NONE ps po (accum ++ [quote]) $ tail rest
