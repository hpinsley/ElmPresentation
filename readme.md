# Creating an elm App #

    npm install create-elm-app -g
    create-elm-app my-app
    cd my-app/
    elm-app start
# Links to Elm Information #

https://elm-lang.org/
https://elm-lang.org/news/blazing-fast-html-round-two
https://redux.js.org/introduction/prior-art
https://ellie-app.com/new

# VSCode Extension for Elm language Support #

The repo for this extension is at https://github.com/elm-tooling/vscode-elm.  However, you install the extension directly in VSCode (search the Extensions Marketplace)

# What this repo Contains #

This repo contains a text file with Elm language snippets that can be run in the Elm Repl and several little stand-alone Elm apps demonstrating various features.

## Language Snippets ##

The root folder contains the file TryStuffInTheRepl.elm

If you install the VSCode Extension for Elm language Support, you can
    - send single line commands to the REPL with the "ELM: REPL - Send Line" and
    - multi-line commands to the REPL with "ELM: REPL - Send Selection"

you can go through this file and execute the lines in order to get a feel for the Elm language.

## Sample Apps ##

Each of the Elm Apps in this repo are stand-alone.  To run the sample, cd into the folder and invoke:

    elm-app start

### Basic Rendering ###

This is the most basic app and is what is created by
This repository contains
These are simple stand-alone demos

To generate an app, I used

    create-elm-app BasicRendering
    cd BasicRendering

From there, you can run the app with either:

    reactor: elm-reactor, or
    script: elm-app start

The later script will honor your .css file; elm-reactor does not.
