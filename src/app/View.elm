module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit, onWithOptions)
import Html.Keyed
import Dict exposing (Dict)
import Json.Decode as Json

import Types exposing (..)
import State


rootView : Model -> Html Msg
rootView model =
  div [ id "app-root" ]
    [ main' []
      [ (viewPage model)
      ]
    , nav []
      [ div [ class "nav-inner" ]
        [ a (clickTo (State.toURL Photos) [ class "nav-logo" ])
          [ img [ src "img/logo.svg" ] []
          , text "Elmstagram"
          ]
        ]
      ]
    , footer []
      [ div [ class "footer-inner" ]
        [ p []
          [ a [ href "https://twitter.com/bkbooth11" ] [ text "Ben Booth" ]
          , text "|"
          , a [ href "https://github.com/bkbooth/Elmstagram.git" ] [ text "View Source" ]
          , text "|"
          , a (clickTo (State.toURL Photos) []) [ text "Elmstagram" ]
          ]
        ]
      ]
    ]


viewPage : Model -> Html Msg
viewPage model =
  case model.page of
    Photos ->
      Html.Keyed.node "div" [ class "photo-list" ]
        (List.map (viewKeyedPost model) model.posts)

    Photo code ->
      let
        post = getPost code model.posts
      in
        case post of
          Just post ->
            div [ class "photo-single" ]
              [ (viewPost model post)
              ]

          Nothing ->
            div [] []


getPost : String -> List Post -> Maybe Post
getPost code posts =
  let
    postsByCode = List.filter (\post -> post.code == code) posts
  in
    List.head postsByCode


getPostComments : String -> Dict String (List Comment) -> List Comment
getPostComments code comments =
  case (Dict.get code comments) of
    Just comments ->
      comments

    Nothing ->
      []


viewPost : Model -> Post -> Html Msg
viewPost model post =
  let
    postComments = getPostComments post.code model.comments
    displayComments =
      case model.page of
        Photo code ->
          (viewComments model post postComments)

        Photos ->
          div [] []
  in
    figure [ class "photo-figure" ]
      [ div [ class "photo-wrap" ]
        [ a (clickTo (State.toURL (Photo post.code)) [])
          [ img [ src post.display_src, alt post.caption, class "photo" ] []
          ]
        ]
      , figcaption []
        [ div [ class "caption-button" ]
          [ button [ onClick (IncrementLikes post.code), class "like-button" ] [ text "♡" ]
          ]
        , div [ class "caption-content" ]
          [ div [ class "photo-stats" ]
            [ strong [] [ text (toString post.likes) ]
            , text " likes, "
            , a (clickTo (State.toURL (Photo post.code)) [])
              [ strong [] [ text (postComments |> List.length |> toString) ]
              , text " comments"
              ]
            ]
          , p [ class "photo-caption" ] [ text post.caption ]
          , displayComments
          ]
        ]
      ]


viewKeyedPost : Model -> Post -> (String, Html Msg)
viewKeyedPost model post =
  (post.code, (viewPost model post))


viewComments : Model -> Post -> List Comment -> Html Msg
viewComments model post comments =
  let
    listOfComments = List.indexedMap (viewComment post) comments
  in
    Html.Keyed.node "div" [ class "comments" ]
      (listOfComments ++ [ (viewCommentsForm model post) ])


viewComment : Post -> Int -> Comment -> (String, Html Msg)
viewComment post index comment =
  ( (toString index)
  , div [ class "comment" ]
      [ p []
        [ strong [] [ text comment.user ]
        , text comment.text
        , button [ onClick (RemoveComment post.code index), class "remove-comment" ] [ text "×" ]
        ]
      ]
  )


viewCommentsForm : Model -> Post -> (String, Html Msg)
viewCommentsForm model post =
  ( "comment-form"
  , Html.form [ onSubmit (AddComment post.code model.comment), class "comment-form" ]
      [ input
        [ type' "text"
        , value model.comment.user
        , onInput UpdateCommentUser
        , placeholder "author..."
        ] []
      , input
        [ type' "text"
        , value model.comment.text
        , onInput UpdateCommentText
        , placeholder "comment..."
        ] []
      , input
        [ type' "submit"
        , hidden True
        ] []
      ]
  )


clickTo : String -> List (Attribute Msg) -> List (Attribute Msg)
clickTo path attributes =
  let
    options =
      { stopPropagation = True
      , preventDefault = True
      }
  in
    [ href path
    , onWithOptions
        "click"
        options
        (Json.map (\_ -> NavigateTo path) Json.value)
    ] ++ attributes
