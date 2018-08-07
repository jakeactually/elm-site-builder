module SiteBuilder.Row.Update exposing (..)

import List exposing (take, drop)
import SiteBuilder.Main.Model exposing (Model, Msg)
import SiteBuilder.Util exposing ((!!), remove, set, swap)
import SiteBuilder.Row.Model exposing (..)

handleRowMessage : RowMsg -> Model -> (Model, Cmd Msg)
handleRowMessage msg model = case msg of
  OpenAddRowDialog -> ({ model | showAddRowDialog = True }, Cmd.none)
  CloseAddRowDialog -> ({ model | showAddRowDialog = False }, Cmd.none)
  AddRow columnsAmount -> ({ model | showAddRowDialog = False, rows = model.rows ++ [ newRow columnsAmount ] }, Cmd.none)
  DuplicateRow index ->
    case model.rows !! index of
      Just row -> ({ model | rows = take index model.rows ++ [row] ++ drop index model.rows }, Cmd.none)
      Nothing -> (model, Cmd.none) 
  MoveRowUp index -> ({ model | rows = swap index (index - 1) model.rows }, Cmd.none)
  MoveRowDown index -> ({ model | rows = swap index (index + 1) model.rows }, Cmd.none)
  OpenEditRowDialog index ->
    case model.rows !! index of
      Just row -> ({ model | showEditRowDialog = True, currentRow = row, currentRowIndex = index }, Cmd.none)
      Nothing -> (model, Cmd.none)
  CloseEditRowDialog -> ({ model | showEditRowDialog = False }, Cmd.none)
  RowIdInput input -> ({ model | currentRow = let (Row row) = model.currentRow in Row { row | id_ = input } }, Cmd.none)
  RowClassInput input -> ({ model | currentRow = let (Row row) = model.currentRow in Row { row | class_ = input } }, Cmd.none)
  UpdateRow index -> ({ model | showEditRowDialog = False, rows = set index model.currentRow model.rows }, Cmd.none)
  DeleteRow index -> ({ model | rows = remove index model.rows }, Cmd.none)
