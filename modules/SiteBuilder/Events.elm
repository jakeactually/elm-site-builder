module SiteBuilder.Events exposing (..)

import Json.Decode as Decode
import Html exposing (Attribute)
import Html.Events exposing (on, onWithOptions, defaultOptions)

onDragStart : msg -> Attribute msg
onDragStart msg = on "dragstart" <| Decode.succeed msg

onDragOver : msg -> Attribute msg
onDragOver msg = onWithOptions "dragover" { defaultOptions | preventDefault = True } <| Decode.succeed msg

onDrop : msg -> Attribute msg
onDrop msg = on "drop" <| Decode.succeed msg
