module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (..)
import Time.Format exposing (..)
import Mouse
---- MODEL ----


type alias Model =
    { currentTime : Maybe Time
    , timeSubscriptionEnabled : Bool
    , mouseSubscriptionEnabled: Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { currentTime = Nothing
      , timeSubscriptionEnabled = False
      , mouseSubscriptionEnabled = False
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ToggleTimeSubscription
    | GotTimeEvent Time.Time
    | ToggleMouseSubscription


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleTimeSubscription ->
            ( { model | timeSubscriptionEnabled = not model.timeSubscriptionEnabled }, Cmd.none )

        GotTimeEvent currentTime ->
            ( { model | currentTime = Just currentTime }, Cmd.none )

        ToggleMouseSubscription ->
            ( { model | mouseSubscriptionEnabled = not model.mouseSubscriptionEnabled }, Cmd.none )

---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Subscription Demo"
            , showTimeSubscription model
            , showMouseSubscription model
            ]
        ]

getTimeDisplay: Maybe Time.Time -> String
getTimeDisplay mTime =
    case mTime of
        Nothing -> "Not set"
        Just t -> format "%I:%M:%S %p" t

onOff: Bool -> String
onOff bool =
    if (bool) then "On" else "Off"

showTimeSubscription : Model -> Html Msg
showTimeSubscription model =
    div []
        [ h2 []
            [ text <| "Time subscription is " ++ (onOff model.timeSubscriptionEnabled)
            ]
        , br [] []
        , button [ onClick ToggleTimeSubscription ] [ text "Toggle time subscription" ]
        , hr [] []
        , getTimeDisplay model.currentTime
            |> (++) "The time is "
            |> text
        , hr [] []
        ]


showMouseSubscription : Model -> Html Msg
showMouseSubscription model =
    div []
        [ h2 []
            [ text <| "Mouse subscription is " ++ (onOff model.mouseSubscriptionEnabled)
            ]
        , br [] []
        , button [ onClick ToggleMouseSubscription ] [ text "Toggle mouse subscription" ]
        , hr [] []
        , hr [] []
        ]


subscriptions : Model -> Sub Msg
subscriptions model =

    let timeSub = if (model.timeSubscriptionEnabled)
                        then Time.every (1 * Time.second) GotTimeEvent
                        else Sub.none
    in
        timeSub


---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
