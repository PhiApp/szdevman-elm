module Pages.NotFound exposing (..)

import Url
import Url.Parser 
import Browser.Navigation as Nav
import Browser exposing (UrlRequest)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error(..))




type alias Model = 
    { navKey: Nav.Key
    }

init flags url key =
    ( { navKey=key }, Cmd.none )



-- ---------------------------
-- UPDATE
-- ---------------------------

type Msg = 
    Test





-- ---------------------------
-- VIEW
-- ---------------------------

view: Model -> Html msg
view model = 
    div [] [text "UserIndex"]
    



-- ---------------------------
-- EXPORT
-- ---------------------------


toNavKey model =
    model.navKey