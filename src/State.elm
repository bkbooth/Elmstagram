module State exposing (..)

import String
import Dict
import List.Extra
import Navigation
import UrlParser exposing (..)

import Types exposing (..)
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
      { model | posts = posts } ! []

    FetchCommentsSuccess comments ->
      { model | comments = comments } ! []

    FetchFail _ ->
      model ! []

    IncrementLikes code ->
      let
        incrementPostLikes : String -> Post -> Post
        incrementPostLikes code post =
          if post.code == code then
            { post | likes = post.likes + 1 }
          else
            post

        updatedPosts = List.map (incrementPostLikes code) model.posts
      in
        { model | posts = updatedPosts } ! []

    RemoveComment code index ->
      let
        updatePostComments : Maybe (List Comment) -> Maybe (List Comment)
        updatePostComments comments =
          case comments of
            Just comments ->
              Just (List.Extra.removeAt index comments)

            Nothing ->
              Nothing

        updatedComments = Dict.update code updatePostComments model.comments
      in
        { model | comments = updatedComments } ! []


-- URL UPDATE

urlUpdate : Result String Page -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
  case result of
    Ok page ->
      { model | page = page } !
        [ Rest.getData FetchFail FetchPostsSuccess Rest.decodePosts "data/posts.json"
        , Rest.getData FetchFail FetchCommentsSuccess Rest.decodeComments "data/comments.json"
        ]

    Err _ ->
      model !
        [ Navigation.modifyUrl (toURL model.page)
        ]


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
