module Types exposing (..)


type alias Model =
    Int


initialModel : Model
initialModel =
    0


type Msg
    = IncrementLikes
