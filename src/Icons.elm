module Icons exposing (..)

import Html exposing (Html, button)
import Html.Attributes exposing (attribute, title)
import Html.Events exposing (onClick)
import Svg exposing (path, svg)
import Svg.Attributes exposing (class, d, fill, viewBox)

add : String -> msg -> Html msg
add titleText msg = button [ class "sb-icon", title titleText, onClick msg ]
    [ svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-plus fa-w-14", attribute "data-icon" "plus", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 448 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
        [ path [ d "M416 208H272V64c0-17.67-14.33-32-32-32h-32c-17.67 0-32 14.33-32 32v144H32c-17.67 0-32 14.33-32 32v32c0 17.67 14.33 32 32 32h144v144c0 17.67 14.33 32 32 32h32c17.67 0 32-14.33 32-32V304h144c17.67 0 32-14.33 32-32v-32c0-17.67-14.33-32-32-32z", fill "currentColor" ]
            []
        ]
    ]

edit : String -> msg -> Html msg
edit titleText msg  = button [ class "sb-icon", title titleText, onClick msg ]
    [ svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-edit fa-w-18", attribute "data-icon" "edit", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 576 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
        [ path [ d "M402.6 83.2l90.2 90.2c3.8 3.8 3.8 10 0 13.8L274.4 405.6l-92.8 10.3c-12.4 1.4-22.9-9.1-21.5-21.5l10.3-92.8L388.8 83.2c3.8-3.8 10-3.8 13.8 0zm162-22.9l-48.8-48.8c-15.2-15.2-39.9-15.2-55.2 0l-35.4 35.4c-3.8 3.8-3.8 10 0 13.8l90.2 90.2c3.8 3.8 10 3.8 13.8 0l35.4-35.4c15.2-15.3 15.2-40 0-55.2zM384 346.2V448H64V128h229.8c3.2 0 6.2-1.3 8.5-3.5l40-40c7.6-7.6 2.2-20.5-8.5-20.5H48C21.5 64 0 85.5 0 112v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V306.2c0-10.7-12.9-16-20.5-8.5l-40 40c-2.2 2.3-3.5 5.3-3.5 8.5z", fill "currentColor" ]
            []
        ]
    ]

copy : String -> msg -> Html msg
copy titleText msg  = button [ class "sb-icon", title titleText, onClick msg ]
    [ svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-copy fa-w-14", attribute "data-icon" "copy", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 448 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
        [ path [ d "M320 448v40c0 13.255-10.745 24-24 24H24c-13.255 0-24-10.745-24-24V120c0-13.255 10.745-24 24-24h72v296c0 30.879 25.121 56 56 56h168zm0-344V0H152c-13.255 0-24 10.745-24 24v368c0 13.255 10.745 24 24 24h272c13.255 0 24-10.745 24-24V128H344c-13.2 0-24-10.8-24-24zm120.971-31.029L375.029 7.029A24 24 0 0 0 358.059 0H352v96h96v-6.059a24 24 0 0 0-7.029-16.97z", fill "currentColor" ]
            []
        ]
    ]

delete : String -> msg -> Html msg
delete titleText msg  = button [ class "sb-icon", title titleText, onClick msg ]
    [ svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-trash fa-w-14", attribute "data-icon" "trash", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 448 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
        [ path [ d "M0 84V56c0-13.3 10.7-24 24-24h112l9.4-18.7c4-8.2 12.3-13.3 21.4-13.3h114.3c9.1 0 17.4 5.1 21.5 13.3L312 32h112c13.3 0 24 10.7 24 24v28c0 6.6-5.4 12-12 12H12C5.4 96 0 90.6 0 84zm415.2 56.7L394.8 467c-1.6 25.3-22.6 45-47.9 45H101.1c-25.3 0-46.3-19.7-47.9-45L32.8 140.7c-.4-6.9 5.1-12.7 12-12.7h358.5c6.8 0 12.3 5.8 11.9 12.7z", fill "currentColor" ]
            []
        ]
    ]

up : String -> msg -> Html msg
up titleText msg  = button [ class "sb-icon", title titleText, onClick msg ]
    [ svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-chevron-up fa-w-14", attribute "data-icon" "chevron-up", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 448 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
        [ path [ d "M240.971 130.524l194.343 194.343c9.373 9.373 9.373 24.569 0 33.941l-22.667 22.667c-9.357 9.357-24.522 9.375-33.901.04L224 227.495 69.255 381.516c-9.379 9.335-24.544 9.317-33.901-.04l-22.667-22.667c-9.373-9.373-9.373-24.569 0-33.941L207.03 130.525c9.372-9.373 24.568-9.373 33.941-.001z", fill "currentColor" ]
            []
        ]
    ]

down : String -> msg -> Html msg
down titleText msg  = button [ class "sb-icon", title titleText, onClick msg ]
    [ svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-chevron-down fa-w-14", attribute "data-icon" "chevron-down", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 448 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
        [ path [ d "M207.029 381.476L12.686 187.132c-9.373-9.373-9.373-24.569 0-33.941l22.667-22.667c9.357-9.357 24.522-9.375 33.901-.04L224 284.505l154.745-154.021c9.379-9.335 24.544-9.317 33.901.04l22.667 22.667c9.373 9.373 9.373 24.569 0 33.941L240.971 381.476c-9.373 9.372-24.569 9.372-33.942 0z", fill "currentColor" ]
            []
        ]
    ]
