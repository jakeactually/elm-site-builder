module SiteBuilder.Field.View exposing (..)

import SiteBuilder.Column.Model exposing (..)
import SiteBuilder.Component exposing (icon)
import SiteBuilder.Field.Model exposing (..)
import Html exposing (Html, textarea, button, div, i, img, input, label, option, select, strong, text)
import Html.Attributes exposing (attribute, class, src, type_, value)
import Html.Events exposing (onClick, onInput)
import List exposing (indexedMap)
import SiteBuilder.Util exposing ((!!), remove)
import SiteBuilder.Main.Model exposing (..)
import Maybe exposing (andThen, withDefault)
import Markdown

-- Get

getStringAt : Int -> List Field -> String
getStringAt index fields = getAt "" valueToString index fields

getStringListAt : Int -> List Field -> List String
getStringListAt index fields = getAt [] valueToStringList index fields

getAt : a -> (Field -> Maybe a) -> Int -> List Field -> a
getAt default function index fields = withDefault default <| andThen function <| fields !! index

valueToString : Field -> Maybe String
valueToString field = case getValue field of
  TextValue value -> Just value
  TextAreaValue value -> Just value
  RichTextValue value -> Just value
  ImageValue value -> Just value
  _-> Nothing

valueToStringList : Field -> Maybe (List String)
valueToStringList field = case getValue field of
  ImagesValue value -> Just value
  _ -> Nothing

getValue : Field -> FieldValue
getValue field = let (Field _ value) = field in value

-- Render

renderField : String -> Int -> Field -> Html Msg
renderField thumbService index (Field name value) = case value of
  TextValue text_ -> renderTextField index name text_
  TextAreaValue text_ -> renderTextAreaField index name text_
  RichTextValue text_ -> renderRichTextField index name text_
  ImagesValue images -> renderImagesField thumbService index name images
  ImageValue image -> renderImageField thumbService index name image

renderTextField : Int -> String -> String -> Html Msg
renderTextField index name text_ = label []
  [ text name
  , input
      [ type_ "text"
      , value text_
      , onInput <| ColumnMsg << FieldInput index << TextValue
      ] []
  ]

renderTextAreaField : Int -> String -> String -> Html Msg
renderTextAreaField index name text_ = label []
  [ text name
  , textarea
      [ class "html"
      , onInput <| ColumnMsg << FieldInput index << TextAreaValue
      ]

      [ text text_
      ]
  ]

renderRichTextField : Int -> String -> String -> Html Msg
renderRichTextField index name text_ = div []
  [ strong [] [ text name ]
  , div [ class "quill", attribute "data-index" <| toString index ]
    [ div [ class "quill-editor" ] [ Markdown.toHtml [] text_ ]
    ]
  ]

renderImageField : String -> Int -> String -> String -> Html Msg
renderImageField thumbService index name image = div []
  [ strong [] [ text name ]
  , div [ class "images-field" ] 
    [ if image /= ""
        then renderSingleThumb thumbService index image
        else div [ class "hidden" ] []
    , button [ type_ "button", class "thumb add", onClick <| ColumnMsg <| OpenFileManager index ]
        [ i [ class "material-icons" ] [ text "add" ]
        ]
    ]
  ]

renderSingleThumb : String -> Int -> String -> Html Msg
renderSingleThumb thumbService fieldIndex image = div [ class "thumb" ]
  [ img [ src <| thumbService ++ image ] []
  , icon "clear" "" <| ColumnMsg <| FieldInput fieldIndex <| ImageValue ""
  ]

renderImagesField : String -> Int -> String -> List String -> Html Msg
renderImagesField thumbService index name images = div []
  [ strong [] [ text name ]
  , div [ class "images-field" ] <| indexedMap (renderThumb thumbService index images) images ++
    [ button [ type_ "button", class "thumb add", onClick <| ColumnMsg <| OpenFileManager index ]
        [ i [ class "material-icons" ] [ text "add" ]
        ]
    ]
  ]

renderThumb : String -> Int -> List String -> Int -> String -> Html Msg
renderThumb thumbService fieldIndex images thumbIndex image = div [ class "thumb" ]
  [ img [ src <| thumbService ++ image ] []
  , icon "clear" "" <| ColumnMsg <| FieldInput fieldIndex <| ImagesValue <| remove thumbIndex images
  ]
