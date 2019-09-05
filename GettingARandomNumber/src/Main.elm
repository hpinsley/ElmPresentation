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
    , low: Int
    , high: Int
    }


init : ( Model, Cmd Msg )
init =
    let
        low = 1
        high = 50
    in
        ( { randomNumber = 0
        , lowInputVal = toString low
        , highInputVal = toString high
        , low = low
        , high = high
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
                cmd =
                    generate GotRandomNumber (int model.low model.high)
            in
                ( model, cmd )

        GotRandomNumber n ->
            ( { model | randomNumber = n }, Cmd.none )

        LowInputChanged val ->
            case String.toInt val of
                Err _ -> (model, Cmd.none)
                Ok v ->
                    if (v <= model.high)
                    then
                        ( { model | lowInputVal = val, low = v }, Cmd.none )
                    else
                        ( model, Cmd.none)

        HighInputChanged val ->
            case String.toInt val of
                Err _ -> (model, Cmd.none)
                Ok v ->
                    if (v >= model.low)
                    then
                        ( { model | highInputVal = val, high = v }, Cmd.none )
                    else
                        (model, Cmd.none)


---- VIEW ----


numberInput : String -> String -> (String -> Msg) -> Html Msg
numberInput label_text val message =
    div
        []
        [ label [] [ text label_text ]
        , input
            [ type_ "number"
            , value val
            , onInput message
            ]
            []
        ]


view : Model -> Html Msg
view model =
    div [ style [ ( "font-size", "20pt" ), ( "margin-left", "20px" ) ] ]
        [ h1 [] [ text "Getting a Random Number is Impure" ]
        , div []
            [ text <|
                "Your random number is "
                    ++ (toString model.randomNumber)
            , numberInput "From:" model.lowInputVal LowInputChanged
            , div [][text (toString model.low)]
            , numberInput "To:" model.highInputVal HighInputChanged
            , div [][text (toString model.high)]
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
