module Builder exposing (..)

import Field.Model exposing (..)
import List exposing (map)
import Schema exposing (..)

type Column = Column
  { form : Form
  , rows : List Row
  }

newColumn : Column
newColumn = Column
  { form = columnForm
  , rows = []
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
  , dragged : Bool
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
  , dragged = False
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
  | RowMsg Int RowMsg

type RowMsg
  = AddColumn
  | Edit Form
  | Save Form
  | Duplicate
  | GoUp
  | GoDown
  | Delete
  | DragStart Row
  | DragEnd
  | Drop Row
  | NoRowMsg
  | ColumnMsg Int ColumnMsg
