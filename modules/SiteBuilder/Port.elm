port module SiteBuilder.Port exposing (..)

port toggleJson : (() -> msg) -> Sub msg

port openAddRowDialog : (() -> msg) -> Sub msg

port richTextInput : ((Int, String) -> msg) -> Sub msg

port openFileManager : () -> Cmd msg
port fileManagerClosed : (List String -> msg) -> Sub msg

port getData : (() -> msg) -> Sub msg
port dataSent : String -> Cmd msg
