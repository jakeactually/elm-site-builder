module SiteBuilder.Column.Model exposing (..)

import SiteBuilder.Field.Model exposing (..)

type Column
  = Column ColumnType (List Field)
  | EmptyColumn

type ColumnType
  = TextColumn
  | HtmlColumn
  | ImageColumn
  | ImageTextColumn
  | GalleryColumn
  | SliderColumn

type ColumnMsg
  = OpenSelectColumnDialog Int Int
  | CloseSelectColumnDialog
  | NewColumn Column
  | OpenEditColumnDialog Int Int
  | FieldInput Int FieldValue
  | OpenFileManager Int
  | CloseEditColumnDialog
  | AssignColumn
  | DeleteColumn Int Int
  | Drag Column
  | Drop Int Int
  
typeToName : ColumnType -> String
typeToName type_ = case type_ of
  TextColumn -> "Texto"
  HtmlColumn -> "Html"
  ImageColumn -> "Imagen"
  ImageTextColumn -> "Imagen y texto"
  GalleryColumn -> "Galería"
  SliderColumn -> "Slider"

columns : List Column
columns =
  [ textColumn
  , htmlColumn
  , imageColumn
  , imageTextColumn
  , galleryColumn
  , sliderColumn
  ]

textColumn : Column
textColumn = Column TextColumn
  [ Field "Contenido" <| RichTextValue ""
  , Field "Clase" <| TextValue ""
  ]

htmlColumn : Column
htmlColumn = Column HtmlColumn
  [ Field "" <| TextAreaValue ""
  ]

imageColumn : Column
imageColumn = Column ImageColumn
  [ Field "Imagen" <| ImageValue ""
  , Field "Clase" <| TextValue ""
  ]

imageTextColumn : Column
imageTextColumn = Column ImageTextColumn
  [ Field "Imagen" <| ImageValue ""
  , Field "Texto" <| RichTextValue ""
  , Field "Clase" <| TextValue ""
  ]

galleryColumn : Column
galleryColumn = Column GalleryColumn
  [ Field "Imágenes" <| ImagesValue []
  ]

sliderColumn : Column
sliderColumn = Column SliderColumn
  [ Field "Imágenes" <| ImagesValue []
  ]
