module SiteBuilder.Row.Model exposing (..)

import SiteBuilder.Column.Model exposing (..)
import List exposing (repeat)

type Row = Row
  { id_: String
  , class_: String
  , columns: List Column
  }

type RowMsg
  =  OpenAddRowDialog
  | CloseAddRowDialog
  | AddRow Int
  | DuplicateRow Int
  | MoveRowUp Int
  | MoveRowDown Int
  | OpenEditRowDialog Int
  | CloseEditRowDialog
  | RowIdInput String
  | RowClassInput String
  | UpdateRow Int
  | DeleteRow Int

newRow : Int -> Row
newRow columnsAmount = Row { id_ = "", class_ = "", columns = repeat columnsAmount EmptyColumn }
