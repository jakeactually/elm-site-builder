module SiteBuilder.Json exposing (..)

import SiteBuilder.Row.Model exposing (..)
import SiteBuilder.Column.Model exposing (..)
import SiteBuilder.Field.Model exposing (..)
import SiteBuilder.Field.View exposing (..)
import Json.Encode as Encode
import Json.Decode as Decode
import List exposing (map, take)

-- Encode

encode : List Row -> String
encode rows = Encode.encode 4 <| Encode.list <| map encodeRow rows

encodeRow : Row -> Encode.Value
encodeRow (Row { id_, class_, columns }) = Encode.object
  [ ("id", Encode.string id_)
  , ("class", Encode.string class_)
  , ("columns", Encode.list <| map encodeColumn columns)
  ]

encodeColumn : Column -> Encode.Value
encodeColumn column = case column of
  Column type_ fields -> encodeColumnType type_ fields
  EmptyColumn -> Encode.object
    [ ("type", Encode.string "Empty")
    ]

encodeColumnType : ColumnType -> List Field -> Encode.Value
encodeColumnType type_ fields = case type_ of
  TextColumn -> encodeTextColumn fields
  HtmlColumn -> encodeHtmlColumn fields
  ImageColumn -> encodeImageColumn fields
  ImageTextColumn -> encodeImageTextColumn fields
  GalleryColumn -> encodeGalleryColumn fields
  SliderColumn -> encodeSliderColumn fields 

encodeTextColumn : List Field -> Encode.Value
encodeTextColumn fields = Encode.object
    [ ("type", Encode.string "Text")
    , ("content", Encode.string <| getStringAt 0 fields)
    , ("class", Encode.string <| getStringAt 1 fields)
    ]

encodeHtmlColumn : List Field -> Encode.Value
encodeHtmlColumn fields = Encode.object
    [ ("type", Encode.string "Html")
    , ("content", Encode.string <| getStringAt 0 fields)
    ]

encodeImageColumn : List Field -> Encode.Value
encodeImageColumn fields = Encode.object
    [ ("type", Encode.string "Image")
    , ("image", Encode.string <| getStringAt 0 fields)
    , ("class", Encode.string <| getStringAt 1 fields)
    ]

encodeImageTextColumn : List Field -> Encode.Value
encodeImageTextColumn fields = Encode.object
    [ ("type", Encode.string "ImageText")
    , ("image", Encode.string <| getStringAt 0 fields)
    , ("text", Encode.string <| getStringAt 0 fields)
    , ("class", Encode.string <| getStringAt 1 fields)
    ]

encodeGalleryColumn : List Field -> Encode.Value
encodeGalleryColumn fields = Encode.object
    [ ("type", Encode.string "Gallery")
    , ("images", Encode.list <| map Encode.string <| getStringListAt 0 fields)
    ]

encodeSliderColumn : List Field -> Encode.Value
encodeSliderColumn fields = Encode.object
    [ ("type", Encode.string "Slider")
    , ("images", Encode.list <| map Encode.string <| getStringListAt 0 fields)
    ]

-- Decode

decode : String -> List Row
decode string = case Decode.decodeString (Decode.list rowDecoder) string of
  Ok rows -> rows
  Err _ -> [ newRow 1 ]

maybeDecode : String -> Maybe (List Row)
maybeDecode string = case Decode.decodeString (Decode.list rowDecoder) string of
  Ok rows -> Just rows
  Err _ -> Nothing

rowDecoder : Decode.Decoder Row
rowDecoder = Decode.map3 (\x y z -> Row { id_ = x, class_ = y, columns = z })
  (Decode.field "id" Decode.string)
  (Decode.field "class" Decode.string)
  (Decode.field "columns" <| columnsDecoder)

columnsDecoder : Decode.Decoder (List Column)
columnsDecoder =  Decode.andThen (Decode.succeed << take 4) <| Decode.list columnDecoder

columnDecoder : Decode.Decoder Column
columnDecoder = Decode.andThen columnTypeDecoder <| Decode.field "type" Decode.string

columnTypeDecoder : String -> Decode.Decoder Column
columnTypeDecoder type_ = case type_ of
  "Text" -> textColumnDecoder
  "Html" -> htmlColumnDecoder
  "Image" -> imageColumnDecoder
  "ImageText" -> imageTextColumnDecoder
  "Gallery" -> galleryColumnDecoder
  "Slider" -> sliderColumnDecoder
  _ -> Decode.succeed EmptyColumn

textColumnDecoder : Decode.Decoder Column
textColumnDecoder = Decode.map2 (\x y -> Column TextColumn [ Field "Contenido" <| RichTextValue x, Field "Clase" <| TextValue y ])
  (Decode.field "content" Decode.string)
  (Decode.field "class" Decode.string)

htmlColumnDecoder : Decode.Decoder Column
htmlColumnDecoder = Decode.map (\x -> Column HtmlColumn [ Field "" <| TextAreaValue x ])
  (Decode.field "content" Decode.string)

imageColumnDecoder : Decode.Decoder Column
imageColumnDecoder = Decode.map2 (\x y -> Column ImageColumn [ Field "Imagen" <| ImageValue x, Field "Clase" <| TextValue y ])
  (Decode.field "image" Decode.string)
  (Decode.field "class" Decode.string)

imageTextColumnDecoder : Decode.Decoder Column
imageTextColumnDecoder = Decode.map3 imageTextColumnMap
  (Decode.field "image" Decode.string)
  (Decode.field "text" Decode.string)
  (Decode.field "class" Decode.string)

imageTextColumnMap : String -> String -> String -> Column
imageTextColumnMap x y z = Column ImageColumn
  [ Field "Imagen" <| ImageValue x
  , Field "Texto" <| RichTextValue x
  , Field "Clase" <| TextValue y
  ]

galleryColumnDecoder : Decode.Decoder Column
galleryColumnDecoder = Decode.map (\x -> Column GalleryColumn [ Field "Imágenes" <| ImagesValue x ])
  (Decode.field "images" <| Decode.list Decode.string)

sliderColumnDecoder : Decode.Decoder Column
sliderColumnDecoder = Decode.map (\x -> Column SliderColumn [ Field "Imágenes" <| ImagesValue x ])
  (Decode.field "images" <| Decode.list Decode.string)
