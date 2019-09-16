module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import Time exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)

type alias Username = String
type alias Color = String

sampleLoginMessage: String
sampleLoginMessage = """{"type":"color","data":"blue"}"""

sampleMessage: String
sampleMessage = """
{"type":"message","data":{"time":1568629623261,"text":"hi","author":"howard","color":"green"}}
"""

type LoginMessage =
    LoginMessage Color

type alias ChatData = {
    text: String
    , author: String
    , color: String
}

chatDataDecoder: Decoder ChatData
chatDataDecoder =
    decode ChatData
        |> Json.Decode.Pipeline.required "text" string
        |> Json.Decode.Pipeline.required "author" string
        |> Json.Decode.Pipeline.required "color" string

type alias ChatMessage =
    {
            type_: String
          , data: ChatData
    }

chatMessageDecoder: Decoder ChatMessage
chatMessageDecoder =
    decode ChatMessage
        |> Json.Decode.Pipeline.required "type" string
        |> Json.Decode.Pipeline.required "data" chatDataDecoder

loginDecoder: Decoder LoginMessage
loginDecoder =
    decode LoginMessage
    |> Json.Decode.Pipeline.required "data" string


serverAddress: String
serverAddress =
    "ws://127.0.0.1:1337"



---- MODEL ----

type LoginState
    = NotLoggedIn
    | LoggingInAs Username
    | LoggedIn Username Color


type alias Model =
    { loginState : LoginState
    , messageToSend : String
    , messageReceived : String
    }


init : ( Model, Cmd Msg )
init =
    ( { loginState = NotLoggedIn
      , messageToSend = ""
      , messageReceived = "Nothing yet."
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = Login
    | GotMessage String
    | UpdateMessageToSend String
    | SendMessage

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login ->
            let
                username =
                    model.messageToSend

                cmd =
                    WebSocket.send serverAddress username
            in
                ( { model | messageToSend = "", loginState = LoggingInAs username }, cmd )

        GotMessage message ->
            case model.loginState of
                LoggingInAs username ->
                    case decodeString loginDecoder message of
                        Err errMsg ->
                            ( { model | messageReceived = errMsg}, Cmd.none )
                        Ok (LoginMessage color) ->
                            ( { model | messageReceived = "Your color is " ++ color, loginState = LoggedIn username color}, Cmd.none)

                _ ->
                    case decodeString chatMessageDecoder message of
                        Err errMsg ->
                            ( { model | messageReceived = errMsg}, Cmd.none )
                        Ok chatMessage ->
                            ( { model | messageReceived = chatMessage.data.text }, Cmd.none )

        UpdateMessageToSend message ->
            ( { model | messageToSend = message }, Cmd.none )

        SendMessage ->
            let
                cmd =
                    WebSocket.send serverAddress model.messageToSend
            in
                ( { model | messageToSend = "" }, cmd )



---- VIEW ----


displayMessageToSend : Model -> Html Msg
displayMessageToSend model =
    let
        lbl =
            case model.loginState of
                NotLoggedIn ->
                    "Enter your username:"

                LoggingInAs username ->
                    "Attempting to login as " ++ username

                LoggedIn username color ->
                    username ++ " (" ++ color ++ "), enter message:"
    in
        div []
            [ label [] [ text lbl ]
            , input [ onInput UpdateMessageToSend, Html.Attributes.value model.messageToSend ] []
            ]


displayMessageReceived : Model -> Html Msg
displayMessageReceived model =
    div [] [ text model.messageReceived ]


displayActionButton : Model -> Html Msg
displayActionButton model =
    case model.loginState of
        NotLoggedIn ->
            button [ onClick Login ] [ text "Login" ]

        LoggedIn _ _->
            button [ onClick SendMessage ] [ text "Send" ]

        LoggingInAs username ->
            text <| "Attempting to login at " ++ username

view : Model -> Html Msg
view model =
    div
        []
        [
          h1 [][text "WebSockets Cmd and Sub"]
        , displayMessageToSend model
        , displayActionButton model
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
