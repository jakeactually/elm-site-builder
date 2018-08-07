module SiteBuilder.Component exposing (..)

import SiteBuilder.Main.Model exposing (Msg)
import Html exposing (Html, button, div, h1, i, text)
import Html.Attributes exposing (class, title, type_)
import Html.Events exposing (onClick)

icon : String -> String -> Msg -> Html Msg
icon text_ title_ msg = button [ type_ "button", class "icon", title title_, onClick msg ]
  [ i [ class "material-icons" ] [ text text_ ]
  ]

modal : String -> List (Html Msg) -> List (Html Msg) -> Html Msg
modal title_ content control =
  div [ class "screen" ]
    [ div [ class "modal" ]
        [ h1 [] [ text title_ ]
        , div [ class "content" ]
        [ div [ class "wrap" ] content
        ]
        , div [ class "buttons" ] control
        ]
    ]
