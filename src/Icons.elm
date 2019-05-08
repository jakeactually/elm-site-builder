module Icons exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Svg exposing (path, svg)
import Svg.Attributes exposing (class, d, fill, viewBox)

add : Html msg
add = svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-plus fa-w-14", attribute "data-icon" "plus", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 448 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
  [ path [ d "M416 208H272V64c0-17.67-14.33-32-32-32h-32c-17.67 0-32 14.33-32 32v144H32c-17.67 0-32 14.33-32 32v32c0 17.67 14.33 32 32 32h144v144c0 17.67 14.33 32 32 32h32c17.67 0 32-14.33 32-32V304h144c17.67 0 32-14.33 32-32v-32c0-17.67-14.33-32-32-32z", fill "currentColor" ]
    []
  ]

edit : Html msg
edit = svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-edit fa-w-18", attribute "data-icon" "edit", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 576 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
  [ path [ d "M402.6 83.2l90.2 90.2c3.8 3.8 3.8 10 0 13.8L274.4 405.6l-92.8 10.3c-12.4 1.4-22.9-9.1-21.5-21.5l10.3-92.8L388.8 83.2c3.8-3.8 10-3.8 13.8 0zm162-22.9l-48.8-48.8c-15.2-15.2-39.9-15.2-55.2 0l-35.4 35.4c-3.8 3.8-3.8 10 0 13.8l90.2 90.2c3.8 3.8 10 3.8 13.8 0l35.4-35.4c15.2-15.3 15.2-40 0-55.2zM384 346.2V448H64V128h229.8c3.2 0 6.2-1.3 8.5-3.5l40-40c7.6-7.6 2.2-20.5-8.5-20.5H48C21.5 64 0 85.5 0 112v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V306.2c0-10.7-12.9-16-20.5-8.5l-40 40c-2.2 2.3-3.5 5.3-3.5 8.5z", fill "currentColor" ]
    []
  ]

copy : Html msg
copy  = svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-clone fa-w-16", attribute "data-icon" "clone", attribute "data-prefix" "far", attribute "role" "img", viewBox "0 0 512 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
  [ path [ d "M464 0H144c-26.51 0-48 21.49-48 48v48H48c-26.51 0-48 21.49-48 48v320c0 26.51 21.49 48 48 48h320c26.51 0 48-21.49 48-48v-48h48c26.51 0 48-21.49 48-48V48c0-26.51-21.49-48-48-48zM362 464H54a6 6 0 0 1-6-6V150a6 6 0 0 1 6-6h42v224c0 26.51 21.49 48 48 48h224v42a6 6 0 0 1-6 6zm96-96H150a6 6 0 0 1-6-6V54a6 6 0 0 1 6-6h308a6 6 0 0 1 6 6v308a6 6 0 0 1-6 6z", fill "currentColor" ]
    []
  ]

delete : Html msg
delete  = svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-trash-alt fa-w-14", attribute "data-icon" "trash-alt", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 448 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
  [ path [ d "M0 84V56c0-13.3 10.7-24 24-24h112l9.4-18.7c4-8.2 12.3-13.3 21.4-13.3h114.3c9.1 0 17.4 5.1 21.5 13.3L312 32h112c13.3 0 24 10.7 24 24v28c0 6.6-5.4 12-12 12H12C5.4 96 0 90.6 0 84zm416 56v324c0 26.5-21.5 48-48 48H80c-26.5 0-48-21.5-48-48V140c0-6.6 5.4-12 12-12h360c6.6 0 12 5.4 12 12zm-272 68c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208zm96 0c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208zm96 0c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208z", fill "currentColor" ]
    []
  ]

up : Html msg
up = svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-chevron-up fa-w-14", attribute "data-icon" "chevron-up", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 448 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
  [ path [ d "M240.971 130.524l194.343 194.343c9.373 9.373 9.373 24.569 0 33.941l-22.667 22.667c-9.357 9.357-24.522 9.375-33.901.04L224 227.495 69.255 381.516c-9.379 9.335-24.544 9.317-33.901-.04l-22.667-22.667c-9.373-9.373-9.373-24.569 0-33.941L207.03 130.525c9.372-9.373 24.568-9.373 33.941-.001z", fill "currentColor" ]
    []
  ]

down : Html msg
down = svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-chevron-down fa-w-14", attribute "data-icon" "chevron-down", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 448 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
  [ path [ d "M207.029 381.476L12.686 187.132c-9.373-9.373-9.373-24.569 0-33.941l22.667-22.667c9.357-9.357 24.522-9.375 33.901-.04L224 284.505l154.745-154.021c9.379-9.335 24.544-9.317 33.901.04l22.667 22.667c9.373 9.373 9.373 24.569 0 33.941L240.971 381.476c-9.373 9.372-24.569 9.372-33.942 0z", fill "currentColor" ]
    []
  ]

addBlock : Html msg
addBlock = svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-plus-square fa-w-14", attribute "data-icon" "plus-square", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 448 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
  [ path [ d "M400 32H48C21.5 32 0 53.5 0 80v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V80c0-26.5-21.5-48-48-48zm-32 252c0 6.6-5.4 12-12 12h-92v92c0 6.6-5.4 12-12 12h-56c-6.6 0-12-5.4-12-12v-92H92c-6.6 0-12-5.4-12-12v-56c0-6.6 5.4-12 12-12h92v-92c0-6.6 5.4-12 12-12h56c6.6 0 12 5.4 12 12v92h92c6.6 0 12 5.4 12 12v56z", fill "currentColor" ]
    []
  ]

addColumn : Html msg
addColumn = svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-columns fa-w-16", attribute "data-icon" "columns", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 512 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
  [ path [ d "M464 32H48C21.49 32 0 53.49 0 80v352c0 26.51 21.49 48 48 48h416c26.51 0 48-21.49 48-48V80c0-26.51-21.49-48-48-48zM224 416H64V160h160v256zm224 0H288V160h160v256z", fill "currentColor" ]
    []
  ]

left : Html msg
left = svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-chevron-left fa-w-10", attribute "data-icon" "chevron-left", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 320 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
  [ path [ d "M34.52 239.03L228.87 44.69c9.37-9.37 24.57-9.37 33.94 0l22.67 22.67c9.36 9.36 9.37 24.52.04 33.9L131.49 256l154.02 154.75c9.34 9.38 9.32 24.54-.04 33.9l-22.67 22.67c-9.37 9.37-24.57 9.37-33.94 0L34.52 272.97c-9.37-9.37-9.37-24.57 0-33.94z", fill "currentColor" ]
    []
  ]

right : Html msg
right = svg [ attribute "aria-hidden" "true", class "svg-inline--fa fa-chevron-right fa-w-10", attribute "data-icon" "chevron-right", attribute "data-prefix" "fas", attribute "role" "img", viewBox "0 0 320 512", attribute "xmlns" "http://www.w3.org/2000/svg" ]
  [ path [ d "M285.476 272.971L91.132 467.314c-9.373 9.373-24.569 9.373-33.941 0l-22.667-22.667c-9.357-9.357-9.375-24.522-.04-33.901L188.505 256 34.484 101.255c-9.335-9.379-9.317-24.544.04-33.901l22.667-22.667c9.373-9.373 24.569-9.373 33.941 0L285.475 239.03c9.373 9.372 9.373 24.568.001 33.941z", fill "currentColor" ]
    []
  ]

move : Html msg
move = svg [ class "svg-inline--fa fa-arrows-alt fa-w-16", viewBox "0 0 512 512" ]
  [ Svg.path
      [ fill "currentColor"
      , d "M352.201 425.775l-79.196 79.196c-9.373 9.373-24.568 9.373-33.941 0l-79.196-79.196c-15.119-15.119-4.411-40.971 16.971-40.97h51.162L228 284H127.196v51.162c0 21.382-25.851 32.09-40.971 16.971L7.029 272.937c-9.373-9.373-9.373-24.569 0-33.941L86.225 159.8c15.119-15.119 40.971-4.411 40.971 16.971V228H228V127.196h-51.23c-21.382 0-32.09-25.851-16.971-40.971l79.196-79.196c9.373-9.373 24.568-9.373 33.941 0l79.196 79.196c15.119 15.119 4.411 40.971-16.971 40.971h-51.162V228h100.804v-51.162c0-21.382 25.851-32.09 40.97-16.971l79.196 79.196c9.373 9.373 9.373 24.569 0 33.941L425.773 352.2c-15.119 15.119-40.971 4.411-40.97-16.971V284H284v100.804h51.23c21.382 0 32.09 25.851 16.971 40.971z"
      ] []
  ]
