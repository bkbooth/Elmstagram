module State exposing (..)

import Navigation
import UrlParser exposing (..)
import Types exposing (..)
import Rest


init : Navigation.Location -> (Model, Cmd Msg)
init location =
    case UrlParser.parseHash pageParser location of
        Just page ->
            initialModel page
                ! [ Rest.getPosts
                  ]

        Nothing ->
            initialModel ListOfPosts
                ! [ Rest.getPosts
                  , Navigation.modifyUrl <| toUrl ListOfPosts
                  ]


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FetchPosts (Ok posts) ->
            { model | posts = posts } ! []

        FetchPosts (Err _) ->
            model ! []

        NavigatedTo maybePage ->
            case maybePage of
                Just page ->
                    { model | page = page }
                        ! []

                Nothing ->
                    model
                        ! [ Navigation.newUrl <| toUrl ListOfPosts
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


hashParser : Navigation.Location -> Msg
hashParser location =
    NavigatedTo <|
        UrlParser.parseHash pageParser location


pageParser : Parser (Page -> a) a
pageParser =
    oneOf
        [ map ListOfPosts <| s ""
        , map SinglePost <| s "view" </> string
        ]


toUrl : Page -> String
toUrl page =
    case page of
        ListOfPosts ->
            "#/"

        SinglePost postId ->
            "#/view/" ++ postId


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
