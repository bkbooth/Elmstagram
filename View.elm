module View exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Html.Keyed
import Types exposing (..)
import State


rootView : Model -> Html Msg
rootView model =
    div [ id "app-root" ]
        [ main_ []
            [ viewPage model
            ]
        , nav []
            [ div [ class "nav-inner" ]
                [ a [ href (State.toUrl ListOfPosts), class "nav-logo" ]
                    [ img [ src "img/logo.svg" ] []
                    , text "Elmstagram"
                    ]
                ]
            ]
        , footer []
            [ div [ class "footer-inner" ]
                [ p []
                    [ a [ href "https://github.com/bkbooth/Elmstagram.git" ] [ text "View Source" ]
                    , text "|"
                    , a [ href (State.toUrl ListOfPosts) ] [ text "Elmstagram" ]
                    ]
                ]
            ]
        ]


viewPage : Model -> Html Msg
viewPage model =
    case model.page of
        ListOfPosts ->
            Html.Keyed.node "div"
                [ class "photo-list" ]
                <| List.map (viewKeyedPost model) model.posts

        SinglePost postId ->
            div [ class "photo-single" ]
                [ text ("Post: " ++ postId) ]


viewPost : Model -> Post -> Html Msg
viewPost model post =
    figure [ class "photo-figure" ]
        [ div [ class "photo-wrap" ]
            [ a [ href (State.toUrl <| SinglePost post.id) ]
                [ img [ src post.media, alt post.text, class "photo" ] []
                ]
            ]
        , figcaption []
            [ div [ class "caption-button" ]
                [ button [ onClick <| IncrementLikes post.id, class "like-button" ] [ text "♡" ]
                ]
            , div [ class "caption-content" ]
                [ div [ class "photo-stats" ]
                    [ strong [] [ text <| toString post.likes ]
                    , text " likes, "
                    , a [ href (State.toUrl <| SinglePost post.id) ]
                        [ strong [] [ text <| toString post.comments ]
                        , text " comments"
                        ]
                    ]
                , p [ class "photo-caption" ] [ text post.text ]
                ]
            ]
        ]


viewKeyedPost : Model -> Post -> (String, Html Msg)
viewKeyedPost model post =
    ( post.id
    , viewPost model post
    )
