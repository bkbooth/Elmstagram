module App exposing (main)

import Navigation

import State
import View


main : Program Never
main =
  Navigation.program (Navigation.makeParser State.hashParser)
    { init = State.init
    , update = State.update
    , urlUpdate = State.urlUpdate
    , subscriptions = State.subscriptions
    , view = View.rootView
    }
