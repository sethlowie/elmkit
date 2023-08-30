module Main exposing (main)

import Browser
import Components.Button as Button
import Components.Heading as Heading
import Components.Paragraph as Paragraph
import Components.TextField as TextField
import Html exposing (Html, a, div, form, h1, img, p, text)
import Html.Attributes exposing (alt, class, href, id, src, target)
import Html.Events exposing (onSubmit)
import Json.Decode as D
import Json.Encode as E
import Tauri.Invoke as Invoke


greetName name =
    Invoke.command "greet"
        |> Invoke.withExpect (Invoke.expectString GotGreetName)
        |> Invoke.withArgs
            [ ( "name", E.string name )
            ]
        |> Invoke.execute



-- MODEL


type alias Model =
    { greetName : String
    , greetResponse : String
    }


initialModel : Model
initialModel =
    { greetName = ""
    , greetResponse = ""
    }


type alias GreetName =
    { name : String
    }


decodeGreetName : D.Decoder GreetName
decodeGreetName =
    D.map GreetName
        (D.field "name" D.string)



-- MSG


type Msg
    = UpdateGreetName String
    | SubmitName
    | GotGreetName (Result Invoke.Error String)


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "MSG" msg of
        UpdateGreetName name ->
            ( { model | greetName = name }, Cmd.none )

        SubmitName ->
            ( model
            , greetName model.greetName
            )

        GotGreetName (Ok greet) ->
            ( { model | greetResponse = greet }, Cmd.none )

        GotGreetName (Err err) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div
        [ class "flex flex-col gap-4 items-center justify-center h-screen -mt-20"
        ]
        [ h1
            [ class "text-xl"
            ]
            [ text "Welcome to Tauri!" ]
        , Heading.config "Welcome to Tauri!"
            |> Heading.withLevel 1
            |> Heading.view
        , div
            [ class "flex gap-4"
            ]
            [ a
                [ href "https://vitejs.dev"
                , target "_blank"
                ]
                [ img
                    [ src "/src/assets/vite.svg"
                    , class "w-24 hover:drop-shadow-[0_0_2em_#747bff]"
                    , alt "Vite logo"
                    ]
                    []
                ]
            , a
                [ href "https://elm-lang.org/"
                , target "_blank"
                ]
                [ img
                    [ src "/src/assets/Elm_logo.png"
                    , class "logo elm w-24 "
                    , class "w-24 hover:drop-shadow-[0_0_2em_#2F8F45]"
                    , alt "Elm logo"
                    ]
                    []
                ]
            , a
                [ href "https://tauri.app"
                , target "_blank"
                ]
                [ img
                    [ src "/src/assets/tauri.svg"
                    , class "w-24 hover:drop-shadow-[0_0_2em_#24c8db]"
                    , alt "Tauri logo"
                    ]
                    []
                ]
            , a
                [ href "https://www.typescriptlang.org/docs"
                , target "_blank"
                ]
                [ img
                    [ src "/src/assets/typescript.svg"
                    , class "w-24 hover:drop-shadow-[0_0_2em_#2d79c7]"
                    , alt "typescript logo"
                    ]
                    []
                ]
            ]
        , Paragraph.config "Click on the Tauri logo to learn more about the framework"
            |> Paragraph.view
        , form
            [ class "flex gap-2"
            , id "greet-form"
            , onSubmit SubmitName
            ]
            [ TextField.config "Enter a name..."
                |> TextField.withValue model.greetName
                |> TextField.withPlaceholder "Enter a name..."
                |> TextField.withOnChange UpdateGreetName
                |> TextField.view
            , Button.config "Greet"
                |> Button.withClass "flex self-end"
                |> Button.withPrimary
                |> Button.view
            ]
        , p
            [ id "greet-msg"
            ]
            []
        , Paragraph.config model.greetResponse
            |> Paragraph.view
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
