module Rest exposing (..)

import Json.Decode as Json exposing (..)
import Http
import Types exposing (Msg(..), Post)


getPosts : Cmd Msg
getPosts =
    Http.send FetchPosts <|
        Http.get "data/posts.json" decodePosts


decodePosts : Json.Decoder (List Post)
decodePosts =
    list <|
        map5 Post
            (field "id" string)
            (field "likes" int)
            (field "comments" int)
            (field "text" string)
            (field "media" string)
