module Field.Util exposing (..)

import Field.Model exposing (..)
import Maybe exposing (andThen, withDefault)
import String exposing (join)
import Util exposing (get)

getStringAt : Int -> List Field -> String
getStringAt index fields = getAt "" valueToString index fields

getStringListAt : Int -> List Field -> List String
getStringListAt index fields = getAt [] valueToStringList index fields

getAt : a -> (Field -> Maybe a) -> Int -> List Field -> a
getAt default function index fields = withDefault default <| andThen function <| get index fields

valueToString : Field -> Maybe String
valueToString (Field _ fieldvalue) = case fieldvalue of
  TextValue value -> Just value
  TextAreaValue value -> Just value
  RichTextValue value -> Just value
  ImageValue value -> Just value
  ImagesValue value -> Just <| join ", " value

valueToStringList : Field -> Maybe (List String)
valueToStringList (Field _ fieldvalue) = case fieldvalue of
  ImagesValue value -> Just value
  _ -> Nothing
