module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket


serverAddress =
    "ws://127.0.0.1:1337"



---- MODEL ----


type alias Model =
    { messageToSend : String
    , messageReceived : String
    }


init : ( Model, Cmd Msg )
init =
    ( { messageToSend = ""
      , messageReceived = "Nothing yet."
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = GotMessage String
    | UpdateMessageToSend String
    | SendMessage

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotMessage message ->
            ( { model | messageReceived = message }, Cmd.none)

        UpdateMessageToSend message ->
            ( { model | messageToSend = message }, Cmd.none)

        SendMessage ->
            let
                cmd = WebSocket.send serverAddress model.messageToSend
            in
                ( { model | messageToSend = ""}, cmd )

---- VIEW ----


displayMessageToSend : Model -> Html Msg
displayMessageToSend model =
    div [] [
            label [][text "Mesage:"]
            , input [onInput UpdateMessageToSend][text model.messageToSend]
        ]


displayMessageReceived : Model -> Html Msg
displayMessageReceived model =
    div [] [ text model.messageReceived ]


displaySendButton : Model -> Html Msg
displaySendButton model =
    button [onClick SendMessage][text "Send"]

view : Model -> Html Msg
view model =
    div
        []
        [ displayMessageToSend model
        , displaySendButton model
        , displayMessageReceived model
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        sub =
            WebSocket.listen serverAddress GotMessage
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
