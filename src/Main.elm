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

import Pages.UserIndex
import Pages.UserRegister
import Pages.NotFound





-- ---------------------------
-- ROUTES
-- ---------------------------


type Route
  = UserIndexRoute
  | UserRegisterRoute
  | NotFoundRoute


routeParser : Parser.Parser (Route -> a) a
routeParser =
  Parser.oneOf
    [ Parser.map UserIndexRoute  (Parser.s "user" )
    , Parser.map UserRegisterRoute Parser.top
    ]

toRoute : Url.Url -> Route
toRoute url =
   Maybe.withDefault NotFoundRoute (Parser.parse routeParser url)


toNavKey: Model -> Nav.Key
toNavKey model = 
    case model of 
        UserRegisterModel userRegisterModel -> Pages.UserRegister.toNavKey userRegisterModel
        UserIndexModel userIndexModel -> Pages.UserIndex.toNavKey userIndexModel
        NotFoundModel notFoundModel -> Pages.NotFound.toNavKey notFoundModel



-- ---------------------------
-- MODEL
-- ---------------------------


type Model = 
    UserRegisterModel Pages.UserRegister.Model
    | NotFoundModel Pages.NotFound.Model
    | UserIndexModel Pages.UserIndex.Model


init flags url key =
    Pages.UserRegister.init flags url key 
        |> updateWith UserRegisterModel UserRegisterMsg (UserRegisterModel {navKey= key, counter = flags, serverMessage = "" })


-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = UrlClicked UrlRequest
    | UrlChanged Url.Url
    | UserRegisterMsg Pages.UserRegister.Msg
    | UserIndexMsg Pages.UserIndex.Msg
    | NotFoundMsg Pages.NotFound.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case (message, model) of
        (UserRegisterMsg subMsg, UserRegisterModel subModel) -> 
            Pages.UserRegister.update subMsg subModel
                |> updateWith UserRegisterModel UserRegisterMsg model

        (UserIndexMsg subMsg, UserIndexModel subModel) ->
            Pages.UserIndex.update subMsg subModel
                |> updateWith UserIndexModel UserIndexMsg model

        (NotFoundMsg subMsg, NotFoundModel subModel) ->
            Pages.UserIndex.update subMsg subModel
                |> updateWith NotFoundModel UserIndexMsg model

        (UrlClicked urlRequest, _) -> 
            case urlRequest of 
                Browser.Internal url ->
                    ( model, Nav.pushUrl (toNavKey model) (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        (UrlChanged url, _) ->
            case toRoute url of 
                UserIndexRoute ->
                    Pages.UserIndex.init () url (toNavKey model)|> updateWith UserIndexModel UserIndexMsg model
                
                UserRegisterRoute -> 
                    Pages.UserRegister.init 3 url (toNavKey model) |> updateWith UserRegisterModel UserRegisterMsg model
                
                NotFoundRoute -> 
                    Pages.NotFound.init () url (toNavKey model) |> updateWith NotFoundModel NotFoundMsg model
        
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
viewPage page toMsg =
    Html.map toMsg page

view : Model -> Html Msg
view model =
    case model of 
        UserRegisterModel subModel ->
            viewPage (Pages.UserRegister.view subModel) UserRegisterMsg

        NotFoundModel subModel ->
            viewPage (Pages.NotFound.view subModel) NotFoundMsg


        UserIndexModel subModel ->
            viewPage (Pages.UserIndex.view subModel) UserIndexMsg



-- ---------------------------
-- MAIN
-- ---------------------------

uc url =
    UrlChanged

ur url = 
    UrlClicked


main : Program Int Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view =
            \m ->
                { title = "szdevman :: register"
                , body = [ view m ]
                }
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = UrlClicked 
        , onUrlChange = UrlChanged 
        }
