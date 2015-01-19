"" Vim syntax file
" Language: Scaladoc
" Maintainer: Shunsuke Sogame <okomok@gmail.com>
" References:
"   https://wiki.scala-lang.org/display/SW/Scaladoc


" Preamble

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif


" Includes

if exists("scaladoc_has_html")
    syntax case ignore
    syntax include @scaladocHtml syntax/html.vim
    unlet b:current_syntax
endif


" The Scaladoc syntax

syn case match
syn sync minlines=200 maxlines=1000


syn match scaladocStart "/\*\*\@=" nextgroup=scaladoc
syn region scaladoc start="\*\@<=" end="\*/" contains=@scaladocBodyCluster keepend fold contained
hi link scaladocStart scaladoc
hi def link scaladoc Comment
syn cluster scaladocBodyCluster contains=scaladocLeftMerginal,scaladocCodeBlock,@scaladocInlineElementCluster,@scaladocPreParseCluster,
    \ @scaladocHtml,@Spell,scaladocNotHtml

syn match scaladocLeftMergin "^\s*\*\%(\s\+\|$\)" contained " fallback
hi link scaladocLeftMergin scaladoc

if exists("scaladoc_has_html")
    " suppress @scaladocHtml errors.
    syn match scaladocNotHtml ">\@=" contained
    syn match scaladocNotHtml "\%(&\%(#\=[0-9A-Za-z]\{1,8};\)\@!\)\@=" contained
    syn match scaladocNotHtml "\%(<$\)\@=" contained
    syn match scaladocNotHtml _\%(<[ \t()[\]{}.;,!#%&*+\-:<=>?@\\^|~'"`0-9]\)\@=_ contained
endif


" Before parsing
syn cluster scaladocPreParseCluster contains=scaladocEscape,@scaladocMultiLineCommentHook,scaladocLeftMergin

" Scaladoc Escape
"   $scalaEscapedId seems good.
syn match scaladocEscape _\$[^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`0-9$][^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`$]*_ contained
hi def link scaladocEscape SpecialComment

" Scaladoc Inline Elements (https://wiki.scala-lang.org/display/SW/Syntax)
syn cluster scaladocInlineElementCluster contains=scaladocItalic,scaladocBold,scaladocUnderline,scaladocMonospace,scaladocSuperscript,
    \ scaladocSubscript,scaladocEntityLink,scaladocExternalLink
hi def link scaladocInlineElement SpecialComment
syn region scaladocItalic start="''" end="'''\@!" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocItalic scaladocInlineElement
syn region scaladocBold start="'''" end="''''\@!" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocBold scaladocInlineElement
syn region scaladocUnderline start="__" end="___\@!" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocUnderline scaladocInlineElement
syn region scaladocMonospace start="`" end="``\@!" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocMonospace scaladocInlineElement
syn region scaladocSuperscript start="\^" end="\^\^\@!" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocSuperscript scaladocInlineElement
syn region scaladocSubscript start=",," end=",,,\@!" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocSubscript scaladocInlineElement
syn region scaladocEntityLink start="\[\[" end="\]\]" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocEntityLink scaladocInlineElement
syn region scaladocExternalLink matchgroup=scaladocInlineElement start="\[\[\%([A-Za-z][A-Za-z0-9+.-]*:\)\@=" end="\(\s.*\)\=\]\]" contains=@scaladocPreParseCluster,scaladocUri contained keepend
hi def link scaladocExternalLink Underlined

" Start of Block Elements, Tags or Annotations
syn match scaladocLeftMerginal "^\s*\*\%(\s\+\|$\)" nextgroup=@scaladocLeftMerginalCluster contained
syn match scaladocLeftMerginal "\%(/\*\*\)\@<=\s\+" nextgroup=@scaladocLeftMerginalCluster contained " bless you.
syn cluster scaladocLeftMerginalCluster contains=@scaladocTagCluster,@scaladocBlockElementCluster
hi link scaladocLeftMerginal scaladocLeftMergin


" Scaladoc Block Elements (https://wiki.scala-lang.org/display/SW/Syntax)

syn cluster scaladocBlockElementCluster contains=scaladocListBlockStart,scaladocHeading
hi def link scaladocBlockElementCluster SpecialComment

syn region scaladocHeading matchgroup=scaladocHeadingQuote start="=\+" end="=\+" contains=@scaladocBodyCluster contained keepend oneline
hi def link scaladocHeadingQuote SpecialComment
hi def link scaladocHeading scaladoc

syn match scaladocListBlockStart "-\s" contained
syn match scaladocListBlockStart "[0-9]\.\s" contained
hi def link scaladocListBlockStart SpecialComment


" Scaladoc Code Block
syn region scaladocCodeBlock matchgroup=SpecialComment start="{{{" end="}}}" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocCodeBlock Normal


" Scaladoc Tags and Annotations (https://wiki.scala-lang.org/display/SW/Tags+and+Annotations)

syn cluster scaladocTagCluster contains=scaladocParam,scaladocTParam,scaladocReturn,scaladocThrows,scaladocSee,
    \ scaladocNote,scaladocExample,scaladocUsecase,scaladocAuthor,scaladocVersion,scaladocSince,scaladocTodo,scaladocDefine,scaladocInheritdoc
hi def link scaladocTagCluster SpecialComment

syn match scaladocParam "@constructor\>" contained 
hi def link scaladocParam scaladocTagCluster
syn match scaladocParam "@param\>" nextgroup=@scaladocIdHook contained skipwhite
hi def link scaladocParam scaladocTagCluster
syn match scaladocTParam "@tparam\>" nextgroup=@scaladocIdHook contained skipwhite
hi def link scaladocTParam scaladocTagCluster
syn match scaladocReturn "@return\>" contained
hi def link scaladocReturn scaladocTagCluster
syn match scaladocThrows "@throws\>" contained
hi def link scaladocThrows scaladocTagCluster
syn match scaladocSee "@see\>" contained
hi def link scaladocSee scaladocTagCluster
syn match scaladocNote "@note\>" contained
hi def link scaladocNote scaladocTagCluster
syn match scaladocExample "@example\>" contained
hi def link scaladocExample scaladocTagCluster
syn match scaladocUsecase "@usecase\>" contained
hi def link scaladocUsecase scaladocTagCluster
syn match scaladocAuthor "@author\>" contained
hi def link scaladocAuthor scaladocTagCluster
syn match scaladocVersion "@version\>"  contained
hi def link scaladocVersion scaladocTagCluster
syn match scaladocSince "@since\>" contained
hi def link scaladocSince scaladocTagCluster
syn match scaladocTodo "@todo\>" contained
hi def link scaladocTodo scaladocTagCluster
syn match scaladocDefine "@define\>" nextgroup=scaladocEscapedId contained skipwhite
hi def link scaladocDefine scaladocTagCluster
syn match scaladocInheritdoc "@inheritdoc\>"
hi def link scaladocInheritdoc scaladocTagCluster


" Afterword

let b:current_syntax = "scaladoc"

