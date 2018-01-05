# Context Free Art support for Kakoune

- [Kakoune](http://kakoune.org/)
- [Context Free Art](https://www.contextfreeart.org/)

## Screenshot

![Imgur](https://i.imgur.com/wWT43RR.png)

## Usage

Put `cfdg.kak` in your autoload directory or source it
from `kakrc`.

## Features

- syntax highlighting
- static completion (function names, keywords)
- line and block comments set
- auto indentation (no need to manually indent back after `}`, just go to next
  line)

## Todo

Would be nice to have: preview on save, better completion,
linting using `cfdg -C`, basic refactoring (shape -> shape with rules).
PRs welcome.

## License

ISC License
