module Types exposing (..)

import Dict exposing (Dict)
import Http


type alias Model =
  { posts : List Post
  , comments: Dict String (List Comment)
  , likes: Int
  }


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
