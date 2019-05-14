module Field.View exposing (..)

import Model exposing (..)
import Field.Model exposing (..)
import Field.Util exposing (..)
import Json.Encode exposing (string)
import Html exposing (Html, textarea, button, div, i, img, input, label, option, select, strong, text)
import Html.Attributes exposing (attribute, class, property, src, title, type_, value)
import Html.Events exposing (onClick, onInput)
import Icons
import List exposing (indexedMap)
import Markdown exposing (toHtmlWith, defaultOptions)
import String exposing (fromInt)
import Util exposing (capitalize, remove)

renderField : String -> Int -> Field ->  Html Msg
renderField thumbnailsUrl index (Field name value) = Html.map ContextMsg <| case value of
  TextValue text_ -> renderTextField index name text_
  TextAreaValue text_ -> renderTextAreaField index name text_
  RichTextValue text_ -> renderRichTextField index name text_
  ImagesValue images -> renderImagesField thumbnailsUrl index name images
  ImageValue image -> renderImageField thumbnailsUrl index name image

renderTextField : Int -> String -> String ->  Html ContextMsg
renderTextField index name text_ = label [ class "sb-field" ]
  [ fieldHead name
  , input
      [ type_ "text"
      , value text_
      , onInput <| FieldInput index << TextValue
      ] []
  ]

fieldHead : String -> Html msg
fieldHead name = strong [] [ text <| capitalize name ]

renderTextAreaField : Int -> String -> String ->  Html ContextMsg
renderTextAreaField index name text_ = label [ class "sb-field" ]
  [ fieldHead name
  , textarea [ onInput (FieldInput index << TextAreaValue) ] [ text text_ ]
  ]

renderRichTextField : Int -> String -> String ->  Html ContextMsg
renderRichTextField index name text_ = div [ class "sb-field" ]
  [ fieldHead name
  , div [ class "sb-quill", attribute "data-index" <| fromInt index ]
    [ div [ class "sb-quill-editor" ] [ toHtmlWith { defaultOptions | sanitize = False } [] text_ ]
    ]
  ]

renderImageField : String -> Int -> String -> String ->  Html ContextMsg
renderImageField thumbnailsUrl index name image = div [ class "sb-field" ]
  [ fieldHead name
  , div [ class "sb-images-field" ] 
    [ if image /= ""
        then renderSingleThumb thumbnailsUrl index image
        else div [ class "sb-hidden" ] []
    , button [ type_ "button", class "sb-thumb sb-add", onClick <| OpenFileManager index ]
        [ text "+"
        ]
    ]
  ]

renderSingleThumb : String -> Int -> String ->  Html ContextMsg
renderSingleThumb thumbnailsUrl fieldIndex image = div [ class "sb-thumb" ]
  [ img [ src <| thumbnailsUrl ++ image ] []
  , button
    [ class "sb-clear"
    , onClick <| FieldInput fieldIndex <| ImageValue ""
    ] [ text "×" ]
  ]

renderImagesField : String -> Int -> String -> List String ->  Html ContextMsg
renderImagesField thumbnailsUrl index name images = div [ class "sb-field" ]
  [ fieldHead name
  , div [ class "sb-images-field" ] <| indexedMap (renderThumb thumbnailsUrl index images) images ++
    [ button [ type_ "button", class "sb-thumb sb-add", onClick <| OpenFileManager index ]
        [ text "+"
        ]
    ]
  ]

renderThumb : String -> Int -> List String -> Int -> String -> Html ContextMsg
renderThumb thumbnailsUrl fieldIndex images thumbIndex image = div [ class "sb-thumb" ]
  [ img [ src <| thumbnailsUrl ++ image ] []
  , button
    [ class "sb-clear"
    , onClick <| FieldInput fieldIndex <| ImagesValue <| remove thumbIndex images
    ] [ text "×" ]
  ]
