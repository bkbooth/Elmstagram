module Types exposing (..)

import Dict exposing (Dict)
import Http


type alias Model =
  { posts : List Post
  , comments: Dict String (List Comment)
  , page: Page
  , comment: Comment
  }


initialModel : Page -> Model
initialModel page =
  Model [] Dict.empty page (Comment "" "")


type Msg
  = FetchPostsSuccess (List Post)
  | FetchCommentsSuccess (Dict String (List Comment))
  | FetchFail Http.Error
  | IncrementLikes String
  | UpdateCommentUser String
  | UpdateCommentText String
  | AddComment String Comment
  | RemoveComment String Int


type Page
  = Photos
  | Photo String


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
