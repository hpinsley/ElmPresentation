# What this repo contains #

This repo contains

- A text file (TryStuffInTheRepl.elm) with Elm language snippets that can be run in the Elm REPL
- Several little stand-alone Elm apps demonstrating various features (all created with the *create-elm-app* program)
- A *very* short PowerPoint presentation in the PowerPoint folder

## Creating an elm App ##

    npm install create-elm-app -g
    create-elm-app my-app
    cd my-app/
    elm-app start

## Links to Elm Information ##

- https://elm-lang.org/
- https://elm-lang.org/news/blazing-fast-html-round-two
- https://redux.js.org/introduction/prior-art
- https://ellie-app.com/new

## VSCode Extension for Elm language Support ##
The repo for this extension is at https://github.com/elm-tooling/vscode-elm.  However, you install the extension directly in VSCode (search the Extensions Marketplace)

## Language Snippets ##
The root folder contains the file TryStuffInTheRepl.elm

If you install the VSCode Extension for Elm language Support, you can

- send single line commands to the REPL with the VSCode command:

    ELM: REPL - Send Line

- multi-line commands to the REPL with the VSCode command:

    ELM: REPL - Send Selection

You can go through this file and execute the lines in order to get a feel for the Elm language.  Don't send the comment lines as they aren't recognized by the REPL

## Sample Apps ##
Each of the Elm Apps in this repo are stand-alone and were initially created with the *create-elm-app* program.  To run the sample, cd into the folder and invoke:

    elm-app start

### Basic Rendering ###
This is the most basic app and is unmodified from what is created by the *create-elm-app* program.  But it is useful to look at to see how an Elm program is bootstrapped and how the view is rendered.

    cd BasicRendering
    elm-app start

### SimpleCommandDemo ###
This app demonstrates how commands can be generated by the Elm runtime in response to user-input events (in this case via a button's onclick function.).  It also demonstrates how these commands wrap your Msg type and how they route back into the program via the update function so that you can, in response, update the model appropriately (in this case incrementing and decrementing an integer.)

    cd SimpleCommandDemo
    elm-app start

### GettingARandomNumber ###
Functions in Elm are pure.  They must (and will) always return the same output for the same input and produce no side effects.  Operations that would cause a violation of this principle are handled by the Elm runtime so that your code is purely functional.

Examples of operations that must be handled by the runtime include:

- Handling user input
- Getting the date or time
- Generating a random number
- Calling a Web API
- Calling into raw JavaScript (via *Interop*)

This example demonstrates getting input through text boxes and building a command (Cmd) to have the runtime generate a random number which is then returned as a custom Msg type to your update function.

    cd GettingARandomNumber
    elm-app start

### SubscriptionDemo ###
The previous examples demonstrate how Cmds are used to cause the Elm runtime to execute an *impure* operation and return the results to your update function via a custom Msg type.  Hand-in-hand with Cmds are Subscriptions.  Subscriptions allow you to have the Elm runtime stream events into your application safely wrapped in a custom Msg.

This example demonstrates two separate subscriptions:

- The current time.  This subscription causes the time to be sent to your update function in the form of a custom Msg once a second.

- Mouse movements.  This subscription causes the position of the mouse to be sent to your update function in the form of a custom Msg whenever the mouse's position changes.

The example also shows how to handle more then one subscription.

    cd SubscriptionDemo
    elm-app start

### Websockets ###

This example demonstrates how the Elm subscription mechanism is used to interact with a server over Web Sockets.  The example requires a server (startup instructions below)

First start a simple node websocket server application

    cd Websockets/Server
    node main.js

Then run the Elm app

    cd Websockets
    elm-app start

