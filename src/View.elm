module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Dict exposing (Dict)

import Types exposing (Model, Msg(..), Page(..), Post, Comment)
import State


rootView : Model -> Html Msg
rootView model =
  div []
    [ h1 []
      [ a [ href (State.toURL Photos) ] [ text "Elmstagram" ]
      ]
    , (viewPage model)
    ]


viewPage : Model -> Html Msg
viewPage model =
  case model.page of
    Photos ->
      div [ class "photo-grid" ]
        (List.map (viewPost model) model.posts)

    Photo code ->
      let
        post = getPost code model.posts
      in
        case post of
          Just post ->
            div [ class "single-photo" ]
              [ (viewPost model post)
              , (viewComments model (getPostComments post.code model.comments))
              ]

          Nothing ->
            div [] []


getPost : String -> List Post -> Maybe Post
getPost code posts =
  let
    filterByCode : Post -> Bool
    filterByCode post =
      post.code == code

    postsByCode = List.filter filterByCode posts
  in
    List.head postsByCode


viewPost : Model -> Post -> Html Msg
viewPost model post =
  figure [ class "grid-figure" ]
    [ div [ class "grid-photo-wrap" ]
      [ a [ href (State.toURL (Photo post.code)) ]
        [ img [ src post.display_src, alt post.caption, class "grid-photo" ] []
        ]
      , span [ class "likes-heart" ] [ text (toString post.likes) ]
      ]
    , figcaption []
      [ p [] [ text post.caption ]
      , div [ class "control-buttons" ]
        [ button [ onClick (IncrementLikes post.code), class "likes" ] [ text ("♥ " ++ (toString post.likes)) ]
        , a [ href (State.toURL (Photo post.code)), class "button" ]
          [ span [ class "comment-count" ]
            [ span [ class "speech-bubble" ] []
            , text (" " ++ (viewCommentsCount (getPostComments post.code model.comments)))
            ]
          ]
        ]
      ]
    ]


getPostComments : String -> Dict String (List Comment) -> Maybe (List Comment)
getPostComments code comments =
  Dict.get code comments


viewComments : Model -> Maybe (List Comment) -> Html Msg
viewComments model comments =
  let
    listOfComments =
      case comments of
        Just comments ->
          List.map (viewComment model) comments

        Nothing ->
          []
  in
    div [ class "comments" ]
    (listOfComments ++ [ (viewCommentsForm model) ])


viewComment : Model -> Comment -> Html Msg
viewComment model comment =
  div [ class "comment" ]
  [ p []
    [ strong [] [ text comment.user ]
    , text comment.text
    , button [ class "remove-comment" ] [ text "×" ]
    ]
  ]


viewCommentsForm : Model -> Html Msg
viewCommentsForm model =
  Html.form [ class "comment-form" ]
  [ input [ type' "text", placeholder "author" ] []
  , input [ type' "text", placeholder "comment" ] []
  , input [ type' "submit", hidden True ] []
  ]


viewCommentsCount : Maybe (List Comment) -> String
viewCommentsCount comments =
  let
    commentsCount =
      case comments of
        Just comments ->
          List.length comments

        Nothing ->
          0
  in
    toString commentsCount
