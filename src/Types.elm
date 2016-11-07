module Types exposing (..)

import Dict exposing (Dict)
import Http
import Json.Decode as Json exposing (..)


type Msg
  = IncrementLikes
  | FetchPostsSuccess (List Post)
  | FetchCommentsSuccess (Dict String (List Comment))
  | FetchFail Http.Error


type alias Post =
  { code: String
  , caption: String
  , likes: Int
  , id: String
  , display_src: String
  }


type alias Comment =
  { text: String
  , user: String
  }


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
