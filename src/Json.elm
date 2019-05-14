module Json exposing (..)

import Builder exposing (..)
import Dict exposing (Dict)
import Field.Model exposing (..)
import Field.Util exposing (getStringAt)
import Json.Encode as Encode
import Json.Decode as Decode exposing (decodeValue)
import List exposing (filterMap, map, map2, take)
import Schema exposing (..)
import Result exposing (toMaybe, withDefault)

-- Encode

encode : Schema -> Column -> Encode.Value
encode schema (Column { rows }) = Encode.list (encodeRow schema) rows

encodeColumn : Schema -> Column -> Encode.Value
encodeColumn schema (Column { form, rows }) = let (Form _ fields) = form in Encode.object
  [ ("id", Encode.string <| getStringAt 0 fields)
  , ("class", Encode.string <| getStringAt 1 fields)
  , ("rows", Encode.list (encodeRow schema) rows)
  ]

encodeRow : Schema -> Row -> Encode.Value
encodeRow schema (Row { isBlock, form, columns }) = let (Form name fields) = form in if isBlock
  then case Dict.get name schema of
    Just fieldSchemas ->
      Encode.object <| ("type", Encode.string name) :: map2 encodeField fieldSchemas fields
    Nothing ->
      Encode.null
  else Encode.object
    [ ("type", Encode.string "Row")
    , ("id", Encode.string <| getStringAt 0 fields)
    , ("class", Encode.string <| getStringAt 1 fields)
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

decode : Schema -> Encode.Value -> Column
decode schema str = case decodeValue (Decode.list <| maybeRowDecoder schema) str of
  Ok rows -> let (Column c) = newColumn in Column { c | rows = rows }
  Err _ -> newColumn

columnDecoder : Schema -> Decode.Decoder Column
columnDecoder schema = Decode.map3 buildColumn
  (Decode.field "id" Decode.string)
  (Decode.field "class" Decode.string)
  (Decode.field "rows" <| Decode.list (maybeRowDecoder schema))

buildColumn : String -> String -> List Row -> Column
buildColumn id class rows = Column
  { form = Form "Column" [ Field "id" <| TextValue id, Field "class" <| TextValue class ]
  , rows = rows
  }

maybeRowDecoder : Schema -> Decode.Decoder Row
maybeRowDecoder schema = Decode.andThen (rowDecoder schema) <| Decode.field "type" Decode.string

rowDecoder : Schema -> String -> Decode.Decoder Row
rowDecoder schema name = case Dict.get name schema of
  Just fieldsSchemas ->
    Decode.map (\dict -> setForm (Form name <| filterMap (toField dict) fieldsSchemas) <| setIsBlock True newRow)
    <| Decode.dict Decode.value
  Nothing ->
    Decode.map3 buildRow
      (Decode.field "id" Decode.string)
      (Decode.field "class" Decode.string)
      (Decode.field "columns" <| Decode.list <| columnDecoder schema)

buildRow : String -> String -> List Column -> Row
buildRow id class columns = Row
  { isBlock = False
  , form = Form "Row" [ Field "id" <| TextValue id, Field "class" <| TextValue class ]
  , columns = columns
  , isTarget = False
  }

toField : Dict String Encode.Value -> FieldSchema -> Maybe Field
toField dict (FieldSchema { id, type_ }) = Dict.get id dict |> Maybe.andThen
  (\value -> toMaybe <| case type_ of
    Text -> Result.map (Field id << TextValue) <| decodeValue Decode.string value
    TextArea -> Result.map (Field id << TextAreaValue) <| decodeValue Decode.string value
    RichText -> Result.map (Field id << RichTextValue) <| decodeValue Decode.string value
    Image -> Result.map (Field id << ImageValue) <| decodeValue Decode.string value
    Images -> Result.map (Field id << ImagesValue) <| decodeValue (Decode.list Decode.string) value
  )
