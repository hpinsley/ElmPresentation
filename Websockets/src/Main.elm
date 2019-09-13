module Main exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import WebSocket

serverAddress = "ws://127.0.0.1:1337"

---- MODEL ----


type alias Model =
    {
        messageReceived: String
    }


init : ( Model, Cmd Msg )
init =
    ( {
        messageReceived = "Nothing yet."
    }, Cmd.none )



---- UPDATE ----


type Msg
    = Echo String



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [
            h1 [] [ text model.messageReceived ]
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    let
        sub = WebSocket.listen serverAddress Echo
    in
        sub

---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
