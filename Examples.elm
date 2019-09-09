-- Partial application and how to read function annotations.

List.map
List.map (\v -> v * 2) [1,2,3]
double = List.map (\v -> v * 2)
double
double [1,2,3]

List.filter
List.filter (\v -> v % 2 == 0) [1,2,3,4,5,6]

evens = List.filter (\v -> v % 2 == 0)
evens [1,2,3,4,5,6]

--
-- Pipelines
List.sort (List.map negate (List.filter (\n -> n % 2 == 0) [10,1,2,3,4,5]))

[10,1,2,3,4,5]
    |> List.filter (\n -> n %2 == 0)
    |> List.map negate
    |> List.sort

-- Function composition
-- Look at the definition of (<<)
(<<)
(>>)
-- See this in practice
double x = 2 * x
square x = x * x

doubleThenSquare = double >> square
squareThenDouble = double << square


--String.toInt

-- Uppercase functions (no body arise in two scenarios)

type Msg
    = Single
    | Message String

--Message is a function
--Record types too

type alias Customer =
    {
        name: String,
        age: Int
    }

-- Customer will be a function

-- Decoders


The float is a decoder.  It says what we expect

> import Json.Decode exposing (..)
> import Json.Decode.Pipeline exposing (..)
> decodeString float "3.13"

decodeString (list int) "[1,2,3]"
(here list is a function and int is a decoder)

Everything is immutable
Everything is an expression
Functions guarantee same results with same inputs
Functions do not cause side effects (no modifiying external state)
Random.generate

Need to return a Cmd...
pickRandomly: List String -> Cmd Msg

A command is a way for the update method to ask the runtime to run some functionality that
does not obey the functional guarantees of Elm.  Same inputs -> Same outputs

Say "elm please do this and when done give me this message back"

No side effects -> managed side effects by returning commands

A Task is like the Result type in that it has two "branches"

Task ErrorType SuccessType

Task.perform takes a Task and changes it to a Cmd Msg
    - Takes how to translate a failure to a Msg
    - Takes how to translate a success to a Msg

Http.getString "url"
    |> Task.perform ShowErr ShowJson -- <-- Out message functions to create Msg type

-- Http.get runs a decoder

Http.get myTypeDecoder "url"

 oneim
 twoim
 threeim
