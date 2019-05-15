module Util exposing (..)

import List exposing (drop, foldr, head, take)
import String exposing (dropLeft, left, toUpper)

get : Int -> List a -> Maybe a
get index list = if index < 0 then Nothing else head <| drop index list

set : Int -> a -> List a -> List a
set index item list = take index list ++ item :: drop (index + 1) list

update : (a -> a) -> Int -> List a -> List a
update function index list = case get index list of
  Just (item) -> take index list ++ function item :: drop (index + 1) list
  Nothing -> list

remove : Int -> List a -> List a
remove index list = take index list ++ drop (index + 1) list

duplicate : Int -> List a -> List a
duplicate index list =
  let start = take (index + 1) list
  in start ++ drop index start ++ drop (index + 1) list

splitAt : Int -> List a -> (List a, List a)
splitAt n xs = (take n xs, drop n xs)

insert : Int -> a -> List a -> List a
insert index item list =
  let (start, end) = splitAt index list
  in start ++ item :: end

swap : Int -> Int -> List a -> List a
swap i1 i2 list = case (get i1 list, get i2 list) of
  (Just item1, Just item2) -> set i2 item1 <| set i1 item2 list
  _ -> list

capitalize : String -> String
capitalize str = toUpper (left 1 str) ++ dropLeft 1 str

isJust : Maybe a -> Bool
isJust maybe = case maybe of
  Just _ -> True
  Nothing -> False

maybeToList : Maybe a -> List a
maybeToList maybe = case maybe of
  Just a -> [a]
  Nothing -> []
