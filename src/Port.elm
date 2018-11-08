port module Port exposing (..)

port richTextInput : ((Int, String) -> msg) -> Sub msg
port openFileManager : () -> Cmd msg
port fileManager : (List String -> msg) -> Sub msg
