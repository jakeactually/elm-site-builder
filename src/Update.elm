module Update exposing (update)

import Builder exposing (..)
import Dict
import Field.Model exposing (..)
import List exposing (length, map)
import Maybe exposing (withDefault)
import Model exposing (..)
import Port exposing (openFileManager)
import Util exposing (isJust)
import Tuple exposing (pair, second)
import Schema exposing (Schema)
import Vec exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
  ContextMsg contextMsg -> case contextMsg of
    OpenFileManager index -> pair { model | currentFieldIndex = index } <| openFileManager ()
    _ ->  (updateContext contextMsg model, Cmd.none)
  BuilderMsg columnMsg ->
    let newModel = evalColumnMsg columnMsg { model | currentColumnMsg = columnMsg }
    in pair { newModel | column = updateColumn model columnMsg newModel.column } Cmd.none
  NoMsg -> (model, Cmd.none)

evalColumnMsg : ColumnMsg -> Model -> Model
evalColumnMsg columnMsg model = case columnMsg of
  SelectBlock -> { model | showSelectBlockDialog = True, pointer = model.currentColumnMsg }
  EditColumn form -> edit form (Err SaveColumn) model
  ColumnGapMouseUp -> { model | currentRow = Nothing, dragging = False }
  RowMsg _ rowMsg -> evalRowMsg rowMsg model
  _ -> model

evalRowMsg : RowMsg -> Model -> Model
evalRowMsg rowMsg model = case rowMsg of
  EditRow form -> edit form (Ok Save) model
  GapMouseUp -> reset model
  RowMouseDown row isTop position ->
    { model
    | currentRow = Just row
    , currentRowIsTop = isTop
    , pointer = model.currentColumnMsg
    , start = position
    }
  RowMouseUp -> reset model
  ColumnMsg _ columnMsg -> evalColumnMsg columnMsg model
  _ -> model

edit : Form -> Result (Form -> ColumnMsg) (Form -> RowMsg) -> Model -> Model
edit form updater model =
  { model
  | showSelectBlockDialog = False
  , showEditBlockDialog = True
  , currentForm = form    
  , updater = updater
  , pointer = model.currentColumnMsg
  }

updateColumn : Model -> ColumnMsg -> Column -> Column
updateColumn model columnMsg (Column column) = Column <| case columnMsg of
  AddBlock form -> { column | rows = column.rows ++ [ setForm form <| setIsBlock True <| newRow ] }
  AddRow -> { column | rows = column.rows ++ [ setColumns [ newColumn ] <| setIsBlock False <| newRow ] }
  SaveColumn form -> { column | form = form }
  ColumnGapMouseOver isTop -> { column | isTarget = canBeTarget isTop model }
  ColumnGapMouseOut -> { column | isTarget = False }
  ColumnGapMouseUp -> { column | isTarget = False , rows = Util.maybeToList model.currentRow ++ column.rows }
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
  GapMouseOver isTop -> { row | isTarget = canBeTarget isTop model }
  GapMouseOut -> { row | isTarget = False }
  ColumnMsg i columnMsg -> case columnMsg of
    GoLeft -> { row | columns = Util.swap i (i - 1) row.columns }
    GoRight -> { row | columns = Util.swap i (i + 1) row.columns }
    DeleteColumn -> { row | columns = Util.remove i row.columns }
    _ -> { row | columns = Util.update (updateColumn model columnMsg) i row.columns }
  _ -> row

canBeTarget : Bool -> Model -> Bool
canBeTarget isTopGap model = case model.currentRow of
    -- Design choice for simplicity
    -- Top levels rows can only interact with top level gaps
    -- And low level blocks can only interact with low level gaps
    Just (Row row) -> model.currentRowIsTop == isTopGap
    _ -> False

reset : Model -> Model
reset model =
  { model
  | column = resetColumn (\(Row row) -> Row { row | isTarget = False }) model.column
  , currentRow = Nothing
  , dragging = False
  }

resetColumn : (Row -> Row) -> Column -> Column
resetColumn f (Column column) = Column { column | rows = map (resetRow f) column.rows } 

resetRow : (Row -> Row) -> Row -> Row
resetRow f (Row row) = f <| Row { row | columns = map (resetColumn f) row.columns }

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
  NewBlock schemaKey -> edit (newForm model.schema schemaKey) (Err AddBlock) model
  FieldInput i input -> { model | currentForm = updateBlock i input model.currentForm }
  HideEditBlockDialog -> { model | showEditBlockDialog = False }
  AcceptBlock ->
    { model
    | showEditBlockDialog = False
    , column = case model.updater of
        Ok rowUpdater -> pushRowMsg rowUpdater model
        Err columnUpdater -> pushColumnMsg columnUpdater model
    }
  RowBlock ->
    { model
    | showSelectBlockDialog = False
    , column = pushColumnMsg (always AddRow) model
    }
  MouseMove position -> let newDragging = isJust model.currentRow && isFar model.start position in
    { model
    | cursor = position
    , dragging = newDragging
    -- Only when dragging starts, delete the dragged row
    , column = if not model.dragging && newDragging
        then pushRowMsg (always Delete) model
        else model.column
    }
  MouseUp -> reset model
  _ -> model

pushColumnMsg : (Form -> ColumnMsg) -> Model -> Column
pushColumnMsg columnUpdater model =
  updateColumn model (mapColumnMsg (columnUpdater model.currentForm) model.pointer) model.column

pushRowMsg : (Form -> RowMsg) -> Model -> Column
pushRowMsg rowUpdater model =
  updateColumn model (mapRowMsg (rowUpdater model.currentForm) model.pointer) model.column

newForm : Schema -> String -> Form
newForm schema schemaKey = Form schemaKey <| map makeField <| withDefault [] <| Dict.get schemaKey schema

updateBlock : Int -> FieldValue -> Form -> Form
updateBlock i value (Form name fields) = Form name <| Util.update (updateField value) i fields

updateField : FieldValue -> Field -> Field
updateField input (Field name _) = Field name input
