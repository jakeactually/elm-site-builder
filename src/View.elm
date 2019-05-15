module View exposing (view)

import Builder exposing (..)
import Dialogs exposing (editBlockDialog, selectBlockDialog)
import Events exposing (..)
import Field.Util exposing (..)
import Field.View exposing (..)
import Html exposing (Html, textarea, button, div, input, strong, text)
import Html.Attributes as A exposing (attribute, class, draggable, id, style, title, type_, value)
import Html.Events exposing (onClick)
import Json as J
import Json.Encode as E
import Icons
import List exposing (indexedMap, length)
import Markdown exposing (toHtmlWith, defaultOptions)
import Model exposing (..)
import String exposing (fromInt,fromFloat)
import Util exposing (isJust)
import Vec exposing (Vec2(..))

view : Model -> Html Msg
view model = let (Column { rows }) = model.column in div
  [ class "sb-main"
  , class <| if model.dragging then "sb-dragging" else ""
  , onMouseMove <| ContextMsg << MouseMove
  , onMouseUp <| ContextMsg MouseUp
  ]
  [ Html.map BuilderMsg <| div [ class "column" ] <| indexedMap (renderTopRow model) rows ++ [ addRow ]
  , if model.showSelectBlockDialog then selectBlockDialog model.schema else div [] []
  , if model.showEditBlockDialog then editBlockDialog model.currentForm model.thumbnailsUrl else div [] []
  , input [ id "sb-value", type_ "hidden", value <| E.encode 4 <| J.encode model.schema <| model.column ] []
  , if model.dragging
      then
        let (Vec2 x y) = model.cursor
        in div [ class "sb-ball", style "left" (toPx (x - 10)), style "top" (toPx (y - 10)) ] []
      else div [] []
  ]

toPx : Float -> String
toPx n = fromFloat n ++ "px"

addRow : Html ColumnMsg
addRow = div [ class "sb-add-bar" ]
  [ button [ onClick <| AddRow, title "Add row" ] [ text "+" ]
  ]

renderColumn : Model -> Int -> Int -> Column -> Html RowMsg
renderColumn model basis i (Column { form, rows, isTarget } as column) = Html.map (ColumnMsg i) <| div
  [ class "sb-column"
  , class <| "sb-basis-" ++ fromInt basis
  ] <|
    if length rows > 0
      then columnControl column :: indexedMap (renderRow model) rows
      else [ columnControl column, columnGap isTarget ]

columnControl : Column -> Html ColumnMsg
columnControl (Column { form }) = div [ class "sb-column-control" ]
  [ buttonIcon Icons.addBlock "Add block" SelectBlock
  , buttonIcon Icons.edit "Edit column" <| EditColumn form
  , buttonIcon Icons.left "Move left" GoLeft
  , buttonIcon Icons.right "Move right" GoRight
  , buttonIcon Icons.delete "Delete column" DeleteColumn
  ]

renderTopRow : Model -> Int -> Row -> Html ColumnMsg
renderTopRow model i (Row { form, columns }) = Html.map (RowMsg i) <| div [ class "sb-top-block" ]
  [ div [ class "sb-block-head" ]
    [ buttonIcon Icons.addColumn "Add column" AddColumn
    , buttonIcon Icons.edit "Edit row" <| EditRow form
    , buttonIcon Icons.copy "Duplicate" Duplicate
    , buttonIcon Icons.delete "Delete row" Delete
    ]
  , div [ class "sb-columns" ] <| indexedMap (renderColumn model <| 12 // length columns) columns
  ]

columnGap : Bool -> Html ColumnMsg
columnGap isTarget = div [ class "sb-gap" ]
  [ div
    [ class "sb-dropzone"
    , onMouseOver <| ColumnGapMouseOver
    , onMouseOut <| ColumnGapMouseOut
    , onMouseUp <| ColumnGapMouseUp
    ] []
  , div [ class <| if isTarget then "sb-light" else "" ] []
  ]

renderRow : Model -> Int -> Row -> Html ColumnMsg
renderRow model i (Row { isBlock, form, columns, isTarget } as row) = Html.map (RowMsg i) <| div []
  [ div
    [ class "sb-block"
    , onMouseDown <| RowMouseDown row
    , onMouseUp <| RowMouseUp
    ]
    [ rowControl row
    , if isBlock
      then div [ class "sb-body" ]
        [ let (Form name fields) = form in case name of
          "Text" -> toHtmlWith { defaultOptions | sanitize = False } [] <| getStringAt 0 fields 
          _ -> text <| getStringAt 0 fields
        ]
      else div [ class "sb-columns" ] <| indexedMap (renderColumn model <| 12 // length columns) columns
    ]
  , rowGap model isTarget
  ]

rowGap : Model -> Bool -> Html RowMsg
rowGap model isTarget = div [ class "sb-gap" ]
  [ div
    [ class "sb-dropzone"
    , onMouseOver <| GapMouseOver
    , onMouseOut <| GapMouseOut
    , onMouseUp <| GapMouseUp
    ] []
  , div [ class <| if isTarget then "sb-light" else "" ] []
  ]

rowControl : Row -> Html RowMsg
rowControl (Row { isBlock, form } as row) = div [ class "sb-block-head" ]
  [ strong [ class "sb-block-name" ] [ text <| let (Form name _) = form in name ]
  , if isBlock then div [] [] else buttonIcon Icons.addColumn "Add column" AddColumn
  , buttonIcon Icons.edit "Edit block" <| EditRow form
  , buttonIcon Icons.copy "Duplicate" Duplicate
  , buttonIcon Icons.delete "Delete block" Delete
  ]

buttonIcon : Html msg -> String -> msg -> Html msg
buttonIcon icon titleText msg  = button [ class "sb-icon", title titleText, onClick msg ] [ icon ]
