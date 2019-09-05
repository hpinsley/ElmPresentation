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
    let
        low =
            1

        high =
            50
    in
        ( { randomNumber = 0
          , lowInputVal = toString low
          , highInputVal = toString high
          }
        , Cmd.none
        )



---- UPDATE ----


type Msg
    = GetRandomNumber
    | GotRandomNumber Int
    | LowInputChanged String
    | HighInputChanged String


getRandomRange : Model -> Maybe ( Int, Int )
getRandomRange model =
    case String.toInt model.lowInputVal of
        Err _ ->
            Nothing

        Ok low ->
            case String.toInt model.highInputVal of
                Err _ ->
                    Nothing

                Ok high ->
                    if (low <= high) then
                        Just ( low, high )
                    else
                        Nothing


isValidRandomRange : Model -> Bool
isValidRandomRange model =
    case getRandomRange model of
        Just _ ->
            True

        Nothing ->
            False

isInvalidRandomRange: Model -> Bool
isInvalidRandomRange = not << isValidRandomRange

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetRandomNumber ->
            let
                cmd =
                    case getRandomRange model of
                        Nothing ->
                            Cmd.none

                        Just ( low, high ) ->
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
            , numberInput "To:" model.highInputVal HighInputChanged
            , div []
                [ button
                    [ onClick GetRandomNumber
                    , disabled (isInvalidRandomRange model)
                    ]
                    [ text "Get Number" ]
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
