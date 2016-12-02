module App exposing (main)

import Navigation
import Types exposing (Model, Msg)
import State
import View


main : Program Never Model Msg
main =
    Navigation.program State.hashParser
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.rootView
        }
