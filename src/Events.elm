module Events exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Html exposing (Attribute)
import Html.Events exposing (on, custom)

onDragStart : msg -> Attribute msg
onDragStart message =
  custom "dragstart" <| options True False <| Decode.succeed message

onDragEnd : msg -> Attribute msg
onDragEnd message =
  custom "dragend" <| options True False <| Decode.succeed message

onDragEnter : msg -> Attribute msg
onDragEnter message =
  custom "dragenter" <| options True False <| Decode.succeed message

onDragLeave : msg -> Attribute msg
onDragLeave message =
  custom "dragleave" <| options True False <| Decode.succeed message

onDragOver : msg -> Attribute msg
onDragOver message =
  custom "dragover" <| options True True <| Decode.succeed message

onDrop : msg -> Attribute msg
onDrop message =
  custom "drop" <| options True False <| Decode.succeed message

options : Bool -> Bool -> Decoder msg -> Decoder
  { message : msg
  , stopPropagation : Bool
  , preventDefault : Bool
  }
options stopPropagation preventDefault = Decode.map (\message ->
  { message = message
  , stopPropagation = stopPropagation
  , preventDefault = preventDefault
  })
