module Rest exposing (..)

import Json.Decode as Json exposing (..)
import Http
import Types exposing (Msg(..), Post, Comment)


getPosts : Cmd Msg
getPosts =
    Http.send FetchPosts <|
        Http.get "data/posts.json" decodePosts


getPostComments : String -> Cmd Msg
getPostComments postId =
    Http.send (FetchComments postId) <|
        Http.get ("data/" ++ postId ++ ".json") decodeComments


decodePosts : Json.Decoder (List Post)
decodePosts =
    list <|
        map5 Post
            (field "id" string)
            (field "likes" int)
            (field "comments" int)
            (field "text" string)
            (field "media" string)


decodeComments : Json.Decoder (List Comment)
decodeComments =
    list <|
        map2 Comment
            (field "username" string)
            (field "text" string)
