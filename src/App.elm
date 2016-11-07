module App exposing (main)

import Html.App

import State
import View


main : Program Never
main =
  Html.App.program
    { init = State.init
    , update = State.update
    , subscriptions = State.subscriptions
    , view = View.rootView
    }
