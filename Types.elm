module Types exposing (..)

import Http


type alias Model =
    { posts : List Post
    }


initialModel : Model
initialModel =
    Model []


type Msg
    = FetchPosts (Result Http.Error (List Post))


type alias Post =
    { id : String
    , likes : Int
    , comments : Int
    , text : String
    , media : String
    }
