module Field.View exposing (..)

import Model exposing (..)
import Field.Model exposing (..)
import Html exposing (Html, textarea, button, div, i, img, input, label, option, select, strong, text)
import Html.Attributes exposing (attribute, class, src, title, type_, value)
import Html.Events exposing (onClick, onInput)
import List exposing (indexedMap)
import Maybe exposing (andThen, withDefault)
import Markdown exposing (defaultOptions, toHtmlWith)
import String exposing (fromInt)
import Util exposing (get, remove)

-- Get

icon : String -> String -> a -> Html a
icon text_ title_ msg = button [ type_ "button", class "sb-icon", title title_, onClick msg ]
  [ i [ class "material-icons" ] [ text text_ ]
  ]

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
  _ -> Nothing

valueToStringList : Field -> Maybe (List String)
valueToStringList (Field _ fieldvalue) = case fieldvalue of
  ImagesValue value -> Just value
  _ -> Nothing

-- Render

renderField : String -> Int -> Field ->  Html Msg
renderField thumbnailsUrl index (Field name value) = Html.map ContextMsg <| case value of
  TextValue text_ -> renderTextField index name text_
  TextAreaValue text_ -> renderTextAreaField index name text_
  RichTextValue text_ -> renderRichTextField index name text_
  ImagesValue images -> renderImagesField thumbnailsUrl index name images
  ImageValue image -> renderImageField thumbnailsUrl index name image

renderTextField : Int -> String -> String ->  Html ContextMsg
renderTextField index name text_ = label []
  [ strong [] [ text name ]
  , input
      [ type_ "text"
      , value text_
      , onInput <| (FieldInput index << TextValue)
      ] []
  ]

renderTextAreaField : Int -> String -> String ->  Html ContextMsg
renderTextAreaField index name text_ = label []
  [ strong [] [ text name ]
  , textarea
      [ class "sb-textarea"
      , onInput (FieldInput index << TextAreaValue)
      ]
      [ text text_
      ]
  ]

renderRichTextField : Int -> String -> String ->  Html ContextMsg
renderRichTextField index name text_ = div []
  [ strong [] [ text name ]
  , div [ class "sb-quill", attribute "data-index" <| fromInt index ]
    [ div [ class "sb-quill-editor" ] [ toHtmlWith { defaultOptions | sanitize = False } [] text_ ]
    ]
  ]

renderImageField : String -> Int -> String -> String ->  Html ContextMsg
renderImageField thumbnailsUrl index name image = div []
  [ strong [] [ text name ]
  , div [ class "images-field" ] 
    [ if image /= ""
        then renderSingleThumb thumbnailsUrl index image
        else div [ class "hidden" ] []
    , button [ type_ "button", class "thumb add", onClick HideSelectBlockDialog ]
        [ i [ class "material-icons" ] [ text "add" ]
        ]
    ]
  ]

renderSingleThumb : String -> Int -> String ->  Html ContextMsg
renderSingleThumb thumbnailsUrl fieldIndex image = div [ class "thumb" ]
  [ img [ src <| thumbnailsUrl ++ image ] []
  , icon "clear" "" HideSelectBlockDialog
  ]

renderImagesField : String -> Int -> String -> List String ->  Html ContextMsg
renderImagesField thumbnailsUrl index name images = div []
  [ strong [] [ text name ]
  , div [ class "images-field" ] <| indexedMap (renderThumb thumbnailsUrl index images) images ++
    [ button [ type_ "button", class "thumb add", onClick HideSelectBlockDialog ]
        [ i [ class "material-icons" ] [ text "add" ]
        ]
    ]
  ]

renderThumb : String -> Int -> List String -> Int -> String ->  Html ContextMsg
renderThumb thumbnailsUrl fieldIndex images thumbIndex image = div [ class "thumb" ]
  [ img [ src <| thumbnailsUrl ++ image ] []
  , icon "clear" "" HideSelectBlockDialog
  ]
