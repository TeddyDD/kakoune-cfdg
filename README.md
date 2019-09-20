# Context Free Art support for Kakoune

- [Kakoune]
- [Context Free Art]

## Screenshot

![Imgur]

You can watch me coding using this plugin at [Youtube] \~7 minutes,
timelapse.

## Compatibility

Kakoune v2019.07.01

## Usage

Install it using [plug.kak]

```
plug "TeddyDD/kakoune-cfdg"
```

or manually: put `cfdg.kak` in your autoload directory or source it from
`kakrc`.

Snippets are usable with [kakoune-snippets]

```
plug "occivink/kakoune-snippets" config %{
    set-option -add global snippets_directories "%opt{plug_install_dir}/kakoune-cfdg/snippets"
    # some other kakoune-snippets related configurations
}
```

## Features

- syntax highlighting
- static completion (function names, keywords)
- line and block comments set
- auto indentation (no need to manually indent back after `}`, just go
  to next line)
- basic rendering command
- snippets

## Rendering

You can use `:cfdg-render` command to create preview png in directory
with cfdg file. Timeout is set to 10 seconds but you can change it using
`cfdg_timeout` option. If you wish to tweak cfdg command parameter
(flags) you can use `cfdg_params` option.

You can set Kakoune to render cfdg file on save. Just add following
lines your `kakrc`

```
hook global WinSetOption filetype=cfdg %{
    hook buffer BufWritePost .* %{
        cfdg-render
    }
}
```

## Todo

Would be nice to have: better completion, linting using `cfdg -C`, basic
refactoring (shape -\> shape with rules etc). PRs welcome.

## License

ISC License

## Changelog

- 1:
    - initial relese
- 2:
    - *FIX* completion of CFDG namespace
- 3 2018-09-16:
    - *CHANGE* Kakoune v2018.09.04 compatibility
- 4 2018-10-24:
    - **CHANGE** directory layout (plugin code in `rc` directory)
- 5 2018-11-16:
    - Kakoune v2018.10.27
    - *FIX* CF namespace completion
    - *ADD* configuration variables
- 6 2019-07-04:
    - **Kakoune v2019.07.01**
    - **CHANGE** use modules
    - *ADD* number keyword
    - *FIX* highlight shape param types
    - *FIX* highlight paths definitions with params
- 7 2019-09-21:
    - *ADD* snippets

[Kakoune]: http://kakoune.org/
[Context Free Art]: https://www.contextfreeart.org/
[Imgur]: https://i.imgur.com/wWT43RR.png
[Youtube]: https://www.youtube.com/watch?v=Ia5mGlKikZs&feature=youtu.be
[plug.kak]: https://github.com/andreyorst/plug.kak
[kakoune-snippets]: https://github.com/occivink/kakoune-snippets
