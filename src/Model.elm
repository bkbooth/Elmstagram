module Model exposing (..)

import Dict exposing (Dict)

import Types exposing (Post, Comment)


type alias Model =
  { posts : List Post
  , comments: Dict String (List Comment)
  , likes: Int
  }
