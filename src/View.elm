module View exposing (view)

import Builder exposing (..)
import Debug exposing (toString)
import Dialogs exposing (editBlockDialog, selectBlockDialog)
import Events exposing (..)
import Field.View exposing (..)
import Html exposing (Html, textarea, button, div, strong, text)
import Html.Attributes exposing (attribute, class, draggable, style, title)
import Html.Events exposing (onClick)
import Json.Encode
import Json
import Icons
import List exposing (indexedMap, length)
import Model exposing (..)
import String exposing (fromInt)
import Util

view : Model -> Html Msg
view (context, Column column) = div [ class "sb-main" ]
  [ Html.map BuilderMsg <| div [ class "column" ] <| indexedMap (renderTopRow context) column.rows ++ [ addRow ]
  , if context.showSelectBlockDialog then selectBlockDialog context.schema else div [] []
  , if context.showEditBlockDialog then editBlockDialog context else div [] []
  --, textarea [ style "width" "100%", style "height" "600px" ] [ text <| Json.Encode.encode 4 <| Json.encode context.schema (Column column)]
  --, text <| toString column
  --, text <| toString context
  ]

addRow : Html ColumnMsg
addRow = div [ class "sb-add-bar" ]
  [ button [ onClick <| AddBlock <| newRow [ newColumn [] ], title "Add row" ] [ text "+" ]
  ]

renderColumn : Context -> Int -> Int -> Column -> Html RowMsg
renderColumn context basis i (Column { props, rows } as column)
   = Html.map (ColumnMsg i)
  <| div
    [ class "sb-column"
    , class <| "sb-basis-" ++ fromInt basis
    ]
  <| columnControl column
  :: indexedMap (renderRow context) rows

columnControl : Column -> Html ColumnMsg
columnControl (Column { props }) = div [ class "sb-column-control" ]
  [ Icons.add "Add block" SelectBlock
  , Icons.edit "Edit column" <| EditColumn <| columnProps props
  , Icons.delete "Delete column" DeleteColumn
  ]

renderTopRow : Context -> Int -> Row -> Html ColumnMsg
renderTopRow context i row = Html.map (RowMsg i) <| case row of
  Row { columns } -> div
    [ class "sb-top-block"
    ]
    [ div [ class "sb-block-head" ]
        [ strong [ class "sb-block-name" ] [ text "" ]
        , Icons.add "Add column" AddColumn
        , Icons.edit "Edit block" <| Edit row
        , Icons.copy "Duplicate" Duplicate
        , Icons.up "Move up" GoUp
        , Icons.down "Move down" GoDown
        , Icons.delete "Delete block" Delete
        ]
    , div [ class "sb-columns" ] <| indexedMap (renderColumn context <| 12 // length columns) columns
    ]
  _ -> div [] []

renderRow : Context -> Int -> Row -> Html ColumnMsg
renderRow context i row = Html.map (RowMsg i) <| case row of
  Block { name, fields, dragged } -> div
    [ class "sb-block"
    , class <| if dragged then "sb-dragged" else ""
    , draggable "true"
    , onDragStart <| DragStart row
    , onDragEnd DragEnd
    , onDragOver NoRowMsg
    , onDrop <| Drop context.currentBlock
    ]
    [ div [ class "sb-block-head" ]
        [ strong [ class "sb-block-name" ] [ text name ]
        , Icons.edit "Edit block" <| Edit row
        , Icons.copy "Duplicate" Duplicate
        , Icons.up "Move up" GoUp
        , Icons.down "Move down" GoDown
        , Icons.delete "Delete block" Delete
        ]
    , div [] [ text <| getStringAt 0 fields ]
    ]
  Row { columns } -> div
    [ class "sb-block"
    , draggable "true"
    , onDragStart <| DragStart row
    , onDragEnd DragEnd
    , onDragOver NoRowMsg
    , onDrop <| Drop context.currentBlock
    ]
    [ div [ class "sb-block-head" ]
        [ strong [ class "sb-block-name" ] [ text "" ]
        , Icons.add "Add column" AddColumn
        , Icons.edit "Edit block" <| Edit row
        , Icons.copy "Duplicate" Duplicate
        , Icons.up "Move up" GoUp
        , Icons.down "Move down" GoDown
        , Icons.delete "Delete block" Delete
        ]
    , div [ class "sb-columns" ] <| indexedMap (renderColumn context <| 12 // length columns) columns
    ]
