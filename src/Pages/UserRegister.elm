port module Pages.UserRegister exposing (..)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http exposing (..)
import Json.Encode as Encode



-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : String -> Cmd msg



-- ---------------------------
-- MODEL
-- ---------------------------


init : Int -> Nav.Key -> ( Model, Cmd Msg )
init flags key =
    ( { navKey = key, serverMessage = "", httpError = None, email = "", password = "", name = "" }, Cmd.none )


type alias Model =
    { navKey : Nav.Key
    , serverMessage : String
    , name : String
    , email : String
    , password : String
    , httpError : HttpNotification
    }



-- ---------------------------
-- UPDATE
-- ---------------------------


type InputType
    = Name
    | Email
    | Password


type Msg
    = TestServer
    | OnServerResponse (Result Http.Error String)
    | UpdateInput InputType String


type HttpNotification
    = None
    | Success
    | Error


postUser user =
    Http.post
        { url = "/api/users/"
        , body = Http.jsonBody (userEncode user)
        , expect = Http.expectString OnServerResponse
        }


userEncode user =
    Encode.object
        [ ( "Name", Encode.string user.name )
        , ( "Email", Encode.string user.email )
        , ( "Password", Encode.string user.password )
        ]


resetInput : Model -> Model
resetInput model =
    { model | name = "", password = "", email = "" }


update message model =
    case message of
        TestServer ->
            ( model, postUser { name = model.password, email = model.email, password = model.password } )

        OnServerResponse res ->
            case res of
                Ok _ ->
                    ( { model | httpError = Success, serverMessage = "User created!" }, Cmd.none )

                Err err ->
                    ( { model | serverMessage = "Error: " ++ httpErrorToString err, httpError = Error }, Cmd.none )

        UpdateInput inputType inputValue ->
            ( case inputType of
                Name ->
                    { model | name = inputValue }

                Email ->
                    { model | email = inputValue }

                Password ->
                    { model | password = inputValue }
            , Cmd.none
            )


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
            "BadStatus: " ++ String.fromInt status

        BadBody s ->
            "BadBody: " ++ s



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
                        , value model.name
                        , onInput (UpdateInput Name)
                        ]
                        []
                    , label [ for "stacked-email" ] [ text "Email" ]
                    , input
                        [ Html.Attributes.type_ "email"
                        , id "stacked-email"
                        , placeholder "Email"
                        , name "Email"
                        , value model.email
                        , onInput (UpdateInput Email)
                        ]
                        []
                    , span [ class "pure-form-message" ] [ text "This is a required field." ]
                    , label [ for "stacked-password" ] [ text "Password" ]
                    , input
                        [ Html.Attributes.type_ "password"
                        , id "stacked-password"
                        , placeholder "Password"
                        , name "Password"
                        , value model.password
                        , onInput (UpdateInput Password)
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
