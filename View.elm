module View exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Types exposing (Model, Msg(..))


rootView : Model -> Html Msg
rootView model =
    div []
        [ h1 [] [text "Elmstagram"]
        , p [] [text ("Likes: " ++ toString model)]
        , p []
            [ button [onClick IncrementLikes] [text "Like!"]
            ]
        ]
