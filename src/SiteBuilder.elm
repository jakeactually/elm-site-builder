module SiteBuilder exposing (main)

import Browser
import Builder exposing (Form(..), ColumnMsg(..))
import Field.Model exposing (Field(..), FieldValue(..))
import Field.Util exposing (..)
import List exposing (length, head)
import Maybe
import Model exposing (..)
import Port exposing (..)
import Update exposing (update)
import Util exposing (get)
import View exposing (view)

main : Program Flags Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , subscriptions = (\{ currentForm,  currentFieldIndex } -> let (Form _ fields) = currentForm in Sub.batch
        [ richTextInput (\(fieldIndex, value) -> ContextMsg <| FieldInput fieldIndex <| RichTextValue value)
        , fileManager (\images -> if length images > 0
            then case Maybe.map (\(Field _ value) -> value) <| get currentFieldIndex fields of
              Just (ImageValue _) -> ContextMsg <| FieldInput currentFieldIndex <| ImageValue <| Maybe.withDefault "" <| head images
              Just (ImagesValue value) -> ContextMsg <| FieldInput currentFieldIndex <| ImagesValue <| value ++ images
              _ -> NoMsg
            else NoMsg
          )
        ]
      )
    , update = update
    }
