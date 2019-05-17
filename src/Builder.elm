module Builder exposing (..)

import Field.Model exposing (..)
import List exposing (map)
import Schema exposing (..)
import Vec exposing (Vec2(..))

type Column = Column
  { form : Form
  , rows : List Row
  , isTarget : Bool
  }

newColumn : Column
newColumn = Column
  { form = columnForm
  , rows = []
  , isTarget = False
  }

columnForm : Form
columnForm = Form "Column"
  [ Field "id" <| TextValue ""
  , Field "class" <| TextValue ""
  ]

type Row = Row
  { isBlock : Bool
  , form : Form
  , columns : List Column
  , isTarget : Bool
  }

setIsBlock : Bool -> Row -> Row
setIsBlock isBlock (Row row) = Row { row | isBlock = isBlock }

setForm : Form -> Row -> Row
setForm form (Row row) = Row { row | form = form }

setColumns : List Column -> Row -> Row
setColumns columns (Row row) = Row { row | columns = columns }

type Form = Form String (List Field)

newRow : Row
newRow = Row
  { isBlock = False
  , form = rowForm
  , columns = []
  , isTarget = False
  }

rowForm : Form
rowForm = Form "Row"
  [ Field "id" <| TextValue ""
  , Field "class" <| TextValue ""
  ]

type ColumnMsg
  = SelectBlock
  | AddBlock Form
  | AddRow
  | EditColumn Form
  | SaveColumn Form
  | GoLeft
  | GoRight
  | DeleteColumn  
  | ColumnGapMouseOver Bool
  | ColumnGapMouseOut
  | ColumnGapMouseUp
  | NoColumnMsg
  | RowMsg Int RowMsg

type RowMsg
  = AddColumn
  | Save Form
  | EditRow Form
  | Duplicate
  | Delete
  | RowMouseDown Row Bool Vec2
  | RowMouseUp
  | GapMouseOver Bool
  | GapMouseOut
  | GapMouseUp
  | NoRowMsg
  | ColumnMsg Int ColumnMsg
