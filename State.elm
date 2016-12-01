module State exposing (..)

import Types exposing (..)
import Rest


init : (Model, Cmd Msg)
init =
    initialModel ! [ Rest.getPosts ]


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FetchPosts (Ok posts) ->
            { model | posts = posts } ! []

        FetchPosts (Err _) ->
            model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
