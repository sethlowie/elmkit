module Components.Button exposing
    ( Config
    , config
    , onClick
    , view
    , withClass
    , withPrimary
    )

import Html exposing (Html, button, div)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


type alias Config msg =
    { label : String
    , primary : Bool
    , onClickMsg : Maybe msg
    , class : String
    }


config : String -> Config msg
config label =
    { label = label
    , primary = False
    , onClickMsg = Nothing
    , class = ""
    }


withPrimary : Config msg -> Config msg
withPrimary c =
    { c | primary = True }


onClick : msg -> Config msg -> Config msg
onClick msg c =
    { c | onClickMsg = Just msg }


withClass : String -> Config msg -> Config msg
withClass cls c =
    { c | class = cls }


view : Config msg -> Html msg
view c =
    let
        primaryClass =
            if c.primary then
                "btn btn-primary"

            else
                "btn"
    in
    button
        (class (primaryClass ++ " " ++ c.class)
            :: (case c.onClickMsg of
                    Just msg ->
                        [ Html.Events.onClick msg ]

                    Nothing ->
                        []
               )
        )
        [ Html.text c.label ]
