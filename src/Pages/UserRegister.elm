port module Pages.UserRegister exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error(..))

import Url
import Url.Parser as Parser
import Browser.Navigation as Nav
import Browser exposing (UrlRequest)
import Json.Decode as Decode


-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : String -> Cmd msg

-- ---------------------------
-- MODEL
-- ---------------------------


init : Int -> Nav.Key -> ( Model, Cmd Msg )
init flags key =
    ( {navKey= key, counter = flags, serverMessage = "" }, Cmd.none )




type alias Model = 
    { navKey : Nav.Key
    , counter : Int
    , serverMessage : String
    }
    
-- ---------------------------
-- UPDATE
-- ---------------------------

type Msg
    = Inc
    | TestServer
    | OnServerResponse (Result Http.Error String)


update message model =
    case message of
        Inc ->
            ( add1 model, toJs "Inc" )

        TestServer ->
            let
                expect =
                    Http.expectJson OnServerResponse (Decode.field "result" Decode.string)
            in
            ( model
            , Http.get { url = "/test", expect = expect }
            )

        OnServerResponse res ->
            case res of
                Ok r ->
                    ( { model | serverMessage = r }, Cmd.none )

                Err err ->
                    ( { model | serverMessage = "Error: " ++ httpErrorToString err }, Cmd.none )



httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        BadUrl url ->
            "BadUrl: " ++ url

        Timeout ->
            "Timeout"

        NetworkError ->
            "NetworkError"

        BadStatus _ ->
            "BadStatus"

        BadBody s ->
            "BadBody: " ++ s


{-| increments the counter

    add1 5 --> 6

-}
add1 : Model -> Model
add1 model =
    { model | counter = model.counter + 1 }


-- ---------------------------
-- VIEW
-- ---------------------------

view: Model -> Html Msg
view model =
    div [] 
    [   div [ class "container" ]
        [ header [ class "pure-g" ]
            [ h1 [ class "pure-u-4-5" ] [ text "Elm 0.19.1 Webpack Starter, with hot-reloading" ]
            ]
        , p [] [ text "Click on the button below to increment the state." ]
        , div [ class "pure-g" ]
            [ div [ class "pure-u-1-3" ]
                [ button
                    [ class "pure-button pure-button-primary"
                    , onClick Inc
                    ]
                    [ text "+ 1" ]
                , text <| String.fromInt model.counter
                ]
            , div [ class "pure-u-1-3" ] []
            , div [ class "pure-u-1-3" ]
                [ button
                    [ class "pure-button pure-button-primary"
                    , onClick TestServer
                    ]
                    [ text "ping dev server" ]
                , text model.serverMessage
                ]
            ]
        , p [] [ text "Then make a change to the source code and see how the state is retained after recompilation." ]
        , p []
            [ text "And now don't forget to add a star to the Github repo "
            , a [ href "https://github.com/simonh1000/elm-webpack-starter" ] [ text "elm-webpack-starter" ]
            ]
        , Html.form [ class "pure-form pure-form-stacked"] 
        [ fieldset [] 
            [ legend [] [ text "Bitte gebe deine Benutzerdaten ein:" ]
            , label [ for "stacked-email" ] [ text "Email" ]
            , input [ Html.Attributes.type_ "email"
                , id "stacked-email"
                , placeholder "Email"
                ] []
            , span [class "pure-form-message"] [ text "This is a required field." ]
            , label [ for "stacked-password" ] [ text "Password" ]
            , input [ Html.Attributes.type_ "password"
                , id "stacked-password"
                , placeholder "Password" ] []
            ]
            , button [ Html.Attributes.type_ "submit"
                , class "pure-button pure-button-primary" ] [ text "Sign in"]
            ] 
        ]
       
    ]



-- ---------------------------
-- EXPORT
-- ---------------------------

toNavKey model = 
    model.navKey