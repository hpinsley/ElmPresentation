-- Elm Benchmarks
https://elm-lang.org/news/blazing-fast-html-round-two
-- Redux Prior Art
https://redux.js.org/introduction/prior-art
-- Nice description of the architecture
http://toreto.re/tea/


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
List.map
negate
List.filter
List.sort

List.sort (List.map negate (List.filter (\n -> n % 2 == 0) [10,1,2,3,4,5]))

[10,1,2,3,4,5]
    |> List.filter (\n -> n % 2 == 0)
    |> List.map negate
    |> List.sort

-- Lists of functions
isDivisibleBy denom = (\n -> n % denom == 0)
isEven = isDivisibleBy 2
isDivisibleBy5 = isDivisibleBy 5
isEven 2
isEven 3
isDivisibleBy5 15
isDivisibleBy5 13

filters = [isEven, isDivisibleBy5]

filterAny filters value =
  List.any (\fn -> fn value) filters

evenOrByFive = filterAny filters

evenOrByFive 2
evenOrByFive 15
evenOrByFive 3

[10,1,2,3,4,5]
    |> List.filter evenOrByFive
    |> List.map negate
    |> List.sort

-- Function composition
-- Look at the definition of (<<)
(<<)
(>>)
-- See this in practice
dbl x = 2 * x
square x = x * x

doubleThenSquare = dbl >> square
squareThenDouble = dbl << square

doubleThenSquare 3
squareThenDouble 3

List.filter (\n -> n % 2 == 0)
List.map negate
List.sort
(>>)

filterNegateAndSort =
  List.filter (\n -> n % 2 == 0) >>
  List.map negate >>
  List.sort

List.range 1 5
List.range 1 50 |> filterNegateAndSort

--------------------
--The Maybe type.  Say goodbye to undefined is not a function errors
--------------------

List.head [1,2,3]
List.head []

-- Pattern match with destructuring
case List.head [1,2,3] of
    Just v -> v
    Nothing -> 0

case List.head [] of
    Just v -> v
    Nothing -> 0

-- Pattern matching with lists
myhead lst =
  case lst of
    [] -> Nothing
    head::tail -> Just head


myhead [1,2,3]
myhead []
myhead ["a","b","c"]

-- List.filterMap -- if you have a list of maybes
-- Get the heads each embedded list
[[1,2,3],[4,5,6],[],[7,8,9]]
    |> List.map List.head

[[1,2,3],[4,5,6],[],[7,8,9]]
    |> List.filterMap List.head

List.filterMap

getListHeads = List.filterMap List.head
getListHeads [[1,2,3],[4,5,6],[],[7,8,9]]

--String.toInt and introduction to the Result type

String.toInt "abc"
String.toFloat "123.5"

["3", "hi", "12", "4th", "May"]
    |> List.map String.toInt
    |> List.filterMap Result.toMaybe

Ok 1 |> Result.toMaybe
Err "this error will be dropped" |> Result.toMaybe

String.toInt >> Result.toMaybe
parseInt = String.toInt >> Result.toMaybe

List.filterMap parseInt ["3", "hi", "12", "4th", "May"]
["3", "hi", "12", "4th", "May"] |> List.filterMap parseInt

-- Pattern matching
case String.toInt "321" of
    Ok n -> "Got a valid integer.  It's value is " ++ (toString n)
    Err msg -> "got the following error: " ++ msg

-- Algebraic data types
-- Uppercase functions (no body arise in two scenarios)
-- Sum types and product types
-- Msg is a sum type
-- Message String is a product type

type Msg
    = GetData String
    | GotData (Result String (String, Int))

-- All these are valid Msg values
GetData "howard"
GotData (Ok ("howard", 123))
GotData (Err "The server is broken")

validData = GotData (Ok ("howard", 123))

-- Define a function to parse a message into a tuple
getTuple msg =
    case msg of
        GotData result ->
            case result of
                Ok tpl -> tpl
                Err errMsg -> (errMsg, -1)
        GetData forWhom ->
            (forWhom, -2)

getTuple
getTuple (GetData "david")
getTuple <| GotData (Err "The server is broken!")
Ok ("Pilar", 17) |> GotData |> getTuple

-- The last one worked because GotData is also an uppercase function
GotData


-- Customer will be a function

-- Records

type alias User =
  { id : Int
  , email : Maybe String
  , name : String
  , percentExcited : Float
  }

User

dave = User 1 (Just "david@gmail.com") "David" 50.0
dave2 = User 1 (Just "david@gmail.com") "David" 50.0
dave3 = { id = 1, email = (Just "david@gmail.com"), name = "David", percentExcited = 50.0 }

-- Equality semantics
dave == dave2
dave == dave3

-- Records are immutable.  You create copies by altering the fields in a similar
-- manner to the JS spread operator

dave4 = { dave3 | email = Just "dave4@gmail.com" }
dave3 == dave4

getEmail userRecord =
    case userRecord.email of
        Just address -> address
        Nothing -> "Email address not on file."

getEmail dave
getEmail dave4

-- Nice little helpers.  Each field becomes a function
.email dave
.email

dave |> .email |> Maybe.withDefault "No email"

type alias Person =
    {
          name: String
        , email: Int
    }

Person "Pilar" 314 |> .email

-- The Elm compiler is very helpful
type alias ProblemComment =
  { message : String
  , upvotes : Int
  , downvotes : Int
  , responses : List ProblemComment
  }

type alias Comment =
  { message : String
  , upvotes : Int
  , downvotes : Int
  , responses : Responses
  }

type Responses = Responses (List Comment)

-- Json Decoders
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)

userDecoder =
  decode User
    |> required "id" int
    |> required "email" (nullable string) -- `null` decodes to `Nothing`
    |> optional "name" string "(fallback if name is `null` or not present)"
    |> hardcoded 1.0

-- Valid record
Json.Decode.decodeString
  userDecoder
  """
    {"id": 123, "email": "sam@example.com", "name": "Sam Sample"}
  """

-- Valid record with no optional email
Json.Decode.decodeString
  userDecoder
  """
    {"id": 123, "email": null, "name": "Sam Sample"}
  """
-- Valid
Json.Decode.decodeString
  userDecoder
  """
    {"id": 123, "email": null, "name": "Sam Sample"}
  """

-- Null email is valid
Json.Decode.decodeString
  userDecoder
  """
    {"id": 123, "email": null, "name": "Sam Sample"}
  """

-- Missing email is invalid
Json.Decode.decodeString
  userDecoder
  """
    {"id": 123, "name": "Sam Sample"}
  """

-- Invalid - null or missing name
Json.Decode.decodeString
  userDecoder
  """
    {"id": 123, "email": null, "name": null}
  """

HTTP/JSON - Example - NY Times Api...


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
