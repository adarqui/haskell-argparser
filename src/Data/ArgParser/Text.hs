{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Data.ArgParser.Text (
  module A,
  argParser
) where



import           Data.ArgParser.Types as A
import           Data.Monoid          ((<>))
import           Data.Text            (Text)
import qualified Data.Text            as Text



argParser :: ParseOptions -> Text -> [Text]
argParser parse_options = argParser' NONE defaultParseState parse_options []



argParser' :: ParseStateType -> ParseState -> ParseOptions -> [Text] -> Text -> [Text]
argParser' _ _ _ accum "" = accum
argParser' state parse_state@ParseState{..} parse_options@ParseOptions{..} accum cs =
  case state of
    NONE ->
      let
        v          = Text.dropWhile (`elem` spaces) cs
        state_type = if Text.head v `elem` quotes then QUOTE else CHAR
      in argParser' state_type parse_state parse_options accum v
    CHAR ->
      let
        char = Text.takeWhile (\c -> notElem c spaces && notElem c quotes) cs
        rest = Text.dropWhile (\c -> notElem c spaces && notElem c quotes) cs
      in argParser' NONE parse_state parse_options (accum <> [char]) rest
    QUOTE ->
      let
        quote = Text.takeWhile (/= Text.head cs) $ Text.tail cs
        rest = Text.dropWhile (/= Text.head cs) $ Text.tail cs
      in argParser' NONE parse_state parse_options (accum <> [quote]) $ Text.tail rest
