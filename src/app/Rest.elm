module Rest exposing (..)

import Json.Decode as Json exposing (..)
import Dict exposing (Dict)
import Task
import Http

import Types exposing (Msg(..), Post, Comment)


getData : (Http.Error -> Msg) -> (data -> Msg) -> Json.Decoder data -> String -> Cmd Msg
getData fail success decoder url =
  Task.perform fail success (Http.get decoder url)


getPosts : Cmd Msg
getPosts =
  getData
    FetchPostsFail
    FetchPostsSuccess
    decodePosts
    "data/posts.json"


getPostComments : String -> Cmd Msg
getPostComments postId =
  getData
    (FetchCommentsFail postId)
    (FetchCommentsSuccess postId)
    decodeComments
    ("data/" ++ postId ++ ".json")


decodePosts : Json.Decoder (List Post)
decodePosts =
  ( object5 Post
    ("id" := string)
    ("likes" := int)
    ("comments" := int)
    ("text" := string)
    ("media" := string)
  ) |> list


decodeComments : Json.Decoder (List Comment)
decodeComments =
  ( object2 Comment
    ("username" := string)
    ("text" := string)
  ) |> list
