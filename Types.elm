module Types exposing (..)

import Dict exposing (Dict)
import Http


type alias Model =
    { posts : List Post
    , comments : Dict String (List Comment)
    , page : Page
    }


initialModel : Page -> Model
initialModel page =
    Model [] Dict.empty page


type Msg
    = FetchPosts (Result Http.Error (List Post))
    | FetchComments String (Result Http.Error (List Comment))
    | NavigatedTo (Maybe Page)
    | IncrementLikes String


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
