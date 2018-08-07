module SiteBuilder.Column.Update exposing (..)

import SiteBuilder.Main.Model exposing (Model, Msg)
import SiteBuilder.Column.Model exposing (..)
import SiteBuilder.Field.Model exposing (..)
import SiteBuilder.Field.Update exposing (updateFields)
import SiteBuilder.Port exposing (openFileManager)
import SiteBuilder.Row.Model exposing (..)
import SiteBuilder.Util exposing ((!!), set)

handleColumnMessage : ColumnMsg -> Model -> (Model, Cmd Msg)
handleColumnMessage msg model = case msg of
  OpenSelectColumnDialog i j -> ({ model | showSelectBuilderDialog = True, currentRowIndex = i, currentColumnIndex = j }, Cmd.none)
  CloseSelectColumnDialog -> ({ model | showSelectBuilderDialog = False }, Cmd.none)
  NewColumn column -> ({ model | showSelectBuilderDialog = False, showEditBuilderDialog = True, currentColumn = column }, Cmd.none)
  OpenEditColumnDialog i j ->
    case getColumn i j model.rows of
      Just column -> ({ model | showEditBuilderDialog = True, currentRowIndex = i, currentColumnIndex = j, currentColumn = column }, Cmd.none)
      Nothing -> (model, Cmd.none)
  FieldInput i input -> ({ model | showEditBuilderDialog = True, currentColumn = updateColumn i input model.currentColumn }, Cmd.none)
  OpenFileManager fieldIndex -> ({ model | currentFieldIndex = fieldIndex }, openFileManager ())
  CloseEditColumnDialog -> ({ model | showEditBuilderDialog = False }, Cmd.none)
  AssignColumn -> ({ model | showEditBuilderDialog = False, rows = assingColumn model.currentRowIndex model.currentColumnIndex model.currentColumn model.rows }, Cmd.none)
  DeleteColumn i j -> ({ model | rows = removeColumn i j model.rows }, Cmd.none)
  Drag column -> ({ model | currentColumn = column }, Cmd.none)
  Drop i j -> ({ model | rows = assingColumn i j model.currentColumn model.rows, currentColumn = EmptyColumn }, Cmd.none)

getColumn : Int -> Int -> List Row -> Maybe Column
getColumn i j rows = case rows !! i of
  Just (Row { columns }) -> columns !! j
  Nothing -> Nothing

updateColumn : Int -> FieldValue -> Column -> Column
updateColumn i input column = case column of
  Column type_ fields -> Column type_ <| updateFields i input fields
  EmptyColumn -> EmptyColumn

assingColumn : Int -> Int -> Column -> List Row -> List Row
assingColumn i j column rows = case rows !! i of
  Just (Row row)  -> set i (Row { row | columns = set j column row.columns }) rows
  Nothing -> rows

removeColumn : Int -> Int -> List Row -> List Row
removeColumn i j rows = case rows !! i of
  Just (Row row)  -> set i (Row { row | columns = set j EmptyColumn row.columns }) rows
  Nothing -> rows
