module Components.Paragraph exposing
    ( Config
    , config
    , view
    , withSmall
    )

import Html exposing (Html, p, text)
import Html.Attributes exposing (class)


type alias Config =
    { content : String
    , small : Bool
    }


config : String -> Config
config content =
    { content = content
    , small = False
    }


withSmall : Config -> Config
withSmall c =
    { c | small = True }


view : Config -> Html msg
view { content, small } =
    let
        classes =
            if small then
                "text-sm"

            else
                "text-base"
    in
    p [ class classes ] [ text content ]
