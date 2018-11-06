module Update exposing (update)

import Builder exposing (..)
import Dict
import Field.Model exposing (..)
import List exposing (length)
import Maybe exposing (withDefault)
import Model exposing (..)
import Util
import Tuple exposing (pair, second)

update : Msg -> Model -> (Model, Cmd Msg)
update msg (context, column) = case msg of
  BuilderMsg columnMsg ->
    pair (evalColumnMsg columnMsg { context | currentBuilderMsg = columnMsg }, updateColumn columnMsg column) Cmd.none
  ContextMsg contextMsg ->
    pair (updateContext contextMsg context column) Cmd.none

evalColumnMsg : ColumnMsg -> Context -> Context
evalColumnMsg columnMsg context = case columnMsg of
  SelectBlock -> { context | showSelectBlockDialog = True, isNewBlock = True }
  EditColumn row -> case row of 
    Block _ -> { context | showEditBlockDialog = True, currentBlock = row }
    _ -> context
  RowMsg i rowMsg -> evalRowMsg rowMsg context
  _ -> context

evalRowMsg : RowMsg -> Context -> Context
evalRowMsg rowMsg context = case rowMsg of
  Edit row -> case row of
    Block _ -> { context | isNewBlock = False, showEditBlockDialog = True, currentBlock = row }
    Row { props } -> { context | isNewBlock = False, showEditBlockDialog = True, currentBlock = rowProps props }
  ColumnMsg _ columnMsg -> evalColumnMsg columnMsg context
  DragStart block -> { context | currentBlock = block, dragging = True }
  DragEnd -> { context | dragging = False }
  _ -> context

updateColumn : ColumnMsg -> Column -> Column
updateColumn columnMsg (Column column) = case columnMsg of
  AddBlock row -> Column { column | rows = column.rows ++ [ row ] }
  RowMsg i rowMsg -> case rowMsg of
    Save row -> case row of 
      Block { name, fields } -> case name of
        "RowProps" -> Column { column | rows = Util.update (setProps fields) i column.rows }
        "ColumnProps" -> Column { column | props = fields }
        _ -> Column { column | rows = Util.set i row column.rows }
      _ -> Column column
    Duplicate -> Column { column | rows = Util.duplicate i column.rows }
    GoUp -> Column { column | rows = Util.swap i (i - 1) column.rows }
    GoDown -> Column { column | rows = Util.swap i (i + 1) column.rows }
    Delete -> Column { column | rows = Util.remove i column.rows }
    Drop block -> Column { column | rows = Util.set i block column.rows }
    _ -> Column { column | rows = Util.update (updateRow rowMsg) i column.rows }
  _ -> Column column

setProps : List  Field -> Row -> Row
setProps fields row = case row of
  Block _ -> row
  Row rowRecord -> Row { rowRecord | props = fields }

updateRow : RowMsg -> Row -> Row
updateRow rowMsg row = case row of
  Row { columns } -> case rowMsg of
    AddColumn -> if length columns < 4 then newRow <| columns ++ [ newColumn [] ] else row
    ColumnMsg i columnMsg -> case columnMsg of
      DeleteColumn -> newRow <| Util.remove i columns
      _ -> newRow <| Util.update (updateColumn columnMsg) i columns
    _ -> row
  Block block -> case rowMsg of
    DragStart _ -> Block { block | dragged = True }
    DragEnd -> Block { block | dragged = False }
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
  HideSelectBlockDialog -> pair ({ context | showSelectBlockDialog = False }) column
  HideEditBlockDialog -> pair { context | showEditBlockDialog = False } column
  FieldInput i input -> pair { context | currentBlock = updateBlock i input context.currentBlock } column
  NewBlock schemaKey ->
    ( { context
      | showSelectBlockDialog = False
      , showEditBlockDialog = True
      , currentBlock = makeBlock schemaKey <| withDefault [] <| Dict.get schemaKey context.schema
      }
    , column)
  AcceptBlock ->
    let
      newMsg = if context.isNewBlock
        then mapColumnMsg (AddBlock context.currentBlock) context.currentBuilderMsg
        else mapRowMsg (Save context.currentBlock) context.currentBuilderMsg 
    in
      ({ context | showEditBlockDialog = False }, updateColumn newMsg column)
  AddRow -> ({ context | showSelectBlockDialog = False }, updateColumn (mapColumnMsg (AddBlock <| newRow []) context.currentBuilderMsg) column)

updateBlock : Int -> FieldValue -> Row -> Row
updateBlock i value block = case block of
  Block blockRecord -> Block { blockRecord | fields = updateFields i value blockRecord.fields }
  _ -> block

updateFields : Int -> FieldValue -> List Field -> List Field
updateFields i input fields = case Util.get i fields of
  Just field -> Util.set i (updateField input field) fields
  Nothing -> fields

updateField : FieldValue -> Field -> Field
updateField input field = case field of
  Field name _ -> Field name input
