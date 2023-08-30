module Components.TextField exposing (config, view, withError, withOnChange, withPlaceholder, withValue)

import Html exposing (Html, div, input, label, span, text)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events


type alias Config msg =
    { label : String
    , value : String
    , placeholder : String
    , onChange : Maybe (String -> msg)
    , error : Maybe String
    }


config : String -> Config msg
config label =
    { label = label
    , value = ""
    , placeholder = ""
    , onChange = Nothing
    , error = Nothing
    }


withError : String -> Config msg -> Config msg
withError error c =
    { c | error = Just error }


withValue : String -> Config msg -> Config msg
withValue value c =
    { c | value = value }


withOnChange : (String -> msg) -> Config msg -> Config msg
withOnChange onChange c =
    { c | onChange = Just onChange }


withPlaceholder : String -> Config msg -> Config msg
withPlaceholder placeholder c =
    { c | placeholder = placeholder }


view : Config msg -> Html msg
view c =
    div
        [ class "form-control w-full max-w-xs"
        ]
        [ label
            [ class "label"
            ]
            [ span
                [ class "label-text"
                ]
                [ text "What is your name?" ]
            ]
        , input
            ([ type_ "text"
             , placeholder c.placeholder
             , class "input input-bordered w-full max-w-xs"
             , value c.value
             ]
                ++ (case c.onChange of
                        Just onChange ->
                            [ Html.Events.onInput onChange ]

                        Nothing ->
                            []
                   )
            )
            []
        , case c.error of
            Just error ->
                label
                    [ class "label"
                    ]
                    [ span
                        [ class "label-text-alt text-red-600"
                        ]
                        [ text error ]
                    ]

            Nothing ->
                div [] []
        ]
