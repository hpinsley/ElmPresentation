-- Elm Benchmarks
https://elm-lang.org/news/blazing-fast-html-round-two
-- Redux Prior Art
https://redux.js.org/introduction/prior-art
-- Nice description of the architecture
http://toreto.re/tea/
-- Ellie
https://ellie-app.com/new

-- Partial application and how to read function annotations.

List.map
[1,2,3]
List.map (\v -> v * 2) [1,2,3]

double = List.map (\v -> v * 2)
double
double [1,2,3]

words = String.split " " "the quick brown fox jumped over the lazy yellow dog"
List.map
String.reverse
reverseStrings = List.map String.reverse
reverseStrings words

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

--The pipe operator passes the first argument to the second (func) arg
(|>)

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

List.any

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

-- Notice that no arguments are needed
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

-- Pattern match with destructuring with case statement
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

List.map
List.filterMap
List.head
List.filterMap List.head

[[1,2,3],[4,5,6],[],[7,8,9]]
    |> List.filterMap List.head

getListHeads = List.filterMap List.head
getListHeads [[1,2,3],[4,5,6],[],[7,8,9]]
getListHeads [["it","dog"],[],[],["works","cat"],["with","cow"],["strings","turkey"],[],["too","mouse"]]

--String.toInt and introduction to the Result type
--Changed in 0.19

String.toInt "abc"
String.toFloat "123.5"

Result.toMaybe

String.toInt "abc" |> Result.toMaybe
String.toInt "314" |> Result.toMaybe

["3", "hi", "12", "4th", "May"]
    |> List.map String.toInt
    |> List.filterMap Result.toMaybe

-- Elm figures out what it needs
Ok 1
Ok "string"
Err "bad num"
-- error is a generic type; value is a generic type

Ok 1 |> Result.toMaybe
Err "this error will be dropped" |> Result.toMaybe

String.toInt >> Result.toMaybe
parseInt = String.toInt >> Result.toMaybe

List.filterMap parseInt ["3", "hi", "12", "4th", "May"]
["3", "hi", "12", "4th", "May"] |> List.filterMap parseInt

getValidInts = List.filterMap parseInt
getValidInts ["3", "hi", "12", "4th", "May"]

-- NOTE: In Elm 0.19 String.toInt returns a Maybe, not a Result
-- Pattern matching
case String.toInt "321" of
    Ok n -> "Got a valid integer.  It's value is " ++ (toString n)
    Err msg -> "got the following error: " ++ msg

-- Tuples (meant for only two items; use records for more)
t1 = ("howard", 1)
Tuple.first
Tuple.second
Tuple.first t1
Tuple.second t1

-- Algebraic data types
-- Uppercase "constructor" functions (no body arise in two scenarios)
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
-- A bit of a contrived example
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

-- Look how Elm defines this function.  What is the type
-- of userRecord?  What is the type of the email field?
getEmail userRecord =
    case userRecord.email of
        Just address -> address
        Nothing -> "Email address not on file."

getEmail dave
getEmail dave4

getEmail { name = "howard", description = "I have no email field" }
getEmail { name = "howard", description = "Why is my email a number?", email = 4 }

-- Nice little helpers.  Each field becomes a function
.email dave
.email

-- Turns out that the .xxx syntax will work for any record with an xxx field
.xyzzy

-- Elm has a very helpful compiler.  We have a typo here
.xyzx { name = "howard", xyz = 123 }

dave |> .email |> Maybe.withDefault "No email"

Maybe.withDefault
Maybe.withDefault "Nada!"
nada = Maybe.withDefault "Nada!"

nada (Just "hpinsley@gmail.com")
nada Nothing

{ companyName = "Acme", email = Nothing}
  |> .email |> Maybe.withDefault "No email"

-- Type type can change in the record.  Person has email as an int
.email

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

-- Nice article about data modeling
-- https://thoughtbot.com/blog/modeling-with-union-types

-- Json Decoders
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)

User

userDecoder =
  decode User
    |> required "id" int
    |> required "email" (nullable string) -- `null` decodes to `Nothing`
    |> optional "name" string "(fallback if name is `null` or not present)"
    |> hardcoded 1.0

Json.Decode.decodeString

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

BasicRendering
SimpleCommandDemo
GettingARandomnumber
HTTP/JSON - Example - NY Times Api...
SubscriptionDemo
WebSocket Demo

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
