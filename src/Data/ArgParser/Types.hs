module Data.ArgParser.Types (
  ParseStateType (..),
  ParseState (..),
  defaultParseState,
  ParseOptions (..),
  defaultParseOptions
) where



data ParseStateType
  = NONE
  | CHAR
  | QUOTE



data ParseState = ParseState {
  quoteChar :: Char
}



defaultParseState :: ParseState
defaultParseState = ParseState { quoteChar = '"' }



data ParseOptions = ParseOptions {
    spaces :: String,
      quotes :: String
}



defaultParseOptions :: ParseOptions
defaultParseOptions = ParseOptions { spaces = " ", quotes = "\"'" }
