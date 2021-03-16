# Elm 0.19.1 with Webpack 4, Hot Reloading & Babel 7

Elm dev environment with hot-loading (i.e. state is retained as you edit your code - Hot Module Reloading, HMR)).

## Installation

Clone this repo into a new project folder and run install script.
(You will probably want to delete the .git/ directory and start version control afresh.)

With npm

```sh
$ git clone git@github.com:PhiApp/szdevman-elm.git
$ cd szdevman-elm
$ npm install
```

## Visual Studio Code Extension

Install the Visual Studio Code Extension for language support.

https://marketplace.visualstudio.com/items?itemName=Elmtooling.elm-ls-vscode

## Developing

Start with Elm debug tool with either
```sh
$ npm start
or
$ npm start --nodebug
```

the `--nodebug` removes the Elm debug tool. This can become valuable when your model becomes very large.

Open http://localhost:3000 and start modifying the code in /src.  **Note** that this starter expects you have installed [elm-format globally](https://github.com/avh4/elm-format#installation-). 

An example using Routing is provided in the `navigation` branch

## Production

Build production assets (js and css together) with:

```sh
npm run prod
```

## Static assets

Just add to `src/assets/` and the production build copies them to `/dist`

## Testing

[Install elm-test globally](https://github.com/elm-community/elm-test#running-tests-locally)

`elm-test init` is run when you install your dependencies. After that all you need to do to run the tests is

```
npm test
```

Take a look at the examples in `tests/`

If you add dependencies to your main app, then run `elm-test --add-dependencies`

<!-- I have also added [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples) and provided an example in the definition of `add1` in App.elm. -->

## Elm-analyse

Elm-analyse is a "tool that allows you to analyse your Elm code, identify deficiencies and apply best practices." Its built into this starter, just run the following to see how your code is getting on:

```sh
$ npm run analyse
```

## ES6

This starter includes [Babel](https://babeljs.io/) so you can directly use ES6 code.

 ## How it works

`npm run dev` maps to `webpack-dev-server --hot --colors --port 3000` where

  - `--hot` Enable webpack's Hot Module Replacement feature
  - `--port 3000` - use port 3000 instead of default 8000
  - inline (default) a script will be inserted in your bundle to take care of reloading, and build messages will appear in the browser console.
  - `--colors` should show the colours created in the original Elm errors, but does not (To Fix)
  
One alternative is to run `npx webpack-dev-server --hot --colors --host=0.0.0.0 --port 3000` which will enable your dev server to be reached from other computers on your local network

 ## Credits

 Thanks to simonh1000 for creating the elm elm-live webpack template 
 https://github.com/simonh1000/elm-webpack-starter