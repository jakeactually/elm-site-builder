module View exposing (view)

import Column exposing (..)
import Debug exposing (toString)
import Dialogs exposing (editBlockDialog, selectBlockDialog)
import Events exposing (..)
import Field.Util exposing (..)
import Field.View exposing (..)
import Html exposing (Html, textarea, button, div, input, map, strong, text)
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
  , onMouseMove <| contextMsg << SetCursor
  , onMouseUp <| contextMsg MouseUp
  ]
  [ div [ class "column" ] <| indexedMap (renderTopRow model) rows ++ [ map columnMsg addRow ]
  , if model.showSelectBlockDialog then selectBlockDialog model.schema else div [] []
  , if model.showEditBlockDialog then editBlockDialog model.currentForm model.thumbnailsUrl else div [] []
  , input [ id "sb-value", type_ "hidden", value <| E.encode 4 <| J.encode model.schema <| model.column ] []
  , if model.dragging
      then
        let (Vec2 x y) = model.cursor
        in div [ class "sb-ball", style "left" (toPx (x - 10)), style "top" (toPx (y - 10)) ] []
      else div [] []
  , div [] [ text <| toString model ]
  ]

columnLayer : Int -> Msg -> Msg
columnLayer i (Msg contextMsg columnMsg) = Msg contextMsg <| RowMsg 0 <| ColumnMsg i columnMsg

rowLayer : Int -> Msg -> Msg
rowLayer i (Msg contextMsg columnMsg) = Msg contextMsg <| case columnMsg of
  RowMsg _ msg -> RowMsg i msg
  _ -> columnMsg

toPx : Float -> String
toPx n = fromFloat n ++ "px"

addRow : Html ColumnMsg
addRow = div [ class "sb-add-bar" ]
  [ button [ onClick <| AddBlock <| Form "Row" [], title "Add row" ] [ text "+" ]
  ]

renderColumn : Model -> Int -> Int -> Column -> Html Msg
renderColumn model basis i (Column { form, rows } as column) = map (columnLayer i) <| div
  [ class "sb-column"
  , class <| "sb-basis-" ++ fromInt basis
  ]
  <| map columnMsg (columnControl column) :: indexedMap (renderRow model) rows

columnControl : Column -> Html ColumnMsg
columnControl (Column { form }) = div [ class "sb-column-control" ]
  [ buttonIcon Icons.addBlock "Add block" SelectBlock
  , buttonIcon Icons.edit "Edit column" <| EditColumn form
  , buttonIcon Icons.left "Move left" GoLeft
  , buttonIcon Icons.right "Move right" GoRight
  , buttonIcon Icons.delete "Delete column" DeleteColumn
  ]

renderTopRow : Model -> Int -> Row -> Html Msg
renderTopRow model i (Row { form, columns }) = map (rowLayer i) <| div [ class "sb-top-block" ]
  [ div [ class "sb-block-head" ]
    [ map rowMsg <| buttonIcon Icons.addColumn "Add column" AddColumn
    , map contextMsg <| buttonIcon Icons.edit "Edit row" <| Edit form
    , map rowMsg <| buttonIcon Icons.copy "Duplicate" Duplicate
    , map rowMsg <| buttonIcon Icons.delete "Delete row" Delete
    ]
  , div [ class "sb-columns" ] <| indexedMap (renderColumn model <| 12 // length columns) columns
  ]

renderRow : Model -> Int -> Row -> Html Msg
renderRow model i (Row { isBlock, form, dragged, columns, isTarget } as row) = map (rowLayer i) <| div []
  [ div
    [ class "sb-block"
    , class <| if model.dragging && dragged then "sb-dragged" else ""
    , onMouseDown <| rowMsg << RowMouseDown row
    , onMouseUp <| rowMsg <| RowMouseUp
    ]
    [ rowControl row
    , if isBlock
      then div []
        [ let (Form name fields) = form in case name of
          "Text" -> toHtmlWith { defaultOptions | sanitize = False } [] <| getStringAt 0 fields 
          _ -> text <| getStringAt 0 fields 
        ]
      else div [ class "sb-columns" ] <| indexedMap (renderColumn model <| 12 // length columns) columns
    ]
  , rowGap model isTarget
  ]

rowGap : Model -> Bool -> Html Msg
rowGap model isTarget = div [ class "sb-gap" ]
  [ div
    [ class "sb-dropzone"
    , onMouseOver <| rowMsg GapMouseOver
    , onMouseOut <| rowMsg GapMouseOut
    , onMouseUp <| case model.currentRow of
        Just r -> rowMsg GapMouseUp
        Nothing -> noMsg
    ] []
  , div [ class <| if isTarget then "sb-light" else "" ] []
  ]

rowControl : Row -> Html Msg
rowControl (Row { isBlock, form } as row) = div [ class "sb-block-head" ]
  [ strong [ class "sb-block-name" ] [ text <| let (Form name _) = form in name ]
  , map rowMsg <| if isBlock then div [] [] else buttonIcon Icons.addColumn "Add column" AddColumn
  , map contextMsg <| buttonIcon Icons.edit "Edit block" <| Edit form
  , map rowMsg <| buttonIcon Icons.copy "Duplicate" Duplicate
  , map rowMsg <| buttonIcon Icons.delete "Delete block" Delete
  ]

buttonIcon : Html msg -> String -> msg -> Html msg
buttonIcon icon titleText msg  = button [ class "sb-icon", title titleText, onClick msg ] [ icon ]
