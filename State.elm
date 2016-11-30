module State exposing (..)

import Types exposing (..)


init : (Model, Cmd Msg)
init =
    initialModel ! []


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        IncrementLikes ->
            (model + 1) ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
