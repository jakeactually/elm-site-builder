module SiteBuilder.Column.View exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (attribute, class, draggable)
import Html.Events exposing (onClick)
import SiteBuilder.Column.Model exposing (..)
import SiteBuilder.Component exposing (icon)
import SiteBuilder.Events exposing (onDragOver, onDragStart, onDrop)
import SiteBuilder.Field.View exposing (getStringAt, getStringListAt)
import SiteBuilder.Field.Model exposing (..)
import SiteBuilder.Main.Model exposing (..)
import String exposing (join)
import String.Extra exposing (ellipsis, stripTags)

renderColumn : Int -> Int -> Int -> Column -> Html Msg
renderColumn columnsAmount i j column = div
  [ class <| "column " ++ basis columnsAmount
  , draggable "true"
  , onDragStart <| ColumnMsg <| Drag column
  , attribute "ondragstart" "event.dataTransfer.setData(0, 0);"
  , onDragOver <| None
  , onDrop <| ColumnMsg <| Drop i j
  ]

  [ case column of
      Column type_ data ->
        div [ class "active" ]
        [ div []
            [ div [ class "title" ] [ text <| typeToName type_ ]
            , div [] [ text <| getExcerpt type_ data ]
            ]
        , div []
            [ icon "mode_edit" "" <| ColumnMsg <| OpenEditColumnDialog i j
            , icon "delete" "" <| ColumnMsg <| DeleteColumn i j
            ]
        ]
      EmptyColumn ->
        div [ class "empty" ] [ icon "add" "" <| ColumnMsg <| OpenSelectColumnDialog i j ]
  ]

basis : Int -> String
basis columnsAmount = case columnsAmount of
  1 -> "basis-1"
  2 -> "basis-2"
  3 -> "basis-3"
  4 -> "basis-4"
  _ -> ""

getExcerpt : ColumnType -> List Field -> String
getExcerpt type_ fields = ellipsis 25 <| case type_ of
  TextColumn -> stripTags <| getStringAt 0 fields
  HtmlColumn -> getStringAt 0 fields
  ImageColumn -> getStringAt 0 fields
  ImageTextColumn -> getStringAt 0 fields
  GalleryColumn -> join ", " <| getStringListAt 0 fields
  SliderColumn -> join ", " <| getStringListAt 0 fields

renderWidget : Column -> Html Msg
renderWidget column = div [ class "widget", onClick <| ColumnMsg <| NewColumn column ]
  [ text <| getName column ]

getName : Column -> String
getName column = case column of
  Column type_ _ -> typeToName type_
  EmptyColumn -> ""
