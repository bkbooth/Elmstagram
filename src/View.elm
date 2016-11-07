module View exposing (..)

import Html exposing (Html, div, h1, p, text, button)
import Html.Attributes exposing (type')
import Html.Events exposing (onClick)

import Model exposing (Model)
import Update exposing (Msg(..))


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [text "Elmstagram"]
    , p [] [text "This is just a clone of Instagram"]
    , p [] [text ("Likes: " ++ toString model)]
    , p []
      [ button [onClick IncrementLikes] [text "Like!"]
      ]
    ]
