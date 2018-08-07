module SiteBuilder.Field.Update exposing (..)

import SiteBuilder.Field.Model exposing (..)
import SiteBuilder.Util exposing ((!!), set)

updateFields : Int -> FieldValue -> List Field -> List Field
updateFields i input fields = case fields !! i of
  Just field -> set i (updateField input field) fields
  Nothing -> fields

updateField : FieldValue -> Field -> Field
updateField input field = case field of
  Field name _ -> Field name input
