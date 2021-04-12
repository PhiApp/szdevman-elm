module Pages.NotFound exposing (..)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (Error(..))




type alias Model = Nav.Key

init key =
    ( key, Cmd.none )



-- ---------------------------
-- UPDATE
-- ---------------------------

type Msg = 
    Test


-- ---------------------------
-- VIEW
-- ---------------------------

view: Model -> Html msg
view _ = 
    div [] [text "404 - Page Not Fount"]
    



-- ---------------------------
-- EXPORT
-- ---------------------------


toNavKey : Model -> Model
toNavKey model =
    model