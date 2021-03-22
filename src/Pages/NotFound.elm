module Pages.NotFound exposing (..)

import Browser.Navigation as Nav



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



toNavKey model =
    model.navKey
