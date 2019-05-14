module Dialogs exposing (editBlockDialog, selectBlockDialog)

import Builder exposing (..)
import Dict
import Model exposing (..)
import Field.View exposing (renderField)
import Field.Model exposing (..)
import Html exposing (Html, button, div, h2, text)
import Html.Attributes exposing (class, id, title, type_)
import Html.Events exposing (onClick)
import List exposing (indexedMap, map)
import Schema exposing (..)
import Util exposing (capitalize)

modal : String -> List (Html a) -> List (Html a) -> Html a
modal title_ content ctrl =
  div [ class "sb-screen" ]
    [ div [ class "sb-modal" ]
      [ h2 [] [ text title_ ]
      , div [ class "sb-content" ]
      [ div [ class "sb-wrap" ] content
      ]
      , div [ class "buttons" ] ctrl
      ]
    ]

selectBlockDialog : Schema -> Html Msg
selectBlockDialog schema = modal
  "Choose block"
  [ div [ class "sb-schemas" ] <| (map renderBlock <| Dict.keys schema) ++ [ rowBlock ]
  ]
  [ button [ type_ "button", class "sb-button", onClick <| ContextMsg HideSelectBlockDialog ] [ text "Cancel" ]
  ]

renderBlock : String -> Html Msg
renderBlock blockSchemaKey =
  div [ class "sb-schema", onClick <| ContextMsg <| NewBlock <| blockSchemaKey ] [ text blockSchemaKey ]

rowBlock : Html Msg
rowBlock =
  div [ class "sb-schema", onClick <| ContextMsg <| RowBlock ] [ text "Row" ]

editBlockDialog : Form -> String -> Html Msg
editBlockDialog form thumbnailsUrl =
  let (Form name fields) = form in renderCurrentBlock thumbnailsUrl name fields

renderCurrentBlock : String -> String -> List Field -> Html Msg
renderCurrentBlock thumbnailsUrl id fields = modal
  (capitalize id)
  (indexedMap (renderField thumbnailsUrl) fields)
  [ button [ type_ "button", class "sb-button", onClick <| ContextMsg HideEditBlockDialog ] [ text "Cancel" ]
  , button [ type_ "button", class "sb-button", onClick <| ContextMsg <| AcceptBlock ] [ text "Ok" ]
  ]
