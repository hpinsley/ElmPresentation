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
    , messagesReceived: List ChatData
    }


init : ( Model, Cmd Msg )
init =
    ( { loginState = NotLoggedIn
      , messageToSend = ""
      , messagesReceived = []
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
                            ( addErrorMessage errMsg model, Cmd.none )
                        Ok (LoginMessage color) ->
                            ( { model | loginState = LoggedIn username color}, Cmd.none)

                _ ->
                    case decodeString chatMessageDecoder message of
                        Err errMsg ->
                            ( addErrorMessage errMsg model, Cmd.none )
                        Ok chatMessage ->
                            ( { model | messagesReceived = chatMessage.data :: model.messagesReceived}, Cmd.none )

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
                    "Enter message:"
    in
        div []
            [ label [] [ text lbl ]
            , input [ onInput UpdateMessageToSend, Html.Attributes.value model.messageToSend ] []
            , displayActionButton model
            ]

messageRow : ChatData -> Html Msg
messageRow chatData =
    tr [] [
          td [style [("color", chatData.color)]][text chatData.author]
        , td [][text chatData.text]
    ]

addMessage: Username -> Color -> String -> Model -> Model
addMessage author color text model =
    let
        msg = { author = author, color = color, text = text }
        msgs = msg :: model.messagesReceived
    in
        { model | messagesReceived = msgs }


addErrorMessage: String -> Model -> Model
addErrorMessage errMsg model =
    let
        txt = "Error " ++ errMsg
    in
        addMessage "system" "red" txt model

displayMessages : Model -> Html Msg
displayMessages model =
    table [][
         thead [][]
        ,model.messagesReceived
            |> List.map messageRow
            |> tbody []
    ]

displayActionButton : Model -> Html Msg
displayActionButton model =
    case model.loginState of
        NotLoggedIn ->
            button [ onClick Login ] [ text "Login" ]

        LoggedIn _ _->
            button [ onClick SendMessage ] [ text "Send" ]

        LoggingInAs username ->
            text ""

displayLoginState : Model -> Html Msg
displayLoginState model =
    let content =
        case model.loginState of
            NotLoggedIn -> [text "You are not logged in."]
            LoggingInAs name -> [text name]
            LoggedIn name color ->
                [
                      span [][text "You are logged in as "]
                    , span [style [("color", color)]][text name]
                    , span [][text " with color "]
                    , span [style [("color", color)]][text color]
                ]

    in
        div [id "loginState"] content

view : Model -> Html Msg
view model =
    div
        []
        [
          h1 [][text "WebSockets Cmd and Sub"]
        , displayLoginState model
        , displayMessageToSend model
        , displayMessages model
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
