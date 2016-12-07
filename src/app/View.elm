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
        [ main_ []
            [ viewPage model
            ]
        , nav []
            [ div [ class "nav-inner" ]
                [ a (clickTo (State.toUrl ListOfPosts) [ class "nav-logo" ])
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
                    , a [ href "https://www.instagram.com/wollongong_rips/" ] [ text "@wollongong_rips" ]
                    , text "|"
                    , a [ href "https://github.com/bkbooth/Elmstagram.git" ] [ text "View Source" ]
                    , text "|"
                    , a (clickTo (State.toUrl ListOfPosts) []) [ text "Elmstagram" ]
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
            <|
                List.map (viewKeyedPost model) model.posts

        SinglePost postId ->
            let
                maybePost =
                    getPost postId model.posts
            in
                case maybePost of
                    Just post ->
                        div [ class "photo-single" ]
                            [ viewPost model post
                            ]

                    Nothing ->
                        div []
                            [ text ("Post \"" ++ postId ++ "\" not found.")
                            ]


getPost : String -> List Post -> Maybe Post
getPost postId posts =
    let
        postsById =
            List.filter (\post -> post.id == postId) posts
    in
        List.head postsById


getPostComments : String -> Dict String (List Comment) -> List Comment
getPostComments postId comments =
    case (Dict.get postId comments) of
        Just postComments ->
            postComments

        Nothing ->
            []


viewPost : Model -> Post -> Html Msg
viewPost model post =
    let
        displayComments =
            case model.page of
                SinglePost postId ->
                    viewComments model post

                ListOfPosts ->
                    div [] []
    in
        figure [ class "photo-figure" ]
            [ div [ class "photo-wrap" ]
                [ a (clickTo (State.toUrl <| SinglePost post.id) [])
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
                        , a (clickTo (State.toUrl <| SinglePost post.id) [])
                            [ strong [] [ text <| toString post.comments ]
                            , text " comments"
                            ]
                        ]
                    , p [ class "photo-caption" ]
                        [ strong [] [ text "wollongong_rips" ]
                        , text post.text
                        ]
                    , displayComments
                    ]
                ]
            ]


viewKeyedPost : Model -> Post -> (String, Html Msg)
viewKeyedPost model post =
    ( post.id
    , viewPost model post
    )


viewComments : Model -> Post -> Html Msg
viewComments model post =
    let
        listOfComments =
            List.indexedMap (viewComment post) <|
                getPostComments post.id model.comments
    in
        Html.Keyed.node "div"
            [ class "comments" ]
        <|
            listOfComments
                ++ [ viewCommentForm model post ]


viewComment : Post -> Int -> Comment -> (String, Html Msg)
viewComment post index comment =
    ( toString index
    , div [ class "comment" ]
        [ p []
            [ strong [] [ text comment.username ]
            , text comment.text
            , button [ onClick <| RemoveComment post.id index, class "remove-comment" ] [ text "×" ]
            ]
        ]
    )


viewCommentForm : Model -> Post -> (String, Html Msg)
viewCommentForm model post =
    ( "comment-form"
    , Html.form [ onSubmit <| AddComment post.id model.newComment, class "comment-form" ]
        [ input
            [ type_ "text"
            , value model.newComment.username
            , onInput UpdateCommentUsername
            , placeholder "author..."
            ]
            []
        , input
            [ type_ "text"
            , value model.newComment.text
            , onInput UpdateCommentText
            , placeholder "comment..."
            ]
            []
        , input
            [ type_ "submit"
            , hidden True
            ]
            []
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
        ]
            ++ attributes
