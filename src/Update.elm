module Update exposing (..)

import Task
import Http
import Json.Decode as Json

import Types exposing (Msg(..), decodeComments)
import Model exposing (Model)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    IncrementLikes ->
      ( { model | likes = model.likes + 1 }
      , Cmd.none
      )

    FetchPostsSuccess posts ->
      ( { model | posts = posts }
      , getData FetchCommentsSuccess decodeComments "data/comments.json"
      )

    FetchCommentsSuccess comments ->
      ( { model | comments = comments }
      , Cmd.none
      )

    FetchFail error ->
      ( model
      , Cmd.none
      )


getData : (a -> Msg) -> Json.Decoder a -> String -> Cmd Msg
getData success decoder url =
  Task.perform FetchFail success (Http.get decoder url)
