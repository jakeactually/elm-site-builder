module View exposing (view)

import Builder exposing (..)
import Debug exposing (toString)
import Dialogs exposing (editBlockDialog, selectBlockDialog)
import Events exposing (..)
import Field.Util exposing (..)
import Field.View exposing (..)
import Html exposing (Html, textarea, button, div, input, strong, text)
import Html.Attributes exposing (attribute, class, draggable, id, style, title, type_, value)
import Html.Events exposing (onClick)
import Json as J
import Json.Encode as E
import Icons
import List exposing (indexedMap, length)
import Markdown exposing (toHtmlWith, defaultOptions)
import Model exposing (..)
import String exposing (fromInt)
import Util

buttonIcon : Html msg -> String -> msg -> Html msg
buttonIcon icon titleText msg  = button [ class "sb-icon", title titleText, onClick msg ] [ icon ]

view : Model -> Html Msg
view (context, Column column) = div [ class "sb-main" ]
  [ Html.map BuilderMsg <| div [ class "column" ] <| indexedMap (renderTopRow context) column.rows ++ [ addRow ]
  , if context.showSelectBlockDialog then selectBlockDialog context.schema else div [] []
  , if context.showEditBlockDialog then editBlockDialog context.currentForm context.thumbnailsUrl else div [] []
  , input [ id "sb-value", type_ "hidden", value <| E.encode 4 <| J.encode context.schema <| Column column ] []
  ]

addRow : Html ColumnMsg
addRow = div [ class "sb-add-bar" ]
  [ button [ onClick <| AddBlock <| Form "Row" [], title "Add row" ] [ text "+" ]
  ]

renderColumn : Context -> Int -> Int -> Column -> Html RowMsg
renderColumn context basis i (Column { form, rows } as column)
   = Html.map (ColumnMsg i)
  <| div
    [ class "sb-column"
    , class <| "sb-basis-" ++ fromInt basis
    ]
  <| columnControl column
  :: indexedMap (renderRow context) rows

columnControl : Column -> Html ColumnMsg
columnControl (Column { form }) = div [ class "sb-column-control" ]
  [ buttonIcon Icons.addBlock "Add block" SelectBlock
  , buttonIcon Icons.edit "Edit column" <| EditColumn form
  , buttonIcon Icons.left "Move left" GoLeft
  , buttonIcon Icons.right "Move right" GoRight
  , buttonIcon Icons.delete "Delete column" DeleteColumn
  ]

renderTopRow : Context -> Int -> Row -> Html ColumnMsg
renderTopRow context i (Row { form, columns }) = Html.map (RowMsg i) <| div [ class "sb-top-block" ]
  [ div [ class "sb-block-head" ]
    [ buttonIcon Icons.addColumn "Add column" AddColumn
    , buttonIcon Icons.edit "Edit row" <| Edit form
    , buttonIcon Icons.copy "Duplicate" Duplicate
    , buttonIcon Icons.up "Move up" GoUp
    , buttonIcon Icons.down "Move down" GoDown
    , buttonIcon Icons.delete "Delete row" Delete
    ]
  , div [ class "sb-columns" ] <| indexedMap (renderColumn context <| 12 // length columns) columns
  ]

renderRow : Context -> Int -> Row -> Html ColumnMsg
renderRow context i (Row { isBlock, form, dragged, columns } as row) = Html.map (RowMsg i) <| div
  [ class "sb-block"
  , class <| if dragged then "sb-dragged" else ""
  , draggable "true"
  , onDragStart <| DragStart row
  , onDragEnd DragEnd
  , onDragOver NoRowMsg
  , onDrop <| Drop context.currentRow
  ]
  [ rowControl row
  , if isBlock 
    then div []
      [ let (Form name fields) = form in case name of
        "Text" -> toHtmlWith { defaultOptions | sanitize = False } [] <| getStringAt 0 fields 
        _ -> text <| getStringAt 0 fields 
      ]
    else div [ class "sb-columns" ] <| indexedMap (renderColumn context <| 12 // length columns) columns
  ]

rowControl : Row -> Html RowMsg
rowControl (Row { isBlock, form }) = div [ class "sb-block-head" ]
  [ strong [ class "sb-block-name" ] [ text <| let (Form name _) = form in name ]
  , if isBlock then div [] [] else buttonIcon Icons.addColumn "Add column" AddColumn
  , buttonIcon Icons.edit "Edit block" <| Edit form
  , buttonIcon Icons.copy "Duplicate" Duplicate
  , buttonIcon Icons.up "Move up" GoUp
  , buttonIcon Icons.down "Move down" GoDown
  , buttonIcon Icons.delete "Delete block" Delete
  ]
