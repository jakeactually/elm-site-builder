module Builder exposing (..)

import Field.Model exposing (..)
import List exposing (map)
import Schema exposing (..)

type Column = Column
  { props : List Field
  , rows : List Row
  }

newColumn : List Row -> Column
newColumn rows = Column
  { props =
    [ Field "id" <| TextValue ""
    , Field "class" <| TextValue ""
    ]
  , rows = rows
  }

type Row
  = Block
    { name : String
    , fields : List Field
    , dragged : Bool
    }
  | Row 
    { props : List Field
    , dragged : Bool
    , columns : List Column
    }

newRow : List Column -> Row
newRow columns = Row
  { props =
    [ Field "id" <| TextValue ""
    , Field "class" <| TextValue ""
    ]
  , dragged = False
  , columns = columns
  }

rowProps : List Field -> Row
rowProps fields = Block
  { name = "RowProps"
  , fields = fields
  , dragged = False
  }

columnProps : List Field -> Row
columnProps fields = Block
  { name = "ColumnProps"
  , fields = fields
  , dragged = False
  }

makeBlock : String -> List FieldSchema -> Row
makeBlock name fields = Block
  { name = name
  , fields = map makeField fields
  , dragged = False
  }

type ColumnMsg
  = SelectBlock
  | AddBlock Row
  | EditColumn Row
  | DeleteColumn
  | RowMsg Int RowMsg

type RowMsg
  = AddColumn
  | Edit Row
  | Save Row
  | Duplicate
  | GoUp
  | GoDown
  | Delete
  | DragStart Row
  | DragEnd
  | Drop Row
  | NoRowMsg
  | ColumnMsg Int ColumnMsg
