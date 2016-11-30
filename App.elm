module App exposing (main)

import Html
import Types exposing (Model, Msg)
import State
import View


main : Program Never Model Msg
main =
    Html.program
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.rootView
        }
