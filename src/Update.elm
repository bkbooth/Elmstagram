module Update exposing (..)

import Model exposing (Model)


type Msg
  = IncrementLikes


update : Msg -> Model -> Model
update msg model =
  case msg of
    IncrementLikes ->
      model + 1
