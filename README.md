# Inari

Inari is a game and engine written in Crystal using GLFW. It is very much work in progress and intended mostly as a playground.

## Prerequisites

1. Install Crystal (on OS X: `brew install crystal-lang`)
2. Install GLEW and GLFW (on OS X: `brew install homebrew/versions/glfw3 glew`)

## Building

Use `make` to build the game.

## Architecture

* `Glove::App` is a generic game superclass.

* `Glove::EntityApp` is a generic game superclass that provides functionality for handling entities.

* `Glove::Entity` is a game object that is visible and/or reacts to user input.

* `Glove::Component` makes up an entity. Camera, cursor tracking, transform, … are all components.

* `Glove::Action` defines a change to an entity. It can either be instant (e.g. remove entity) or act over time (e.g. move).

* `Glove::Scene` describes a scene (such as the main menu, credits, or in-game screen). It contains one or more spaces.

* `Glove::Space` groups entities in a scene that logically belong together and can interact with each other. Entities in different spaces never interact.

Other classes (more for internal use only):

* `Glove::Cursor` contains the mechanism for fetching the cursor position.

* `Glove::EventQueue`

* `Glove::EventHandler`

* `Glove::Event`

* `Glove::Tween` is used for tracking the progress of an action.

* `Glove::AssetManager`

* `Glove::Renderer`

Simple data classes:

* `Glove::Color`

* `Glove::Point`

* `Glove::Quad`

* `Glove::Rect`

* `Glove::Size`

* `Glove::Vector`

## Acknowledgements

This project started out by playing with [crystal-gl](https://github.com/ggiraldez/crystal-gl) by Gustavo Giráldez. The playing card assets are by [Kenney](http://kenney.nl/assets).
