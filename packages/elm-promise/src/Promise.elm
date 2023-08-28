module Promise exposing
    ( Error(..)
    , Promise
    , createPromise
    , createPromiseModule
    , execute
    , expectJson
    , expectWhatever
    , withExpect
    )

import Http
import Json.Decode as D
import Json.Encode as E


type Error
    = UnknownError
    | BadRequest String
    | Timeout
    | BadStatus Int String
    | BadBody String


type PromiseExpect a msg
    = Whatever (Result Error () -> msg)
    | Json (Result Error a -> msg) (D.Decoder a)


createPromiseModule : String -> Promise a ()
createPromiseModule nameSpace =
    { nameSpace = nameSpace
    , method = "GET"
    , url = ""
    , expect = Whatever (\_ -> ())
    }


createPromise : String -> Promise () msg -> Promise () msg
createPromise url promise =
    { promise | url = url }


withExpect : PromiseExpect a b -> Promise c msg -> Promise a b
withExpect f promise =
    { url = promise.url
    , method = promise.method
    , nameSpace = promise.nameSpace
    , expect = f
    }


expectJson : (Result Error a -> msg) -> D.Decoder a -> PromiseExpect a msg
expectJson =
    Json


expectWhatever : (Result Error () -> msg) -> PromiseExpect () msg
expectWhatever =
    Whatever


toHttpExpect : PromiseExpect a msg -> Http.Expect msg
toHttpExpect expect =
    case expect of
        Whatever hnd ->
            Http.expectStringResponse hnd <|
                \response ->
                    case response of
                        Http.BadUrl_ url ->
                            Err (BadRequest <| "Bad URL: " ++ url)

                        Http.Timeout_ ->
                            Err Timeout

                        Http.NetworkError_ ->
                            Err UnknownError

                        Http.BadStatus_ metadata body ->
                            Err (BadStatus metadata.statusCode body)

                        Http.GoodStatus_ metadata body ->
                            Ok ()

        Json hnd decoder ->
            Http.expectStringResponse hnd <|
                \response ->
                    case response of
                        Http.BadUrl_ url ->
                            Err (BadRequest <| "Bad URL: " ++ url)

                        Http.Timeout_ ->
                            Err Timeout

                        Http.NetworkError_ ->
                            Err UnknownError

                        Http.BadStatus_ metadata body ->
                            Err (BadStatus metadata.statusCode body)

                        Http.GoodStatus_ metadata body ->
                            case D.decodeString decoder (Debug.log "BODY" body) of
                                Ok value ->
                                    Ok value

                                Err err ->
                                    Err (BadBody (D.errorToString err))


type alias Promise a msg =
    { nameSpace : String
    , method : String
    , url : String
    , expect : PromiseExpect a msg
    }


execute : Promise a msg -> Cmd msg
execute p =
    Http.request
        { method = p.nameSpace
        , headers = []
        , url = "/"
        , body =
            Http.jsonBody
                (E.object
                    [ ( "headers", E.object [] )
                    , ( "method", E.string p.method )
                    , ( "url", E.string p.url )
                    ]
                )
        , expect = toHttpExpect p.expect
        , timeout = Nothing
        , tracker = Nothing
        }
