module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random exposing (..)


---- MODEL ----


type alias Model =
    { randomNumber : Int
    , lowInputVal : String
    , highInputVal : String
    }


init : ( Model, Cmd Msg )
init =
    ( { randomNumber = 0
      , lowInputVal = "1"
      , highInputVal = "100"
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = GetRandomNumber
    | GotRandomNumber Int
    | LowInputChanged String
    | HighInputChanged String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetRandomNumber ->
            let
                low =
                    case String.toInt model.lowInputVal of
                        Err _ ->
                            1

                        Ok n ->
                            n

                high =
                    case String.toInt model.highInputVal of
                        Err _ ->
                            10

                        Ok n ->
                            n

                cmd =
                    generate GotRandomNumber (int low high)
            in
                ( model, cmd )

        GotRandomNumber n ->
            ( { model | randomNumber = n }, Cmd.none )

        LowInputChanged val ->
            ( { model | lowInputVal = val }, Cmd.none )

        HighInputChanged val ->
            ( { model | highInputVal = val }, Cmd.none )

---- VIEW ----


view : Model -> Html Msg
view model =
    div [ style [ ( "font-size", "20pt" ), ( "margin-left", "20px" ) ] ]
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Getting a Random Number is Impure" ]
        , div []
            [ text <|
                "Your random number is "
                    ++ (toString model.randomNumber)
            , div
                []
                [ label [] [ text "From:" ]
                , input
                    [ type_ "number"
                    , value model.lowInputVal
                    , onInput LowInputChanged
                    ]
                    []
                ]
            , div []
                [ label [] [ text "To:" ]
                , input
                    [ type_ "number"
                    , value model.highInputVal
                    , onInput HighInputChanged
                    ]
                    []
                ]
            , div []
                [ button [ onClick GetRandomNumber ] [ text "Get Number" ]
                ]
            ]
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
