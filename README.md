# Context Free Art support for Kakoune

- [Kakoune](http://kakoune.org/)
- [Context Free Art](https://www.contextfreeart.org/)

## Screenshot

![Imgur](https://i.imgur.com/wWT43RR.png)

You can watch me coding using this plugin at
[Youtube](https://www.youtube.com/watch?v=Ia5mGlKikZs&feature=youtu.be)
~7 minutes, timelapse.

## Compatibility

Tested with Kakoune version **2018.04.13**

## Usage

Put `cfdg.kak` in your autoload directory or source it
from `kakrc`.

## Features

- syntax highlighting
- static completion (function names, keywords)
- line and block comments set
- auto indentation (no need to manually indent back after `}`, just go to next
  line)
- basic rendering command

## Rendering

You can use `:cfdg-render` command to create preview png in directory with cfdg file.
Timeout is set to 10 seconds but you can change it.
If you wish to tweak cfdg command params then look into `cfdg-render` command
defined in `cfdg.kak` file.

You can set Kakoune to render cfdg file on save. Just add following lines 
your `kakrc`

```
hook global WinSetOption filetype=cfdg %{
    hook buffer BufWritePost .* %{
		cfdg-render
	}
}
```

## Todo

Would be nice to have: better completion, linting using `cfdg -C`,
basic refactoring (shape -> shape with rules etc).
PRs welcome.

## License

ISC License
