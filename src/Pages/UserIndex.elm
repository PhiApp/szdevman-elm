
module Pages.UserIndex exposing (..)

import Url
import Url.Parser as Parser
import Browser.Navigation as Nav
import Browser exposing (UrlRequest)


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

toNavKey model =
    model.navKey
