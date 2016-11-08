module State exposing (..)

import String
import Dict
import Task
import Http
import Json.Decode as Json
import Navigation
import UrlParser exposing (..)

import Types exposing (Model, Msg(..), Post, Page(..))
import Rest


-- INIT

init : Result String Page -> ( Model, Cmd Msg )
init result =
  urlUpdate result (Model [] Dict.empty Photos)


-- UPDATE

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

    FetchFail _ ->
      ( model
      , Cmd.none
      )

    IncrementLikes code ->
      ( { model | posts = List.map (incrementPostLikes code) model.posts }
      , Cmd.none
      )


incrementPostLikes : String -> Post -> Post
incrementPostLikes code post =
  if post.code == code then
    { post | likes = post.likes + 1 }
  else
    post


-- URL UPDATE

urlUpdate : Result String Page -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
  case result of
    Ok page ->
      ( { model | page = page }
      , Rest.getData FetchFail FetchPostsSuccess Rest.decodePosts "data/posts.json"
      )

    Err _ ->
      ( model, Navigation.modifyUrl (toURL model.page) )


toURL : Page -> String
toURL page =
  let
    baseUrl = "/#/"
  in
    case page of
      Photos ->
        baseUrl

      Photo code ->
        baseUrl ++ "view/" ++ code


-- TODO: use location.pathname instead
hashParser : Navigation.Location -> Result String Page
hashParser location =
  UrlParser.parse identity pageParser (String.dropLeft 2 (Debug.log "hash" location.hash))


pageParser : Parser (Page -> a) a
pageParser =
  oneOf
    [ format Photos (s "")
    , format Photo (s "view" </> string)
    ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
