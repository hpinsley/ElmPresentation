module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket


serverAddress =
    "ws://127.0.0.1:1337"



---- MODEL ----


type LoginState
    = NotLoggedIn
    | LoggedIn String


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
                ( { model | messageToSend = "", loginState = LoggedIn username }, cmd )

        GotMessage message ->
            ( { model | messageReceived = message }, Cmd.none )

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

                LoggedIn username ->
                    username ++ ", enter message:"
    in
        div []
            [ label [] [ text lbl ]
            , input [ onInput UpdateMessageToSend, value model.messageToSend ] []
            ]


displayMessageReceived : Model -> Html Msg
displayMessageReceived model =
    div [] [ text model.messageReceived ]


displayActionButton : Model -> Html Msg
displayActionButton model =
    case model.loginState of
        NotLoggedIn ->
            button [ onClick Login ] [ text "Login" ]

        LoggedIn _ ->
            button [ onClick SendMessage ] [ text "Send" ]


view : Model -> Html Msg
view model =
    div
        []
        [ displayMessageToSend model
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
