{-# LANGUAGE RecordWildCards #-}

module Data.ArgParser (
  ParseOptions (..),
  defaultParseOptions,
  argParser
) where



import           Data.Monoid ((<>))



data ParseStateType
  = NONE
  | CHAR
  | QUOTE



data ParseState = ParseState {
  quoteChar :: Char
}



data ParseOptions = ParseOptions {
  spaces :: String,
  quotes :: String
}



defaultParseOptions :: ParseOptions
defaultParseOptions = ParseOptions { spaces = " ", quotes = "\"'" }



defaultParseState :: ParseState
defaultParseState = ParseState { quoteChar = '"' }



argParser :: ParseOptions -> String -> [String]
argParser parse_options = argParser' NONE defaultParseState parse_options []



argParser' :: ParseStateType -> ParseState -> ParseOptions -> [String] -> String -> [String]
argParser' _ _ _ accum [] = accum
argParser' state parse_state@ParseState{..} parse_options@ParseOptions{..} accum cs@(x:_) =
  case state of
    NONE ->
      let
        v          = dropWhile (`elem` spaces) cs
        state_type = if head v `elem` quotes then QUOTE else CHAR
      in argParser' state_type parse_state parse_options accum v
    CHAR ->
      let
        char = takeWhile (\c -> notElem c spaces && notElem c quotes) cs
        rest = dropWhile (\c -> notElem c spaces && notElem c quotes) cs
      in argParser' NONE parse_state parse_options (accum <> [char]) rest
    QUOTE ->
      let
        quote = takeWhile (/= x) $ tail cs
        rest = dropWhile (/= x) $ tail cs
      in argParser' NONE parse_state parse_options (accum <> [quote]) $ tail rest
