module Events exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Html exposing (Attribute)
import Html.Events exposing (on, custom)
import Vec exposing (Vec2(..))

onMouseDown : (Vec2 -> msg) -> Attribute msg
onMouseDown function =
  custom "mousedown" <| options True True <| Decode.map2 (\x y -> function <| Vec2 x y)
    (Decode.field "clientX" Decode.float)
    (Decode.field "clientY" Decode.float)

onMouseOver : msg -> Attribute msg
onMouseOver = custom "mouseover" << options True False << Decode.succeed

onMouseOut : msg -> Attribute msg
onMouseOut = custom "mouseout" << options True False << Decode.succeed

onMouseUp : msg -> Attribute msg
onMouseUp = custom "mouseup" << options True False << Decode.succeed

onMouseMove : (Vec2 -> msg) -> Attribute msg
onMouseMove function =
  custom "mousemove" <| options True True <| Decode.map2 (\x y -> function <| Vec2 x y)
    (Decode.field "clientX" Decode.float)
    (Decode.field "clientY" Decode.float)

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
