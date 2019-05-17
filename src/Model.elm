module Model exposing (..)

import Builder exposing (..)
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
  , updater : Result (Form -> ColumnMsg) (Form -> RowMsg)
  , currentColumnMsg : ColumnMsg
  , pointer : ColumnMsg
  , currentRow : Maybe Row
  , currentRowIsTop : Bool
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
  , updater = Ok <| always NoRowMsg
  , currentColumnMsg = NoColumnMsg
  , pointer = NoColumnMsg
  , currentRow = Nothing
  , currentRowIsTop = False
  , currentForm = Form "" []
  , currentFieldIndex = 0
  , start = Vec2 0 0
  , cursor = Vec2 0 0
  , dragging = False
  }

type Msg = ContextMsg ContextMsg | BuilderMsg ColumnMsg | NoMsg

type ContextMsg
  = NewBlock String
  | HideSelectBlockDialog
  | FieldInput Int FieldValue
  | OpenFileManager Int
  | AcceptBlock
  | HideEditBlockDialog
  | RowBlock
  | MouseMove Vec2
  | MouseUp
  | Reset
  | NoContextMsg
