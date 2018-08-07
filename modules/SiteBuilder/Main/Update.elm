module SiteBuilder.Main.Update exposing (..)

import SiteBuilder.Column.Model exposing (..)
import SiteBuilder.Column.Update exposing (handleColumnMessage)
import SiteBuilder.Json exposing (decode, encode, maybeDecode)
import SiteBuilder.Main.Model exposing (..)
import SiteBuilder.Port exposing (openFileManager, dataSent)
import SiteBuilder.Row.Model exposing (RowMsg, newRow)
import SiteBuilder.Row.Update exposing (handleRowMessage)

init : Flags -> (Model, Cmd Msg)
init { data, thumbService } = (,)
  { showJson = False
  , json = ""
  , thumbService = thumbService
  , showAddRowDialog = False
  , rows = decode data
  , currentRow = newRow 1
  , currentRowIndex = 0
  , showEditRowDialog = False
  , showSelectBuilderDialog = False
  , currentColumn = EmptyColumn
  , currentColumnIndex = 0
  , currentFieldIndex = 0
  , showEditBuilderDialog = False
  }
  Cmd.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
  ToggleJson () ->
    ( if model.showJson
      then { model | showJson = False, rows = Maybe.withDefault model.rows <| maybeDecode model.json }
      else { model | showJson = True, json = encode model.rows }
    , Cmd.none
    )
  JsonInput input -> ({ model | json = input }, Cmd.none)
  RowMsg msg -> handleRowMessage msg model
  ColumnMsg msg -> handleColumnMessage msg model
  GetData () -> (model, dataSent <| encode model.rows)
  None -> (model, Cmd.none)
