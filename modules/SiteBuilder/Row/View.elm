module SiteBuilder.Row.View exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import List exposing (indexedMap, length, map)
import SiteBuilder.Column.View exposing (renderColumn)
import SiteBuilder.Component exposing (icon)
import SiteBuilder.Main.Model exposing (..)
import SiteBuilder.Row.Model exposing (..)
import String exposing (words, join)

renderRow : Int -> Row -> Html Msg
renderRow i (Row { columns, id_, class_ }) = div [ class "row" ]
  [ div [ class "id-and-class" ] [ text <| renderIdAndClass id_ class_ ]
  , div [ class "columns" ] <| indexedMap (renderColumn (length columns) i) columns
  , div [ class "control" ]
    [ icon "mode_edit" "" <| RowMsg <| OpenEditRowDialog i
    , icon "content_copy" "" <| RowMsg <| DuplicateRow i
    , icon "keyboard_arrow_up" "" <| RowMsg <| MoveRowUp i
    , icon "keyboard_arrow_down" "" <| RowMsg <| MoveRowDown i
    , icon "delete" "" <| RowMsg <| DeleteRow i
    ]
  ]

renderIdAndClass : String -> String -> String
renderIdAndClass id_ class_ = eachWord ((++) ".") class_ ++ format ((++) "#") id_

eachWord : (String -> String) -> String -> String
eachWord f string = if string == "" then "" else join "" <| map f <| words string

format : (String -> String) -> String -> String
format f string = if string == "" then "" else f string
