module Field.Model exposing (..)

import Schema exposing (..)

type Field = Field String FieldValue

type FieldValue
  = TextValue String
  | TextAreaValue String
  | RichTextValue String
  | ImageValue String
  | ImagesValue (List String)

makeField : FieldSchema -> Field
makeField (FieldSchema { type_, title }) = Field title <| case type_ of
  Text -> TextValue ""
  TextArea -> TextAreaValue ""
  RichText -> RichTextValue ""
  Image -> ImageValue ""
  Images -> ImagesValue []
