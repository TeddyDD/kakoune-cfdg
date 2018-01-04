# Context Free Art support for Kakoune editor
# ===========================================
# Author: Daniel Lewna - TeddyDD
# License: Creative Commons Zero - https://creativecommons.org/publicdomain/zero/1.0/

# Detection
# =========

hook global BufCreate .*\.cfdg$ %{
    set buffer filetype cfdg
}

# Completion and highlight
# ========================

add-highlighter shared/ regions -default code cfdg \
	comment    '//' $  '' \
	comment    '/\*' '\*/' '' \
	adjustment '\[' '\]' ''

add-highlighter shared/cfdg/adjustment fill attribute

%sh{
	keywords="rule|loop|path|finally|if|switch|case|else|transform|clone"
	keywords="${keywords}|shape|startshape"
	functions="infinity|cos|sin|tan|acos|asin|atan|atan2|cosh|sinh|tanh"
	functions="${functions}|acosh|asinh|atanh|log|log10|exp|sqrt|abs|mod"
	functions="${functions}|floor|factorial|sg|isNatural|div|divides"
	functions="${functions}|bitnot|bitor|bitleft|bitright|min|max"
	functions="${functions}|frame|ftime|rand_static|rand|randint"
	functions="${functions}|select|let"
	functions="${functions}|MOVETO|LINETO|ARCTO|CURVETO|CLOSEPOLY|MOVEREL|LINEREL|ARCREL|CURVEREL|STROKE|FILL"
	cf="CF\:\:Symmetry|CF\:\:Dihedral|CF\:\:Cyclic|CF\:\:p11g|CF\:\:p11m"
    cf="${cf}|CCF\:\:p2|CF\:\:p2mg|CF\:\:p2mm|CF\:\:Tile|CF\:\:p4|CF\:\:p4m|CF\:\:p4g|CF\:\:p3"
    cf="${cf}|CF\:\:p3m1|CF\:\:p31m|CF\:\:p6|CF\:\:p6m|CF\:\:AllowOverlap|CF\:\:Alpha|CF\:\:Background"
    cf="${cf}|CF\:\:BorderDynamic|CF\:\:Color|CF\:\:ColorDepth|CF\:\:Frame|CF\:\:Impure|CF\:\:MaxNatural"
    cf="${cf}|CF\:\:MinimumSize|CF\:\:Size|CF\:\:Time"
    cf="${cf}|CF\:\:Continuous|CF\:\:Align|CF\:\:MiterJoin|CF\:\:RoundJoin|CF\:\:BevelJoin|CF\:\:ButtCap|CF\:\:RoundCap|CF\:\:SquareCap|CF\:\:IsoWidth|CF\:\:EvenOdd"

	types="CIRCLE|SQUARE|TRIANGLE"

        # add to static completion list
        printf %s\\n "hook global WinSetOption filetype=cfdg %{
            set -add buffer static_words '${keywords}|${functions}:${types}:${cf}' }" | sed 's,|,:,g'

    	# highlight functions
        printf %s\\n "add-highlighter shared/cfdg/adjustment regex '\b(${functions})\b\(' 1:function"
        printf %s\\n "add-highlighter shared/cfdg/code regex '\b(${functions})\b\(' 1:function"

}

add-highlighter shared/cfdg/adjustment regex '\b(?:alpha|brightness|flip|hue|time|timescale|rotate|s(?:at(?:uration)?|ize|kew)|trans(?:form)?|[afhrsxyz])\b' 0:builtin
add-highlighter shared/cfdg/adjustment regex '(\d\.)?\d' 0:value

# shape names and keywords
add-highlighter shared/cfdg/code regex '\b((?:start)?shape)\b\s+(\w+)' 1:keyword 2:type
add-highlighter shared/cfdg/code regex '\b(rule|loop|path|finally|if|switch|case|else|transform|clone)\b\s' 1:keyword

# basic types
add-highlighter shared/cfdg/code regex '\b(CIRCLE|TRIANGLE|SQUARE)\b' 1:builtin
# variables
add-highlighter shared/cfdg/code regex '\h*(\w+::)?(\w+)\s?=\s?' 1:builtin 2:variable

add-highlighter shared/cfdg/comment fill comment
add-highlighter shared/cfdg/code regex \d 0:value

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

# Initialization
# ==============


hook global WinSetOption filetype=cfdg  %{
    # indent
    hook window InsertChar \n -group cfdg-indent cfdg-indent-on-new-line

    # highlight
    add-highlighter buffer ref cfdg

    # comments
    set-option buffer comment_line '//'
    set-option buffer comment_block_begin '/*'
    set-option buffer comment_block_begin '*/'
}

hook -group cfdg-highlight global WinSetOption filetype=(?!cfdg).* %{
    remove-hooks window cfdg-indent
    remove-highlighter cfdg
}

