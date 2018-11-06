module Model exposing (..)

import Builder exposing (..)
import Dict
import Json
import Json.Encode
import Json.Decode
import Field.Model exposing (..)
import List exposing (map)
import Result
import Schema exposing (..)

type alias Flags =
  { schema : Json.Decode.Value
  , data : String
  }

type alias Model = (Context, Column)

type alias Context =
  { schema : Schema
  , isNewBlock : Bool
  , showSelectBlockDialog : Bool
  , showEditBlockDialog : Bool
  , currentBuilderMsg : ColumnMsg
  , currentBlock : Row
  , dragging : Bool
  }

init : Flags -> (Model, Cmd Msg)
init flags = (initModel flags, Cmd.none)

initModel : Flags -> Model
initModel flags = let schema = Result.withDefault Dict.empty <| Json.Decode.decodeValue decodeSchema flags.schema in
  ({ schema = schema
  , isNewBlock = False
  , showSelectBlockDialog = False
  , showEditBlockDialog = False
  , currentBuilderMsg = SelectBlock
  , currentBlock = newRow []
  , dragging = False
  }
  , Json.decode schema flags.data
  )

type Msg
  = BuilderMsg ColumnMsg
  | ContextMsg ContextMsg

type ContextMsg
  = NewBlock String
  | HideSelectBlockDialog
  | FieldInput Int FieldValue
  | AcceptBlock
  | HideEditBlockDialog
  | AddRow
