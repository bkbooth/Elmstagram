# Elmstagram

A basic UI-clone of [Instagram][] using [Elm][].

Inspired by [Wes Bos'](https://twitter.com/wesbos) great
[Redux course](https://learnredux.com/).

## Build & Run

```bash
$ git clone https://github.com/bkbooth/Elmstagram.git
$ cd Elmstagram
$ npm install
$ npm run build
$ npm start
```

I was originally trying to avoid [Node.js][], `npm` and `package.json`
by using a `Makefile` and `make` scripts but I'm installing [Elm][] with
`npm` anyway so I ended up going full [Node.js][] and `npm` scripts.

You can use `npm run watch` instead of `npm run build` to watch and
recompile `elm.js` when you make changes to any of the `src/*` files.

Alternatively you can use [Yarn][] instead of `npm`.

 [instagram]: https://www.instagram.com/ "Instagram"
 [elm]: http://elm-lang.org/ "Elm"
 [node.js]: https://nodejs.org/ "Node.js"
 [yarn]: https://yarnpkg.com/ "Yarn"
