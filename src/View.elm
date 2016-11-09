module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.Keyed
import Dict exposing (Dict)

import Types exposing (..)
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
      Html.Keyed.node "div" [ class "photo-grid" ]
        (List.map (viewKeyedPost model) model.posts)

    Photo code ->
      let
        post = getPost code model.posts
        postComments = getPostComments code model.comments
      in
        case post of
          Just post ->
            div [ class "single-photo" ]
              [ (viewPost model post)
              , (viewComments model post.code postComments)
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
  in
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
              , text (" " ++ (postComments |> List.length |> toString))
              ]
            ]
          ]
        ]
      ]


viewKeyedPost : Model -> Post -> (String, Html Msg)
viewKeyedPost model post =
  (post.code, (viewPost model post))


viewComments : Model -> String -> List Comment -> Html Msg
viewComments model code comments =
  let
    listOfComments = List.indexedMap (viewComment code) comments
  in
    Html.Keyed.node "div" [ class "comments" ]
      (listOfComments ++ [ (viewCommentsForm model code) ])


viewComment : String -> Int -> Comment -> (String, Html Msg)
viewComment code index comment =
  ( (toString index)
  , div [ class "comment" ]
      [ p []
        [ strong [] [ text comment.user ]
        , text comment.text
        , button [ onClick (RemoveComment code index), class "remove-comment" ] [ text "×" ]
        ]
      ]
  )


viewCommentsForm : Model -> String -> (String, Html Msg)
viewCommentsForm model code =
  ( "comment-form"
  , Html.form [ onSubmit (AddComment code model.comment), class "comment-form" ]
      [ input
        [ type' "text"
        , value model.comment.user
        , onInput UpdateCommentUser
        , placeholder "author"
        ] []
      , input
        [ type' "text"
        , value model.comment.text
        , onInput UpdateCommentText
        , placeholder "comment"
        ] []
      , input
        [ type' "submit"
        , hidden True
        ] []
      ]
  )
