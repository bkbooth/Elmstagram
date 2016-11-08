module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Dict

import Types exposing (Model, Msg(..), Page(..), Post)
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
        (List.map viewPost model.posts)

    Photo code ->
      let
        post = List.head (List.filter (\p -> p.code == code) model.posts)
      in
        case post of
          Just post ->
            div [ class "single-photo" ]
              [ (viewPost post)
              ]

          Nothing ->
            div [] []


viewPost : Post -> Html Msg
viewPost post =
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
            , text (" " ++ "0")
            ]
          ]
        ]
      ]
    ]
