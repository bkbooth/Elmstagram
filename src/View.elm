module View exposing (..)

import Html exposing (Html, div, h1, p, text, button)
import Html.Attributes exposing (type')
import Html.Events exposing (onClick)
import Dict

import Types exposing (Msg(..))
import Model exposing (Model)


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [text "Elmstagram"]
    , p [] [text "This is just a clone of Instagram"]
    , p [] [text ("Posts: " ++ toString (List.length model.posts))]
    , p [] [text ("Posts w/ Comments: " ++ toString (Dict.size model.comments))]
    , p [] [text ("Likes: " ++ toString model.likes)]
    , p []
      [ button [onClick IncrementLikes] [text "Like!"]
      ]
    ]
