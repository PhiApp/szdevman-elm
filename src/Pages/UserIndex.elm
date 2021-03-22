
module Pages.UserIndex exposing (..)

import Url
import Url.Parser 
import Browser.Navigation as Nav
import Browser exposing (UrlRequest)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error(..))



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model = 
    { navKey: Nav.Key
    , users: List String
    }


init flags url key =
    ( {navKey=key, users=["o", "p"] }, Cmd.none )





-- ---------------------------
-- UPDATE
-- ---------------------------

type Msg = 
    Test


update msg model = 
    (model, Cmd.none)


-- ---------------------------
-- VIEW
-- ---------------------------

view: Model -> Html msg
view model = 
    div [] [text "UserIndex"]


toNavKey model =
    model.navKey
