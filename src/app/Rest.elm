module Rest exposing (..)

import Json.Decode as Json exposing (..)
import Dict exposing (Dict)
import Task
import Http

import Types exposing (Msg, Post, Comment)


getData : (Http.Error -> Msg) -> (data -> Msg) -> Json.Decoder data -> String -> Cmd Msg
getData fail success decoder url =
  Task.perform fail success (Http.get decoder url)


decodePosts : Json.Decoder (List Post)
decodePosts =
  ( object5 Post
    ("code" := string)
    ("caption" := string)
    ("likes" := int)
    ("id" := string)
    ("display_src" := string)
  ) |> list


decodeComments : Json.Decoder (Dict String (List Comment))
decodeComments =
  ( object2 Comment
    ("text" := string)
    ("user" := string)
  ) |> list |> dict
