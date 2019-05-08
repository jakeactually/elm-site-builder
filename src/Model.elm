module Model exposing (..)

import Column exposing (..)
import Dict exposing (empty)
import Json
import Json.Encode
import Json.Decode exposing (decodeValue)
import Field.Model exposing (..)
import List exposing (map)
import Result exposing (withDefault)
import Schema exposing (..)
import Tuple exposing (pair)
import Vec exposing (Vec2(..))

type alias Flags =
  { schema : Json.Decode.Value
  , data : Json.Decode.Value
  , thumbnailsUrl : String
  }

type alias Model =
  { column : Column
  , schema : Schema
  , thumbnailsUrl : String
  , showSelectBlockDialog : Bool
  , showEditBlockDialog : Bool
  , currentColumnMsg : ColumnMsg
  , currentRow : Maybe Row
  , currentForm : Form
  , currentFieldIndex : Int
  , start : Vec2
  , cursor : Vec2
  , dragging : Bool
  }

init : Flags -> (Model, Cmd Msg)
init flags = (initModel flags, Cmd.none)

initModel : Flags -> Model
initModel flags = let decodedSchema = withDefault empty <| decodeValue decodeSchema flags.schema in
  { column = Json.decode decodedSchema flags.data
  , schema = decodedSchema
  , thumbnailsUrl = flags.thumbnailsUrl
  , showSelectBlockDialog = False
  , showEditBlockDialog = False
  , currentColumnMsg = SelectBlock
  , currentRow = Nothing
  , currentForm = Form "" []
  , currentFieldIndex = 0
  , start = Vec2 0 0
  , cursor = Vec2 0 0
  , dragging = False
  }

type Msg = Msg ContextMsg ColumnMsg

contextMsg : ContextMsg -> Msg
contextMsg msg = Msg msg NoColumnMsg

columnMsg : ColumnMsg -> Msg
columnMsg = Msg NoContextMsg

rowMsg : RowMsg -> Msg
rowMsg = Msg NoContextMsg << RowMsg 0

noMsg : Msg
noMsg = Msg NoContextMsg NoColumnMsg

type ContextMsg
  = NewBlock String
  | HideSelectBlockDialog
  | FieldInput Int FieldValue
  | OpenFileManager Int
  | AcceptBlock
  | HideEditBlockDialog
  | RowBlock
  | SetCursor Vec2
  | MouseUp
  | Reset  
  | Edit Form
  | DragStart Row Vec2
  | DeleteCallerRow
  | NoContextMsg
