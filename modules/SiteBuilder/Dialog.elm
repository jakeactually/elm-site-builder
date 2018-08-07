module SiteBuilder.Dialog exposing (..)

import SiteBuilder.Column.Model exposing (..)
import SiteBuilder.Column.View exposing (renderWidget)
import SiteBuilder.Component exposing (modal)
import SiteBuilder.Field.Model exposing (..)
import SiteBuilder.Field.View exposing (renderField)
import Html exposing (Html, button, div, input, img, label, strong, text)
import Html.Attributes exposing (class, id, src, type_, value)
import Html.Events exposing (onClick, onInput)
import List exposing (any, indexedMap, map, range)
import SiteBuilder.Main.Model exposing (..)
import SiteBuilder.Row.Model exposing (..)

addRowDialog : Html Msg
addRowDialog = modal
  "Añadir fila"

  [ strong [] [ text "Número de columnas"]
  , div [ class "button-group" ] <| map toButton <| range 1 4
  ]

  [ button [ type_ "button", class "alert right", onClick (RowMsg CloseAddRowDialog) ] [ text "Cancelar" ]
  ]

toButton : Int -> Html Msg
toButton i = button [ type_ "button", onClick <| RowMsg <| AddRow i ] [ text <| toString i ]

editRowDialog : Int -> Row -> Html Msg
editRowDialog index (Row { id_, class_ }) = modal
  "Editar fila"

  [ label []
    [ div [ class "name" ] [ text "Id"]
    , input [ type_ "text", value id_, onInput <| RowMsg << RowIdInput ] []
    ]
  , label []
    [ div [ class "name" ] [ text "Class"]
    , input [ type_ "text", value class_, onInput <| RowMsg << RowClassInput ] []
    ]
  ]

  [ button [ type_ "button", class "alert right", onClick <| RowMsg CloseEditRowDialog ] [ text "Cancelar" ]
  , button [ type_ "button", onClick <| RowMsg <| UpdateRow index ] [ text "Aceptar" ]
  ]

selectColumnDialog : Html Msg
selectColumnDialog = modal
  "Seleccionar widget"

  [ div [ id "widgets", class "grid4" ] <| map renderWidget columns
  ]

  [ button [ type_ "button", class "alert", onClick <| ColumnMsg CloseSelectColumnDialog ] [ text "Cancelar" ]
  ]

editColumnDialog : String -> Column -> Html Msg
editColumnDialog thumbService column = case column of
  Column type_ fields -> renderCurrentColumn thumbService type_ fields
  EmptyColumn -> div [] []

renderCurrentColumn : String -> ColumnType -> List Field -> Html Msg
renderCurrentColumn thumbService columnType fields  = modal
  (typeToName columnType)

  (indexedMap (renderField thumbService) fields)

  [ button [ type_ "button", class "alert right", onClick <| ColumnMsg CloseEditColumnDialog ] [ text "Cancelar" ]
  , button [ type_ "button", onClick <| ColumnMsg AssignColumn ] [ text "Aceptar" ]
  ]
