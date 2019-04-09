# Context Free Art support for Kakoune

- [Kakoune](http://kakoune.org/)
- [Context Free Art](https://www.contextfreeart.org/)

## Screenshot

![Imgur](https://i.imgur.com/wWT43RR.png)

You can watch me coding using this plugin at
[Youtube](https://www.youtube.com/watch?v=Ia5mGlKikZs&feature=youtu.be)
~7 minutes, timelapse.

## Compatibility

Kakoune v2018.09.04

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

You can use `:cfdg-render` command to create preview png in directory
with cfdg file.  Timeout is set to 10 seconds but you can change it using
`cfdg_timeout` option.  If you wish to tweak cfdg command parameter (flags)
you can use `cfdg_params` option.

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

## Changelog

- 1:
    - initial relese
- 2:
    - _FIX_ completion of CFDG namespace
- 3 2018-09-16:
    - _CHANGE_ Kakoune v2018.09.04 compatibility
- 4 2018-10-24:
    - __CHANGE__ directory layout (plugin code in `rc` directory)
- 5 2018-11-16:
    - Kakoune v2018.10.27
    - _FIX_ CF namespace completion
    - _ADD_ configuration variables
- master:
    - _ADD_ number keyword
