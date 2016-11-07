module Main exposing (main)

import Html.App as App
import Dict

import Types exposing (Msg(..), decodePosts)
import Model exposing (Model)
import View exposing (view)
import Update exposing (update, getData)
import Subscriptions exposing (subscriptions)


init : (Model, Cmd Msg)
init =
  ( Model [] Dict.empty 0
  , getData FetchPostsSuccess decodePosts "data/posts.json"
  )


main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
