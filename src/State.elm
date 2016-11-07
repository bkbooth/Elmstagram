module State exposing (..)

import Dict
import Task
import Http
import Json.Decode as Json

import Types exposing (Model, Msg(..))
import Rest


init : ( Model, Cmd Msg )
init =
  ( Model [] Dict.empty 0
  , Rest.getData FetchFail FetchPostsSuccess Rest.decodePosts "data/posts.json"
  )


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
    IncrementLikes ->
      ( { model | likes = model.likes + 1 }
      , Cmd.none
      )

    FetchPostsSuccess posts ->
      ( { model | posts = posts }
      , Rest.getData FetchFail FetchCommentsSuccess Rest.decodeComments "data/comments.json"
      )

    FetchCommentsSuccess comments ->
      ( { model | comments = comments }
      , Cmd.none
      )

    FetchFail error ->
      ( model
      , Cmd.none
      )


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
