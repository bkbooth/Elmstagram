module Types exposing (..)

import Dict exposing (Dict)
import Http


type alias Model =
    { posts : List Post
    , comments : Dict String (List Comment)
    , page : Page
    , newComment : Comment
    }


initialModel : Page -> Model
initialModel page =
    Model [] Dict.empty page (Comment "" "")


type Msg
    = FetchPosts (Result Http.Error (List Post))
    | FetchComments String (Result Http.Error (List Comment))
    | NavigateTo String
    | NavigatedTo (Maybe Page)
    | IncrementLikes String
    | UpdateCommentUsername String
    | UpdateCommentText String
    | AddComment String Comment
    | RemoveComment String Int


type Page
    = ListOfPosts
    | SinglePost String


type alias Post =
    { id : String
    , likes : Int
    , comments : Int
    , text : String
    , media : String
    }


type alias Comment =
    { username : String
    , text : String
    }
