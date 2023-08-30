module Tauri.Invoke exposing
    ( Error
    , command
    , execute
    , expectJson
    , expectString
    , withArgs
    , withExpect
    )

import Json.Encode as E
import Promise exposing (Promise)
import Tauri exposing (tauri)


type alias Invoke a msg =
    { command : String
    , args : Maybe (List ( String, E.Value ))
    , expect : Promise.PromiseExpect a msg
    }


command : String -> Invoke () ()
command cmd =
    { command = cmd
    , args = Nothing
    , expect = Promise.expectWhatever (\_ -> ())
    }



-- withExpect : PromiseExpect a b -> Promise c msg -> Promise a b


withExpect : Promise.PromiseExpect a b -> Invoke c msg -> Invoke a b
withExpect e i =
    { command = i.command
    , args = i.args
    , expect = e
    }


expectJson =
    Promise.expectJson


expectString =
    Promise.expectString


type alias Error =
    Promise.Error


execute : Invoke a msg -> Cmd msg
execute i =
    tauri
        |> Promise.createPromise "invoke"
        |> Promise.withBody
            (E.object
                [ ( "command", E.string i.command )
                , ( "args", Maybe.withDefault E.null (Maybe.map E.object i.args) )
                ]
            )
        |> Promise.withExpect i.expect
        |> Promise.execute


withArgs : List ( String, E.Value ) -> Invoke a msg -> Invoke a msg
withArgs value i =
    { i | args = Just value }
