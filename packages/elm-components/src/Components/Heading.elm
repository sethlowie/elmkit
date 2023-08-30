module Components.Heading exposing (Config, config, view, withLevel)

import Html exposing (Html, h1, h2, h3, h4, h5, h6, text)
import Html.Attributes exposing (class)


type alias Config =
    { content : String
    , level : Int
    }


config : String -> Config
config content =
    { content = content
    , level = 1
    }


withLevel : Int -> Config -> Config
withLevel lvl c =
    { c | level = lvl }


view : Config -> Html msg
view { content, level } =
    let
        classes =
            case level of
                1 ->
                    "font-semibold text-5xl"

                2 ->
                    "font-semibold text-4xl"

                3 ->
                    "font-semibold text-3xl"

                4 ->
                    "font-semibold text-2xl"

                5 ->
                    "font-semibold text-lg"

                6 ->
                    "font-semibold text-md"

                _ ->
                    "font-medium"
    in
    case level of
        1 ->
            h1 [ class classes ] [ text content ]

        2 ->
            h2 [ class classes ] [ text content ]

        3 ->
            h3 [ class classes ] [ text content ]

        4 ->
            h4 [ class classes ] [ text content ]

        5 ->
            h5 [ class classes ] [ text content ]

        6 ->
            h6 [ class classes ] [ text content ]

        _ ->
            h1 [ class classes ] [ text content ]
