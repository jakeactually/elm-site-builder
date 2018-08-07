module SiteBuilder.Util exposing (..)

import Array exposing (Array, fromList, get, toList)
import List exposing (drop, indexedMap, filter, map, map2, member, take)

-- List

(!!) : List a -> Int -> Maybe a
(!!) list index = get index <| fromList list

set : Int -> a -> List a -> List a
set index item list = toList <| Array.set index item <| fromList list

remove : Int -> List a -> List a
remove index list = take index list ++ drop (index + 1) list

zip : List a -> List b -> List (a, b)
zip = map2 (,)

indexedZip : List a -> List (Int, a)
indexedZip = indexedMap (,)

swap : Int -> Int -> List a -> List a
swap index1 index2 list = toList <| arraySwap index1 index2 <| fromList list

arraySwap : Int -> Int -> Array a -> Array a
arraySwap index1 index2 array =
  let
    maybe1 = get index1 array
    maybe2 = get index2 array
  in case (maybe1, maybe2) of
    (Just item1, Just item2)  -> Array.set index1 item2 <| Array.set index2 item1 array
    _                         -> array
