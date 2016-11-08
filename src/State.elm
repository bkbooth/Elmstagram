module State exposing (..)

import Dict
import Task
import Http
import Json.Decode as Json

import Types exposing (Model, Msg(..), Post)
import Rest


init : ( Model, Cmd Msg )
init =
  ( Model [] Dict.empty
  , Rest.getData FetchFail FetchPostsSuccess Rest.decodePosts "data/posts.json"
  )


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
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

    IncrementLikes code ->
      ( { model | posts = List.map (incrementPostLikes code) model.posts }
      , Cmd.none
      )


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


incrementPostLikes : String -> Post -> Post
incrementPostLikes code post =
  if post.code == code then
    { post | likes = post.likes + 1 }
  else
    post
