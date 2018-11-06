module Json exposing (..)

import Builder exposing (..)
import Dict exposing (Dict)
import Field.Model exposing (..)
import Json.Encode as Encode
import Json.Decode as Decode exposing (decodeValue)
import List exposing (filterMap, map, map2, take)
import Schema exposing (..)
import Result exposing (toMaybe, withDefault)

-- Encode

encode : Schema -> Column -> Encode.Value
encode schema (Column { rows }) = Encode.list (encodeRow schema) rows

encodeColumn : Schema -> Column -> Encode.Value
encodeColumn schema (Column { rows }) = Encode.object
  [ ("rows", Encode.list (encodeRow schema) rows)
  ]

encodeRow : Schema -> Row -> Encode.Value
encodeRow schema row = case row of 
  Block { name, fields } -> case Dict.get name schema of
    Just fieldSchemas ->
      Encode.object <| ("type", Encode.string name) :: map2 encodeField fieldSchemas fields
    Nothing ->
      Encode.null
  Row { columns } -> Encode.object
    [ ("type", Encode.string "Row")
    , ("columns", Encode.list (encodeColumn schema) columns)
    ]

encodeField : FieldSchema -> Field -> (String, Encode.Value)
encodeField (FieldSchema schema) (Field type_ value) = (schema.id, encodeValue value) 

encodeValue : FieldValue -> Encode.Value
encodeValue value = case value of
  TextValue str -> Encode.string str
  TextAreaValue str -> Encode.string str
  RichTextValue str -> Encode.string str
  ImageValue str -> Encode.string str
  ImagesValue strs -> Encode.list Encode.string strs

-- Decode

decode : Schema -> String -> Column
decode schema str = case Decode.decodeString (Decode.list <| maybeRowDecoder schema) str of
  Ok rows -> newColumn rows
  Err _ -> newColumn []

columnDecoder : Schema -> Decode.Decoder Column
columnDecoder schema = Decode.map (\x -> newColumn x)
  (Decode.field "rows" <| Decode.list (maybeRowDecoder schema))

maybeRowDecoder : Schema -> Decode.Decoder Row
maybeRowDecoder schema = Decode.andThen (rowDecoder schema) <| Decode.field "type" Decode.string

rowDecoder : Schema -> String -> Decode.Decoder Row
rowDecoder schema name = case Dict.get name schema of
  Just fieldsSchemas ->
    Decode.map (\dict -> Block { name = name, fields = filterMap (toField dict) fieldsSchemas, dragged = False })
    <| Decode.dict Decode.value
  Nothing ->
    Decode.map newRow (Decode.field "columns" <| Decode.list <| columnDecoder schema)

toField : Dict String Encode.Value -> FieldSchema -> Maybe Field
toField dict (FieldSchema { id, type_ }) = Dict.get id dict |> Maybe.andThen
  (\value -> toMaybe <| case type_ of
    Text -> Result.map (Field id << TextValue) <| decodeValue Decode.string value
    TextArea -> Result.map (Field id << TextAreaValue) <| decodeValue Decode.string value
    RichText -> Result.map (Field id << RichTextValue) <| decodeValue Decode.string value
    Image -> Result.map (Field id << ImageValue) <| decodeValue Decode.string value
    Images -> Result.map (Field id << ImagesValue) <| decodeValue (Decode.list Decode.string) value
  )
