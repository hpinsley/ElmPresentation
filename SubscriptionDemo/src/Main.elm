module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (..)


---- MODEL ----


type alias Model =
    { currentTime : Maybe Time
    , timeSubscriptionEnabled : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { currentTime = Nothing
      , timeSubscriptionEnabled = False
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ToggleTimeSubscription


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of

        ToggleTimeSubscription ->
            ({ model | timeSubscriptionEnabled = not model.timeSubscriptionEnabled }, Cmd.none)

---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Subscription Demo"
            , showTimeSubscription model
            ]
        ]


showTimeSubscription : Model -> Html Msg
showTimeSubscription model =
    div []
        [ h2 []
            [ text <| "Time subscription is "
                ++ (if model.timeSubscriptionEnabled then
                        "On"
                    else
                        "Off"
                   )
            , br [] []
            , button [onClick ToggleTimeSubscription] [ text "Toggle time subscription" ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }