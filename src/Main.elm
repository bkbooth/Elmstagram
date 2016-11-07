module Main exposing (main)

import Html.App as App

import Model exposing (model)
import View exposing (view)
import Update exposing (update)


main : Program Never
main =
  App.beginnerProgram
    { model = model
    , view = view
    , update = update
    }
