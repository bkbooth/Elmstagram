module Types exposing (..)

import Http


type alias Model =
    { posts : List Post
    , page : Page
    }


initialModel : Page -> Model
initialModel page =
    Model [] page


type Msg
    = FetchPosts (Result Http.Error (List Post))
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
