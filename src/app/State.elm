module State exposing (..)

import Dict exposing (Dict)
import List.Extra
import Navigation
import UrlParser exposing (..)
import Types exposing (..)
import Rest


-- INIT


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    case UrlParser.parsePath pageParser location of
        Just Photos ->
            initialModel Photos
                ! [ Rest.getPosts
                  ]

        Just (Photo postId) ->
            initialModel (Photo postId)
                ! [ Rest.getPosts
                  , Rest.getPostComments postId
                  ]

        Nothing ->
            initialModel Photos
                ! [ Rest.getPosts
                  , Navigation.modifyUrl (toUrl Photos)
                  ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        FetchPosts (Ok posts) ->
            { model | posts = posts }
                ! []

        FetchPosts (Err _) ->
            model
                ! []

        FetchComments postId (Ok comments) ->
            { model
                | comments = Dict.insert postId comments model.comments
                , posts = List.map (setPostComments postId <| List.length comments) model.posts
            }
                ! []

        FetchComments postId (Err _) ->
            update (FetchComments postId <| Ok []) model

        NavigateTo path ->
            model
                ! [ Navigation.newUrl path
                  ]

        NavigatedTo maybePage ->
            case maybePage of
                Just Photos ->
                    { model | page = Photos }
                        ! []

                Just (Photo postId) ->
                    { model | page = Photo postId }
                        ! [ Rest.getPostComments postId
                          ]

                Nothing ->
                    model
                        ! [ Navigation.newUrl <| toUrl Photos
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
                }
                    ! []

        UpdateCommentUsername username ->
            let
                comment =
                    model.newComment
            in
                { model
                    | newComment = { comment | username = username }
                }
                    ! []

        UpdateCommentText text ->
            let
                comment =
                    model.newComment
            in
                { model
                    | newComment = { comment | text = text }
                }
                    ! []

        AddComment postId comment ->
            let
                addPostComment : Maybe (List Comment) -> Maybe (List Comment)
                addPostComment comments =
                    case comments of
                        Just comments ->
                            Just <| comments ++ [ comment ]

                        Nothing ->
                            Just [ comment ]

                numberOfPostComments =
                    getNumberOfPostComments postId model.comments
            in
                { model
                    | comments = Dict.update postId addPostComment model.comments
                    , posts = List.map (setPostComments postId <| numberOfPostComments + 1) model.posts
                    , newComment = Comment "" ""
                }
                    ! []

        RemoveComment postId index ->
            let
                removePostComment : Maybe (List Comment) -> Maybe (List Comment)
                removePostComment comments =
                    case comments of
                        Just comments ->
                            Just <| List.Extra.removeAt index comments

                        Nothing ->
                            Nothing

                numberOfPostComments =
                    getNumberOfPostComments postId model.comments
            in
                { model
                    | comments = Dict.update postId removePostComment model.comments
                    , posts = List.map (setPostComments postId <| numberOfPostComments - 1) model.posts
                }
                    ! []


setPostComments : String -> Int -> Post -> Post
setPostComments postId numberOfComments post =
    if post.id == postId then
        { post | comments = numberOfComments }
    else
        post


getNumberOfPostComments : String -> Dict String (List Comment) -> Int
getNumberOfPostComments postId comments =
    case Dict.get postId comments of
        Just postComments ->
            List.length postComments

        Nothing ->
            0



-- URL PARSER


toUrl : Page -> String
toUrl page =
    case page of
        Photos ->
            "/"

        Photo postId ->
            "/view/" ++ postId


pathParser : Navigation.Location -> Msg
pathParser location =
    NavigatedTo <|
        UrlParser.parsePath pageParser location


pageParser : Parser (Page -> a) a
pageParser =
    oneOf
        [ map Photos <| s ""
        , map Photo <| s "view" </> string
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
