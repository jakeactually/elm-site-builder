module Update exposing (update)

import Builder exposing (..)
import Dict
import Field.Model exposing (..)
import List exposing (length, map)
import Maybe exposing (withDefault)
import Model exposing (..)
import Port exposing (openFileManager)
import Util
import Tuple exposing (pair, second)

update : Msg -> Model -> (Model, Cmd Msg)
update msg (context, column) = case msg of
  BuilderMsg columnMsg ->
    pair (evalColumnMsg columnMsg { context | currentBuilderMsg = columnMsg }, updateColumn columnMsg <| resetColumn column) Cmd.none
  ContextMsg contextMsg -> case contextMsg of
    OpenFileManager i -> pair ({ context | currentFieldIndex = i }, column) <| openFileManager ()
    _ -> pair (updateContext contextMsg context column) Cmd.none
  NoMsg -> pair (context, column) Cmd.none

resetColumn : Column -> Column
resetColumn (Column column) = Column { column | rows = map resetRow column.rows } 

resetRow :  Row -> Row
resetRow (Row row) = Row { row | dragged = False, isTarget = False, columns = map resetColumn row.columns } 

evalColumnMsg : ColumnMsg -> Context -> Context
evalColumnMsg columnMsg context = case columnMsg of
  SelectBlock -> { context | showSelectBlockDialog = True }
  EditColumn form -> { context | showEditBlockDialog = True, currentForm = form, updater = Err SaveColumn }
  RowMsg _ rowMsg -> evalRowMsg rowMsg context
  _ -> context

evalRowMsg : RowMsg -> Context -> Context
evalRowMsg rowMsg context = case rowMsg of
  Edit form -> { context | showEditBlockDialog = True, currentForm = form, updater = Ok Save }
  DragStart row -> { context | currentRow = Just row }
  Drop _ -> { context | currentRow = Nothing }
  ColumnMsg _ columnMsg -> evalColumnMsg columnMsg context  
  _ -> context

updateColumn : ColumnMsg -> Column -> Column
updateColumn columnMsg (Column column) = Column <| case columnMsg of
  AddBlock form -> { column | rows = column.rows ++ [ setForm form <| setIsBlock True <| newRow ] }
  AddRow -> { column | rows = column.rows ++ [ setColumns [ newColumn ] <| setIsBlock False <| newRow ] }
  SaveColumn form -> { column | form = form }
  RowMsg i rowMsg -> case rowMsg of
    Duplicate -> { column | rows = Util.duplicate i column.rows }
    GoUp -> { column | rows = Util.swap i (i - 1) column.rows }
    GoDown -> { column | rows = Util.swap i (i + 1) column.rows }
    Delete -> { column | rows = Util.remove i column.rows }
    Drop block -> { column | rows = Util.set i block column.rows }
    _ -> { column | rows = Util.update (updateRow rowMsg) i column.rows }
  _ -> column

updateRow : RowMsg -> Row -> Row
updateRow rowMsg (Row row) = Row <| case rowMsg of
  AddColumn -> { row | columns = if length row.columns < 4 then row.columns ++ [ newColumn ] else row.columns }
  Save form  -> { row | form = form }
  DragStart _ -> { row | dragged = True }
  Highlight -> { row | isTarget = True }
  DragEnd -> { row | dragged = False }
  ColumnMsg i columnMsg -> case columnMsg of
    GoLeft -> { row | columns = Util.swap i (i - 1) row.columns }
    GoRight -> { row | columns = Util.swap i (i + 1) row.columns }
    DeleteColumn -> { row | columns = Util.remove i row.columns }
    _ -> { row | columns = Util.update (updateColumn columnMsg) i row.columns }
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

updateContext : ContextMsg -> Context -> Column -> (Context, Column)
updateContext msg context column = case msg of
  HideSelectBlockDialog -> pair { context | showSelectBlockDialog = False } column
  NewBlock schemaKey -> pair
    { context
    | showSelectBlockDialog = False
    , showEditBlockDialog = True
    , currentForm = Form schemaKey <| map makeField <| withDefault [] <| Dict.get schemaKey context.schema
    , updater = Err AddBlock
    }
    column
  FieldInput i input -> pair { context | currentForm = updateBlock i input context.currentForm } column
  HideEditBlockDialog -> pair { context | showEditBlockDialog = False } column
  AcceptBlock -> case context.updater of
    Ok (rowUpdater) -> pair
      { context | showEditBlockDialog = False }
      <| updateColumn (mapRowMsg (rowUpdater context.currentForm) context.currentBuilderMsg) column
    Err (columnUpdater) -> pair
      { context | showEditBlockDialog = False }
      <| updateColumn (mapColumnMsg (columnUpdater context.currentForm) context.currentBuilderMsg) column
  RowBlock -> pair
    { context | showSelectBlockDialog = False }
    <| updateColumn (mapColumnMsg AddRow context.currentBuilderMsg) column
  _ -> (context, column)

updateBlock : Int -> FieldValue -> Form -> Form
updateBlock i value (Form name fields) = Form name <| updateFields i value fields

updateFields : Int -> FieldValue -> List Field -> List Field
updateFields i input fields = case Util.get i fields of
  Just field -> Util.set i (updateField input field) fields
  Nothing -> fields

updateField : FieldValue -> Field -> Field
updateField input field = case field of
  Field name _ -> Field name input
