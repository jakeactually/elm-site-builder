module SiteBuilder.Main.View exposing (..)

import SiteBuilder.Json exposing (encode)
import Html exposing (Html, div, text, textarea)
import Html.Attributes exposing (id, style)
import Html.Events exposing (onInput)
import List exposing (indexedMap, isEmpty)
import SiteBuilder.Dialog exposing (..)
import SiteBuilder.Main.Model exposing (..)
import SiteBuilder.Row.View exposing (renderRow)

view : Model -> Html Msg
view model = div [] <| if model.showJson
  then
    [ textarea
      [ id "json"
      , onInput JsonInput
      ]
      [ text <| encode model.rows
      ]
    ]
  else
    [ if isEmpty model.rows
        then div [ id "add-a-file" ] [ text "Añada una fila" ]
        else div [] <| indexedMap renderRow model.rows
    , if model.showAddRowDialog then addRowDialog else div [] []
    , if model.showEditRowDialog then editRowDialog model.currentRowIndex model.currentRow else div [] []
    , if model.showSelectBuilderDialog then selectColumnDialog else div [] []
    , if model.showEditBuilderDialog then editColumnDialog model.thumbService model.currentColumn else div [] []
    ]
