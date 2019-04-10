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

type alias Flags =
  { schema : Json.Decode.Value
  , data : Json.Decode.Value
  , thumbnailsUrl : String
  }

type alias Model = (Context, Column)

type alias Context =
  { schema : Schema
  , thumbnailsUrl : String
  , showSelectBlockDialog : Bool
  , showEditBlockDialog : Bool
  , currentBuilderMsg : ColumnMsg
  , updater : Result (Form -> ColumnMsg) (Form -> RowMsg)
  , currentRow : Maybe Row
  , currentForm : Form
  , currentFieldIndex : Int
  }

init : Flags -> (Model, Cmd Msg)
init flags = (initModel flags, Cmd.none)

initModel : Flags -> Model
initModel flags = let decodedSchema = withDefault empty <| decodeValue decodeSchema flags.schema in pair
  { schema = decodedSchema
  , thumbnailsUrl = flags.thumbnailsUrl
  , showSelectBlockDialog = False
  , showEditBlockDialog = False
  , currentBuilderMsg = SelectBlock
  , updater = Ok (always NoRowMsg)
  , currentRow = Nothing
  , currentForm = Form "" []
  , currentFieldIndex = 0
  }
  <| Json.decode decodedSchema flags.data

type Msg
  = BuilderMsg ColumnMsg
  | ContextMsg ContextMsg
  | NoMsg

type ContextMsg
  = NewBlock String
  | HideSelectBlockDialog
  | FieldInput Int FieldValue
  | OpenFileManager Int
  | AcceptBlock
  | HideEditBlockDialog
  | RowBlock
  | NoContextMsg
