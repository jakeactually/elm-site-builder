module SiteBuilder exposing (..)

import Html
import List exposing (head, length)
import Maybe exposing (withDefault)
import SiteBuilder.Column.Model exposing (..)
import SiteBuilder.Field.Model exposing (..)
import SiteBuilder.Field.View exposing (getStringListAt, getValue)
import SiteBuilder.Main.Model exposing (..)
import SiteBuilder.Main.Update exposing (..)
import SiteBuilder.Main.View exposing (view)
import SiteBuilder.Port exposing (..)
import SiteBuilder.Row.Model exposing (..)
import SiteBuilder.Util exposing ((!!))

main : Program Flags Model Msg
main = Html.programWithFlags
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

subscriptions : Model -> Sub Msg
subscriptions model = Sub.batch
  [ toggleJson ToggleJson
  , openAddRowDialog <| always <| RowMsg OpenAddRowDialog
  , richTextInput (\(fieldIndex, value) -> ColumnMsg <| FieldInput fieldIndex <| RichTextValue value)
  , fileManagerClosed (\images -> if length images > 0
      then case model.currentColumn of
        Column _ fields -> case Maybe.map getValue <| fields !! model.currentFieldIndex of
          Just (ImageValue _) ->
            ColumnMsg <| FieldInput model.currentFieldIndex <| ImageValue <| withDefault "" <| head images
          Just (ImagesValue _) ->
            ColumnMsg <| FieldInput model.currentFieldIndex <| ImagesValue <| getStringListAt model.currentFieldIndex fields ++ images
          _ ->
            None
        EmptyColumn -> None
      else None
    )
  , getData GetData
  ]
