module SiteBuilder exposing (main)

import Browser
import Field.Model exposing (FieldValue(..))
import Model exposing (..)
import Port exposing (..)
import Update exposing (update)
import View exposing (view)

main : Program Flags Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , subscriptions = always <| Sub.batch
        [ richTextInput (\(fieldIndex, value) -> ContextMsg <| FieldInput fieldIndex <| RichTextValue value)
        ]
    , update = update        
    }
