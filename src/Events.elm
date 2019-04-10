module Events exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Html exposing (Attribute)
import Html.Events exposing (on, custom)

onMouseDown : msg -> Attribute msg
onMouseDown = custom "mousedown" << options True False << Decode.succeed

onMouseOver : msg -> Attribute msg
onMouseOver = custom "mouseover" << options True False << Decode.succeed

onMouseOut : msg -> Attribute msg
onMouseOut = custom "mouseout" << options True False << Decode.succeed

onMouseUp : msg -> Attribute msg
onMouseUp = custom "mouseup" << options True False << Decode.succeed

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
