module Schema exposing (..)

import Json.Encode as Encode
import Json.Decode as Decode
import Dict exposing (Dict)

type alias Schema = Dict String (List FieldSchema)

type FieldSchema = FieldSchema
  { type_ : FieldType
  , id : String
  , title : String
  }

type FieldType
    = Text
    | TextArea
    | RichText
    | Image
    | Images

decodeSchema : Decode.Decoder Schema
decodeSchema = Decode.map Dict.fromList <| Decode.list decodeBlock

decodeBlock : Decode.Decoder (String, List FieldSchema)
decodeBlock = Decode.map2 (\x y -> (x, y))
    (Decode.field "name" Decode.string)
    (Decode.field "fields" <| Decode.list decodeField)

decodeField : Decode.Decoder FieldSchema
decodeField = Decode.map3 (\x y z -> FieldSchema { type_ = x, id = y, title = z })
    (Decode.field "type" <| Decode.andThen toFieldType Decode.string)
    (Decode.field "id" Decode.string)
    (Decode.field "title" Decode.string)

toFieldType : String -> Decode.Decoder FieldType
toFieldType type_ = case type_ of
    "Text" -> Decode.succeed Text
    "TextArea" -> Decode.succeed TextArea
    "RichText" -> Decode.succeed RichText
    "Image" -> Decode.succeed Image
    "Images" -> Decode.succeed Images
    _ -> Decode.fail "Unsupported field type"
