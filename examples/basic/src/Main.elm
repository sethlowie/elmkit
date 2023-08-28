module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Json.Decode as D
import Promise


type alias Waffles =
    { waffles : String
    }


decodeWaffles : D.Decoder Waffles
decodeWaffles =
    D.map Waffles
        (D.field "waffles" D.string)


customModule : Promise.Promise a ()
customModule =
    Promise.createPromiseModule "some-custom-key"


wafflesPromise : Promise.Promise Waffles Msg
wafflesPromise =
    customModule
        |> Promise.createPromise "/waffles"
        |> Promise.withExpect (Promise.expectJson GotMsg decodeWaffles)


type alias Model =
    { message : String
    }


type Msg
    = GotMsg (Result Promise.Error Waffles)


init : () -> ( Model, Cmd Msg )
init _ =
    ( { message = "" }
    , wafflesPromise
        |> Promise.execute
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotMsg (Ok waffles) ->
            ( { model | message = waffles.waffles }
            , Cmd.none
            )

        GotMsg (Err err) ->
            ( { model | message = "Error: getting message" }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 []
            [ text "Basic Example"
            ]
        , div []
            [ text model.message
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
