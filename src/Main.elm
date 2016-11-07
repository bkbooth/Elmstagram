module Main exposing (..)


-- IMPORTS
import Html exposing (Html, div, h1, p, text, button)
import Html.App as App
import Html.Attributes exposing (type')
import Html.Events exposing (onClick)


-- MAIN
main : Program Never
main =
  App.beginnerProgram
    { model = model
    , view = view
    , update = update
    }


-- MODEL
type alias Model = Int

model : Model
model =
  0


-- UPDATE
type Msg
  = IncrementLikes

update : Msg -> Model -> Model
update msg model =
  case msg of
    IncrementLikes ->
      model + 1


-- VIEW
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
