module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


---- MODEL ----


type alias Model =
    { clickCount : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { clickCount = 0
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = IncrementClickCount
    | DecrementClickCount

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IncrementClickCount ->
            ( { model | clickCount = model.clickCount + 1 }, Cmd.none )

        DecrementClickCount ->
            ( { model | clickCount = model.clickCount - 1 }, Cmd.none )


---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text <| "The click count is " ++ (toString model.clickCount) ]
        , button
            [ class "btn"
            , onClick IncrementClickCount
            ]
            [ text "Increment the click count" ]
        , button
            [ class "btn"
            , onClick DecrementClickCount
            ]
            [ text "Decrement the click count" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
