module SiteBuilder.Main.Model exposing (..)

import SiteBuilder.Column.Model exposing (Column, ColumnMsg)
import SiteBuilder.Row.Model exposing (Row, RowMsg)

type alias Flags =
  { data : String
  , thumbService : String
  }

type alias Model =
  { showJson : Bool
  , json : String
  , thumbService : String
  , showAddRowDialog : Bool
  , rows : List Row
  , currentRow : Row
  , currentRowIndex : Int
  , showEditRowDialog : Bool
  , showSelectBuilderDialog : Bool
  , currentColumn : Column
  , currentColumnIndex : Int
  , currentFieldIndex : Int
  , showEditBuilderDialog : Bool
  }

type Msg
  = ToggleJson ()
  | JsonInput String
  | RowMsg RowMsg
  | ColumnMsg ColumnMsg
  | GetData ()
  | None
