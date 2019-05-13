module Update exposing (update)

import Column exposing (..)
import Dict
import Field.Model exposing (..)
import List exposing (length, map)
import Maybe exposing (withDefault)
import Model exposing (..)
import Port exposing (openFileManager)
import Util exposing (isJust)
import Tuple exposing (pair, second)
import Vec exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update (Msg contextMsg columnMsg) model =
  let newModel = evalColumnMsg columnMsg <| updateContext contextMsg model
  in pair
    { newModel
    | currentColumnMsg = columnMsg
    , column = updateColumn model columnMsg newModel.column
    } Cmd.none

evalColumnMsg : ColumnMsg -> Model -> Model
evalColumnMsg columnMsg model = case columnMsg of
  SelectBlock -> { model | showSelectBlockDialog = True }
  EditColumn form -> { model | showEditBlockDialog = True, currentForm = form }
  RowMsg _ rowMsg -> evalRowMsg rowMsg model
  _ -> model

evalRowMsg : RowMsg -> Model -> Model
evalRowMsg rowMsg model = case rowMsg of
  GapMouseUp ->
    { model
    | currentRow = Nothing
    , dragging = False
    , column = resetColumn (\(Row row) -> Row { row | dragged = False }) model.column
    }
  RowMouseDown row position -> { model | currentRow = Just row, start = position }
  RowMouseUp ->
    { model |
    column = resetColumn (\(Row row) -> Row { row | dragged = False }) model.column
    }
  ColumnMsg _ columnMsg -> evalColumnMsg columnMsg model
  _ -> model

resetColumn : (Row -> Row) -> Column -> Column
resetColumn f (Column column) = Column { column | rows = map (resetRow f) column.rows } 

resetRow : (Row -> Row) -> Row -> Row
resetRow f (Row row) = f <| Row { row | columns = map (resetColumn f) row.columns }

updateColumn : Model -> ColumnMsg -> Column -> Column
updateColumn model columnMsg (Column column) = Column <| case columnMsg of
  AddBlock form -> { column | rows = column.rows ++ [ setForm form <| setIsBlock True <| newRow ] }
  AddRow -> { column | rows = column.rows ++ [ setColumns [ newColumn ] <| setIsBlock False <| newRow ] }
  SaveColumn form -> { column | form = form }
  RowMsg i rowMsg -> case rowMsg of
    Duplicate -> { column | rows = Util.duplicate i column.rows }
    Delete -> { column | rows = Util.remove i column.rows }
    GapMouseUp -> case model.currentRow of
      Just row -> { column | rows = Util.insert (i + 1) row column.rows }
      Nothing -> column
    _ -> { column | rows = Util.update (updateRow model rowMsg) i column.rows }
  _ -> column

updateRow : Model -> RowMsg -> Row -> Row
updateRow model rowMsg (Row row) = Row <| case rowMsg of
  AddColumn -> { row | columns = if length row.columns < 4 then row.columns ++ [ newColumn ] else row.columns }
  Save form  -> { row | form = form }
  RowMouseDown _ _ -> { row | dragged = True }
  GapMouseOver -> { row | isTarget = True }
  GapMouseOut -> { row | isTarget = False }
  ColumnMsg i columnMsg -> case columnMsg of
    GoLeft -> { row | columns = Util.swap i (i - 1) row.columns }
    GoRight -> { row | columns = Util.swap i (i + 1) row.columns }
    DeleteColumn -> { row | columns = Util.remove i row.columns }
    _ -> { row | columns = Util.update (updateColumn model columnMsg) i row.columns }
  _ -> row

mapColumnMsg : ColumnMsg -> ColumnMsg -> ColumnMsg
mapColumnMsg newMsg columnMsg = case columnMsg of
  RowMsg i rowMsg -> RowMsg i <| case rowMsg of
    ColumnMsg j columnMsg_ -> ColumnMsg j <| mapColumnMsg newMsg columnMsg_
    _ -> rowMsg
  _ -> newMsg

mapRowMsg : RowMsg -> ColumnMsg -> ColumnMsg
mapRowMsg newMsg columnMsg = case columnMsg of
  RowMsg i rowMsg -> RowMsg i <| case rowMsg of
    ColumnMsg j columnMsg_ -> ColumnMsg j <| mapRowMsg newMsg columnMsg_
    _ -> newMsg
  _ -> columnMsg

updateContext : ContextMsg -> Model -> Model
updateContext msg model = case msg of
  HideSelectBlockDialog -> { model | showSelectBlockDialog = False }
  NewBlock schemaKey ->
    { model
    | showSelectBlockDialog = False
    , showEditBlockDialog = True
    , currentForm = Form schemaKey <| map makeField <| withDefault [] <| Dict.get schemaKey model.schema
    }
  FieldInput i input -> { model | currentForm = updateBlock i input model.currentForm }
  HideEditBlockDialog -> { model | showEditBlockDialog = False }
  AcceptBlock ->
      { model
      | showEditBlockDialog = False
      , column = updateColumn model (mapColumnMsg AddRow model.currentColumnMsg) model.column
      }
  RowBlock ->
    { model
    | showSelectBlockDialog = False
    , column = updateColumn model (mapColumnMsg AddRow model.currentColumnMsg) model.column
    }
  SetCursor position ->
    { model
    | cursor = position
    , dragging = isJust model.currentRow && isFar model.start position
    }
  Edit form -> { model | showEditBlockDialog = True, currentForm = form }
  MouseUp -> { model | currentRow = Nothing, dragging = False, column = newColumn }
  DeleteCallerRow -> { model | column = updateColumn model (mapRowMsg Delete model.currentColumnMsg) model.column }
  _ -> model

updateBlock : Int -> FieldValue -> Form -> Form
updateBlock i value (Form name fields) = Form name <| Util.update (updateField value) i fields

updateField : FieldValue -> Field -> Field
updateField input (Field name _) = Field name input
