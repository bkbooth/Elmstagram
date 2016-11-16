module App exposing (main)

import Navigation
import State
import View
import Types exposing (Model, Msg)


main : Program Never Model Msg
main =
    Navigation.program State.pathParser
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.rootView
        }
