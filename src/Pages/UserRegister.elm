port module Pages.UserRegister exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (..)
import Json.Decode as Decode exposing (null)
import Json.Encode as Encode
import Url
import Url.Parser as Parser
import Debug exposing (toString)



-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : String -> Cmd msg



-- ---------------------------
-- MODEL
-- ---------------------------


init : Int -> Nav.Key -> ( Model, Cmd Msg )
init flags key =
    ( { navKey = key, counter = flags, serverMessage = "", httpError = None, email = "", password = "", name = "" }, Cmd.none )


type alias Model =
    { navKey : Nav.Key
    , counter : Int
    , serverMessage : String
    , name : String
    , email : String
    , password : String
    , httpError : HttpNotification
    }

-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = Inc
    | TestServer
    | OnServerResponse (Result Http.Error String)


type HttpNotification
    = None
    | Success
    | Error


postUser user =
    Http.post
        { url = "/api/users/"
        , body = Http.jsonBody (userEncode user)
        , expect = Http.expectJson OnServerResponse (Decode.field "result" Decode.string)
        }


userEncode user =
    Encode.object
        [ ( "Name", Encode.string user.name )
        , ( "Email", Encode.string user.email )
        , ( "Password", Encode.string user.password )
        ]


update message model =
    case message of
        Inc ->
            ( add1 model, toJs "Inc" )

        TestServer ->
            ( model, postUser { name = "awd", email = "awd", password = "" } )

        OnServerResponse res ->
            case res of
                Ok r ->
                    ( { model | httpError = Success, serverMessage = "User created!" }, Cmd.none )

                Err err ->
                    ( { model | serverMessage = "Error: " ++ httpErrorToString err, httpError = Error }, Cmd.none )


httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        BadUrl url ->
            "BadUrl: " ++ url

        Timeout ->
            "Timeout"

        NetworkError ->
            "NetworkError"

        BadStatus status ->
            "BadStatus: " ++ toString status

        BadBody s ->
            "BadBody: " ++ s


add1 : Model -> Model
add1 model =
    { model | counter = model.counter + 1 }



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view model =
    div []
        [ div [ class "container" ]
            [ Html.header [ class "pure-g" ]
                [ h1 [ class "pure-u-4-5" ] [ text "User register" ]
                ]
            , div
                [ class "notification"
                , classList
                    [ ( "success", model.httpError == Success )
                    , ( "error", model.httpError == Error )
                    ]
                ]
                [ text model.serverMessage ]
            , Html.form
                [ class "pure-form pure-form-stacked"
                ]
                [ fieldset []
                    [ legend [] [ text "Please enter your username:" ]
                    , label [ for "stacked-name" ] [ text "Name" ]
                    , input
                        [ Html.Attributes.type_ "text"
                        , id "stacked-name"
                        , placeholder "Name"
                        , name "Name"
                        ]
                        []
                    , label [ for "stacked-email" ] [ text "Email" ]
                    , input
                        [ Html.Attributes.type_ "email"
                        , id "stacked-email"
                        , placeholder "Email"
                        , name "Email"
                        ]
                        []
                    , span [ class "pure-form-message" ] [ text "This is a required field." ]
                    , label [ for "stacked-password" ] [ text "Password" ]
                    , input
                        [ Html.Attributes.type_ "password"
                        , id "stacked-password"
                        , placeholder "Password"
                        , name "Password"
                        ]
                        []
                    ]
                ]
            , button
                [ Html.Attributes.type_ "submit"
                , class "pure-button pure-button-primary"
                , onClick TestServer
                ]
                [ text "Sign in" ]
            ]
        ]



-- ---------------------------
-- EXPORT
-- ---------------------------


toNavKey model =
    model.navKey
