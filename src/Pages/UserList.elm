
module Pages.UserList exposing (..)

import Browser.Navigation as Nav
import Browser exposing (UrlRequest)
import Html exposing (tr, Html, text, table, th, td, thead, tbody, div, h1, p)
import Html.Attributes exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode

-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model = 
    { navKey: Nav.Key
    , users: UserState
    }

type UserState = Users (List User) | Loading | Error Http.Error

type alias User = 
    { name: String
    , email: String
    , password: String
    }


init : Nav.Key -> (Model, Cmd Msg)
init key =
    ( {navKey=key, users=Loading }, getUsers )


-- ---------------------------
-- HTTP
-- ---------------------------

getUsers : Cmd Msg
getUsers =
  Http.get
    { url = "/api/users/"
    , expect = Http.expectJson GotUsers userDecoder
    }

-- postUser user = 
--     Http.post
--         { url = "/api/users"
--         , body = Http.jsonBody (userEncode user)
--         , expect = Http.expectJson GotUsers userDecoder
--         }

-- userEncode user =
--     Encode.object 
--         [ ("Name", Encode.string user.name)
--         , ("Email", Encode.string user.email)
--         , ("Password", Encode.string user.password)
--         ]
    

userDecoder: Decode.Decoder (List User)
userDecoder =
    (Decode.list (Decode.map3 User
        (Decode.field "Name" Decode.string)
        (Decode.field "Email" Decode.string)
        (Decode.field "Password" Decode.string)))


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


-- ---------------------------
-- UPDATE
-- ---------------------------

type Msg = 
    GotUsers (Result Http.Error (List User)) 


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        GotUsers result -> 
            case result of 
                Ok v -> ( {model| users = (Users v)}, Cmd.none)

                Err err -> ( {model| users = Error err}, Cmd.none)
  


-- ---------------------------
-- VIEW
-- ---------------------------

view: Model -> Html Msg
view model = 
    div [class "container"] 
        [ h1 [] [text "UserList"]
        , case model.users of 
            Users users ->
                renderUserTable users
            Error err ->
                p[style "color" "red"] 
                    [ text ("User table could not be loaded: " ++ (httpErrorToString err))] 
            Loading -> text "loading"
        ]


renderUserTable: List User -> Html Msg
renderUserTable userList =
    table [class "pure-table"]
        [ thead [] 
            [ tr []
                [ th [] [text "Name"]
                , th [] [text "Email"]
                , th [] [text "Password"]
                ]
            ] 
        , tbody [] (List.map renderUserRow userList)
        ]

renderUserRow : User -> Html Msg
renderUserRow user = 
    tr [] 
        [ th [] [text user.name]
        , th [] [text user.email]
        , th [] [text user.password]
        ]

-- ---------------------------
-- Navigation
-- ---------------------------
toNavKey model =
    model.navKey
