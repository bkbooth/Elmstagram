module State exposing (..)

import String
import Dict exposing (Dict)
import List.Extra
import Navigation
import UrlParser exposing (..)

import Types exposing (..)
import Rest


-- INIT

init : Result String Page -> (Model, Cmd Msg)
init result =
  let
    model = initialModel (pageFromResult result)
    getCommentsCommand =
      case model.page of
        Photo postId ->
          Rest.getPostComments postId

        Photos ->
          Cmd.none
  in
    model !
      [ Rest.getPosts
      , getCommentsCommand
      ]


-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    FetchPostsSuccess posts ->
      { model | posts = posts } ! []

    FetchPostsFail _ ->
      model ! []

    FetchCommentsSuccess postId comments ->
      { model
        | comments = Dict.insert postId comments model.comments
        , posts = List.map (setPostComments postId (List.length comments)) model.posts
        } ! []

    FetchCommentsFail postId _ ->
      update (FetchCommentsSuccess postId []) model

    NavigateTo path ->
      model !
        [ Navigation.newUrl path
        ]

    IncrementLikes postId ->
      let
        incrementPostLikes : String -> Post -> Post
        incrementPostLikes postId post =
          if post.id == postId then
            { post | likes = post.likes + 1 }
          else
            post
      in
        { model
          | posts = List.map (incrementPostLikes postId) model.posts
          } ! []

    UpdateCommentUsername username ->
      let
        comment = model.newComment
      in
        { model
          | newComment = { comment | username = username }
          } ! []

    UpdateCommentText text ->
      let
        comment = model.newComment
      in
        { model
          | newComment = { comment | text = text }
          } ! []

    AddComment postId comment ->
      let
        addPostComment : Maybe (List Comment) -> Maybe (List Comment)
        addPostComment comments =
          case comments of
            Just comments ->
              Just (comments ++ [ comment ])

            Nothing ->
              Just [ comment ]

        numberOfPostComments = getNumberOfPostComments postId model.comments
      in
        { model
          | comments = Dict.update postId addPostComment model.comments
          , posts = List.map (setPostComments postId (numberOfPostComments + 1)) model.posts
          , newComment = Comment "" ""
          } ! []

    RemoveComment postId index ->
      let
        removePostComment : Maybe (List Comment) -> Maybe (List Comment)
        removePostComment comments =
          case comments of
            Just comments ->
              Just (List.Extra.removeAt index comments)

            Nothing ->
              Nothing

        numberOfPostComments = getNumberOfPostComments postId model.comments
      in
        { model
          | comments = Dict.update postId removePostComment model.comments
          , posts = List.map (setPostComments postId (numberOfPostComments - 1)) model.posts
          } ! []


setPostComments : String -> Int -> Post -> Post
setPostComments postId numberOfComments post =
  if post.id == postId then
    { post | comments = numberOfComments }
  else
    post


getNumberOfPostComments : String -> (Dict String (List Comment)) -> Int
getNumberOfPostComments postId comments =
  case Dict.get postId comments of
    Just postComments ->
      List.length postComments

    Nothing ->
      0


-- URL UPDATE

urlUpdate : Result String Page -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  let
    page = pageFromResult result
    command =
      case page of
        Photo postId ->
          Rest.getPostComments postId

        Photos ->
          Cmd.none
  in
    { model
      | page = page
      } ! [ command ]


pageFromResult : Result String Page -> Page
pageFromResult result =
  case result of
    Ok page ->
      page

    Err _ ->
      Photos


toURL : Page -> String
toURL page =
  let
    baseUrl = "/"
  in
    case page of
      Photos ->
        baseUrl

      Photo postId ->
        baseUrl ++ "view/" ++ postId


pathParser : Navigation.Location -> Result String Page
pathParser location =
  UrlParser.parse identity pageParser (String.dropLeft 1 location.pathname)


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
