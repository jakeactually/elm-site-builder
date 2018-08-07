module SiteBuilder.Field.Model exposing (..)

type Field = Field String FieldValue

type FieldValue
  = TextValue String
  | TextAreaValue String
  | RichTextValue String
  | ImageValue String
  | ImagesValue (List String)
