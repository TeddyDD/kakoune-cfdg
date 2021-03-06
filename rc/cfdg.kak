# Context Free Art support for Kakoune editor
# ===========================================
# Author: Daniel Lewna - TeddyDD
# License: Creative Commons Zero - https://creativecommons.org/publicdomain/zero/1.0/

# Variables
# =========

# CFDG params
declare-option -docstring 'Params passed to cfdg command' str cfdg_params

# timeout
declare-option -docstring 'Rendering timeout' int cfdg_timeout 10

# Detection
# =========

hook global BufCreate .*\.cfdg$ %{
    set buffer filetype cfdg
}

# Initialization
# ==============


hook global WinSetOption filetype=cfdg  %{
    require-module cfdg
    # indent
    hook window InsertChar \n -group cfdg-indent cfdg-indent-on-new-line

    # highlight
    add-highlighter window/cfdg ref cfdg

    # comments
    set-option window comment_line '//'
    set-option window comment_block_begin '/*'
    set-option window comment_block_end '*/'

    # Save extra_word_chars option for restoring when buffer filetype changes to other than 'cfdg'
    declare-option -hidden str extra_word_chars_save %opt{extra_word_chars}
    # Consider ':' characters as parts of words.
    set-option -add window extra_word_chars :
    set-option window static_words %opt{cfdg_static_words}
}

hook -group cfdg-highlight global WinSetOption filetype=(?!cfdg).* %{
    remove-hooks window cfdg-indent
    remove-highlighter window/cfdg

    # Restore extra_word_chars option.
    try %{ set window extra_word_chars %opt{extra_word_chars_save}}
}


provide-module cfdg %§

# Completion and highlight
# ========================

add-highlighter shared/cfdg regions
add-highlighter shared/cfdg/code default-region group

add-highlighter shared/cfdg/comment       region '//'  $     fill comment
add-highlighter shared/cfdg/comment_block region '/\*' '\*/' fill comment
add-highlighter shared/cfdg/adjustment    region '\['  '\]'  group

add-highlighter shared/cfdg/shape_params  region '\b(shape|path)\b\s+\w+\(' '\)' regions
add-highlighter shared/cfdg/shape_params/shape default-region group

add-highlighter shared/cfdg/string        region '"'   '"'   fill string

evaluate-commands %sh{
    keywords="rule|loop|path|finally|if|switch|case|else|transform|clone"
    keywords="${keywords}|shape|startshape|import|number"
    functions="infinity|cos|sin|tan|acos|asin|atan|atan2|cosh|sinh|tanh"
    functions="${functions}|acosh|asinh|atanh|log|log10|exp|sqrt|abs|mod"
    functions="${functions}|floor|factorial|sg|isNatural|div|divides"
    functions="${functions}|bitnot|bitor|bitleft|bitright|min|max"
    functions="${functions}|frame|ftime|rand_static|rand|randint"
    functions="${functions}|select|let"
    functions="${functions}|MOVETO|LINETO|ARCTO|CURVETO|CLOSEPOLY|MOVEREL|LINEREL|ARCREL|CURVEREL|STROKE|FILL"
    functions="${functions}|rand::cauchy|rand::chisquared|rand::exponential|rand::extremeV|rand::fisherF"
    functions="${functions}|rand::gamma|randint::bernoulli|randint::binomial|randint::discrete"
    functions="${functions}|randint::geometric|randint::negbinomial|randint::poisson|rand::lognormal"
    functions="${functions}|rand::normal|rand::studentT|rand::weibull"
    cf="CF::Symmetry|CF::Dihedral|CF::Cyclic|CF::p11g|CF::p11m"
    cf="${cf}|CCF::p2|CF::p2mg|CF::p2mm|CF::Tile|CF::p4|CF::p4m|CF::p4g|CF::p3"
    cf="${cf}|CF::p3m1|CF::p31m|CF::p6|CF::p6m|CF::AllowOverlap|CF::Alpha|CF::Background"
    cf="${cf}|CF::BorderDynamic|CF::Color|CF::ColorDepth|CF::Frame|CF::Impure|CF::MaxNatural"
    cf="${cf}|CF::MinimumSize|CF::Size|CF::Time"
    cf="${cf}|CF::Continuous|CF::Align|CF::MiterJoin|CF::RoundJoin|CF::BevelJoin|CF::ButtCap|CF::RoundCap|CF::SquareCap|CF::IsoWidth|CF::EvenOdd"

    parameters="shape|natural|adjustment|number|vector\d\d?"

    types="CIRCLE|SQUARE|TRIANGLE"

        # add to static completion list
        printf %s\\n "declare-option str-list cfdg_static_words ${keywords}|${functions} ${types} ${cf}" | sed 's,|, ,g'

        # highlight functions
        printf %s\\n "add-highlighter shared/cfdg/adjustment/ regex '\b(${functions})\b\(' 1:function"
        printf %s\\n "add-highlighter shared/cfdg/code/ regex '\b(${functions})\b\(' 1:function"

        # highlight keywords
        printf %s\\n "add-highlighter shared/cfdg/code/ regex '\b($keywords)\b' 1:keyword"

        # shape parameter types
        printf %s\\n "add-highlighter shared/cfdg/shape_params/args region '\(' '\)' regex '(${parameters})\s(\w+),?' 1:builtin"
}

add-highlighter shared/cfdg/adjustment/ regex '\b(?:alpha|brightness|flip|hue|time|timescale|rotate|s(?:at(?:uration)?|ize|kew)|trans(?:form)?|[afhrsxyz])\b' 0:builtin
add-highlighter shared/cfdg/adjustment/ regex '(\d\.)?\d' 0:value

# shape names and keywords
add-highlighter shared/cfdg/code/ regex '\b((?:start)?shape|path)\b\s+(\w+)' 1:keyword 2:type

# shape with params, same as above
add-highlighter shared/cfdg/shape_params/shape/ regex '\b(shape|path)\b\s+(\w+)' 1:keyword 2:type

# basic types
add-highlighter shared/cfdg/code/ regex '\b(CIRCLE|TRIANGLE|SQUARE)\b' 1:builtin
# variables
add-highlighter shared/cfdg/code/ regex '\h*(\w+::)?(\w+)\s?=\s?' 1:builtin 2:variable

add-highlighter shared/cfdg/code/ regex \d 0:value

# Indentation
# ===========

define-command -hidden cfdg-indent-on-new-line %(
    evaluate-commands -draft -itersel %(
        # preserve previous line indent
        try %= execute-keys -draft \;K<a-&> =
        # cleanup trailing white spaces on previous line
        try %= execute-keys -draft k<a-x> s \h+$ <ret>"_d =
        # copy '#' comment prefix and following white spaces
        try %= execute-keys -draft k <a-x> s ^\h*//\h* <ret> y jgh P =
        # indent after lines ending with {
        try %= execute-keys -draft k<a-x> <a-k> [{]\h*$ <ret> j<a-gt> =
        # indent back after }
        try %= execute-keys -draft k<a-x> <a-k> \h*[}]$ <ret> <a-lt> j <a-lt> =
    )
)

# Commands
# ========

define-command -docstring 'Render file using cfdg.
File will be saved to the same directory as file with png extension.
Timeout is set to 10 seconds - for longer renderings you might want
to use other solutins' \
cfdg-render %{ evaluate-commands %{
    echo -debug {Error} %sh{
    filename="$(basename $kak_bufname .cfdg)"
    out="$(dirname $kak_buffile)/$filename.png"
    # feel free to tweak params of cfdg command
    timeout "$kak_opt_cfdg_timeout" cfdg $kak_opt_cfdg_params -- "$kak_buffile" "$out" 2>&1 | grep "Error" >&1
}}}

§ # Module
