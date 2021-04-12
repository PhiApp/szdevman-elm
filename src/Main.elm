module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error(..))
import Url
import Url.Parser as Parser
import Browser.Navigation as Nav
import Browser exposing (UrlRequest)

import Pages.UserList
import Pages.UserRegister
import Pages.NotFound
import Browser exposing (Document)
import Browser.Navigation exposing (Key)





-- ---------------------------
-- ROUTES
-- ---------------------------


type Route
  = UserListRoute
  | UserRegisterRoute
  | NotFoundRoute


routeParser : Parser.Parser (Route -> a) a
routeParser =
  Parser.oneOf
    [ Parser.map UserListRoute  (Parser.s "user_list" )
    , Parser.map UserRegisterRoute (Parser.top)
    ]

toRoute : Url.Url -> Route
toRoute url =
   Maybe.withDefault NotFoundRoute (Parser.parse routeParser url)


toNavKey: Model -> Nav.Key
toNavKey model = 
    case model of 
        UserRegisterModel userRegisterModel -> Pages.UserRegister.toNavKey userRegisterModel
        UserListModel userListModel -> Pages.UserList.toNavKey userListModel
        NotFoundModel notFoundModel -> Pages.NotFound.toNavKey notFoundModel



-- ---------------------------
-- MODEL
-- ---------------------------


type Model = 
    UserRegisterModel Pages.UserRegister.Model
    | NotFoundModel Pages.NotFound.Model
    | UserListModel Pages.UserList.Model


init : Int -> Url.Url -> Key -> (Model, Cmd Msg)
init flags url key =
    let (submodel,cmd) = Pages.NotFound.init key
    in update (UrlChanged url) (NotFoundModel submodel)  
    


-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = UrlClicked UrlRequest
    | UrlChanged Url.Url
    | UserRegisterMsg Pages.UserRegister.Msg
    | UserListMsg Pages.UserList.Msg
    | NotFoundMsg Pages.NotFound.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case (message, model) of
        (UserRegisterMsg subMsg, UserRegisterModel subModel) -> 
            Pages.UserRegister.update subMsg subModel
                |> updateWith UserRegisterModel UserRegisterMsg model

        (UserListMsg subMsg, UserListModel subModel) ->
            Pages.UserList.update subMsg subModel
                |> updateWith UserListModel UserListMsg model

        (NotFoundMsg subMsg, NotFoundModel subModel) ->
            (NotFoundModel subModel, Cmd.none)

        (UrlClicked urlRequest, _) -> 
            case urlRequest of 
                Browser.Internal url ->
                    ( model, Nav.pushUrl (toNavKey model) (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        (UrlChanged url, _) ->
            case toRoute url of 
                UserListRoute ->
                    Debug.log("userlistroute")
                    Pages.UserList.init (toNavKey model)
                        |> updateWith UserListModel UserListMsg model
                
                UserRegisterRoute -> 
                    Debug.log("userRegisterRoute")
                    Pages.UserRegister.init 3 (toNavKey model) 
                        |> updateWith UserRegisterModel UserRegisterMsg model
                
                NotFoundRoute -> 
                    Debug.log("notfoundroute")
                    Pages.NotFound.init (toNavKey model) 
                        |> updateWith NotFoundModel NotFoundMsg model
        
        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )

-- ---------------------------
-- VIEW
-- ---------------------------


view model = 
    { title = render_title model
    , body = view_html model }

render_title model = 
    case model of 
        UserRegisterModel _ -> "szdevman :: Register User"
        UserListModel _ -> "szdevman :: List User"
        NotFoundModel _ -> "Not Found"


view_html model = 
    [ insert_navbar model
    , case model of 
        UserRegisterModel subModel ->
            viewPage (Pages.UserRegister.view subModel) UserRegisterMsg

        NotFoundModel subModel ->
            viewPage (Pages.NotFound.view subModel) NotFoundMsg
            
        UserListModel subModel ->
            viewPage (Pages.UserList.view subModel) UserListMsg
    ]


viewPage : Html a -> (a -> msg) -> Html msg
viewPage page toMsg =
    Html.map toMsg page

insert_navbar : Model -> Html msg
insert_navbar model = 
    div [ class "pure-menu pure-menu-horizontal" ]
            [ -- a 
                -- [ class "pure-menu-heading pure-menu-link"
                -- , href "#"
                -- ]
                -- [ text "SzDevMan" ],
             ul [ class "pure-menu-list" ] 
            [ li [ class "pure-menu-list" ]
                [ a 
                    [ class "pure-menu-link"
                    , href "/"
                    ]
                    [ text "Register" 
                    ]
                ]
                , li [ class "pure-menu-list" ]
                [ a 
                    [ class "pure-menu-link"
                    , href "user_list"
                    ]
                    [ text "UserList" 
                    ]
                ]
            ]
        ]


-- ---------------------------
-- MAIN
-- ---------------------------

main : Program Int Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = UrlClicked 
        , onUrlChange = UrlChanged 
        }
