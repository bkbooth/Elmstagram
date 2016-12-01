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

        IncrementLikes postId ->
            let
                incrementPostLikes : String -> Post -> Post
                incrementPostLikes postId post =
                    if post.id == postId then
                       { post | likes = post.likes + 1 }
                    else
                       post
            in
               { model
                   | posts = List.map (incrementPostLikes postId) model.posts
               } ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
