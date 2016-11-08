module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Dict

import Types exposing (Model, Msg(..), Post)


rootView : Model -> Html Msg
rootView model =
  div []
    [ h1 []
      [ a [ href "/" ] [ text "Elmstagram" ]
      ]
    , div [ class "photo-grid" ]
      (List.map viewPost model.posts)
    ]


viewPost : Post -> Html Msg
viewPost post =
  figure [ class "grid-figure" ]
    [ div [ class "grid-photo-wrap" ]
      [ a [ href ("/view/" ++ post.code) ]
        [ img [ src post.display_src, alt post.caption, class "grid-photo" ] []
        ]
      , span [ class "likes-heart" ] [ text (toString post.likes) ]
      ]
    , figcaption []
      [ p [] [ text post.caption ]
      , div [ class "control-buttons" ]
        [ button [ class "likes" ] [ text ("♥ " ++ (toString post.likes)) ]
        , a [ href ("/view/" ++ post.code), class "button" ]
          [ span [ class "comment-count" ]
            [ span [ class "speech-bubble" ] []
            , text (" " ++ "0")
            ]
          ]
        ]
      ]
    ]
