"" Vim syntax file
" Language: Scaladoc
" Maintainer: Shunsuke Sogame <okomok@gmail.com>
" References:
"   https://wiki.scala-lang.org/display/SW/Scaladoc


" Preamble

if version < 600
    syn clear
elseif exists("b:current_syntax")
    finish
endif


" Includes

if !exists("scaladoc_no_html")
    syn case ignore
    syn include @scaladocHtml syntax/html.vim
    syn cluster htmlPreProc add=@scaladocPreParseCluster
    unlet b:current_syntax
endif


" The Scaladoc syntax

syn case match
syn sync minlines=200 maxlines=1000

" eat some; otherwise eaten up by nested multi-line comment.
syn match scaladoc "/\%(\*\*\)\@=" nextgroup=scaladocBody
syn region scaladocBody start="\*" end="\*/" contains=@scaladocBodyCluster keepend fold contained
hi def link scaladoc Comment
hi link scaladocBody scaladoc
syn cluster scaladocBodyCluster contains=scaladocLeftMerginal,scaladocCodeBlock,@scaladocInlineElementCluster,@scaladocPreParseCluster,
    \ @scaladocHtml,@Spell,scaladocNotHtml

" fallback
syn match scaladocLeftMergin "^" contained
syn match scaladocLeftMergin "^\s*\*\s" contained
syn match scaladocLeftMergin "^\s*\*[^ \t]\@=" contained
syn match scaladocLeftMergin "^\s*\*$" contained
hi link scaladocLeftMergin scaladoc

if !exists("scaladoc_no_html")
    " suppress @scaladocHtml errors.
    syn match scaladocNotHtml ">\@=" contained
    syn match scaladocNotHtml "\%(&\%(#\=[0-9A-Za-z]\{1,8};\)\@!\)\@=" contained
    syn match scaladocNotHtml "\%(<$\)\@=" contained
    syn match scaladocNotHtml _\%(<[ \t()[\]{}.;,!#%&*+\-:<=>?@\\^|~'"`0-9]\)\@=_ contained
endif


" Before parsing
syn cluster scaladocPreParseCluster contains=scaladocEscape,scaladocMultiLineComment,scaladocLeftMergin
syn region scaladocMultiLineComment start="/\*" end="\*/" contains=scaladocMultiLineComment keepend extend contained
hi def link scaladocMultiLineComment scaladoc

" Scaladoc Escape
"   $scalaEscapedId seems good.
syn match scaladocEscape _\$[^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`0-9$][^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`$]*_ contained
hi def link scaladocEscape SpecialComment

" Scaladoc Inline Elements (https://wiki.scala-lang.org/display/SW/Syntax)
syn cluster scaladocInlineElementCluster contains=scaladocItalic,scaladocBold,scaladocUnderline,scaladocMonospace,scaladocSuperscript,
    \ scaladocSubscript,scaladocEntityLink,scaladocExternalLink
hi def link scaladocInlineElement SpecialComment
hi def link scaladocInlineElementQuote scaladocInlineElement
syn region scaladocItalic matchgroup=scaladocInlineElementQuote start="''" end="'''\@!" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocItalic scaladocInlineElement
syn region scaladocBold matchgroup=scaladocInlineElementQuote start="'''" end="''''\@!" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocBold scaladocInlineElement
syn region scaladocUnderline matchgroup=scaladocInlineElementQuote start="_\{2,}" end="___\@!" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocUnderline scaladocInlineElement
syn region scaladocMonospace matchgroup=scaladocInlineElementQuote start="`\+" end="`\+" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocMonospace scaladocInlineElement
" ^ is weird; forward reference would be required.
syn region scaladocSuperscript matchgroup=scaladocInlineElementQuote start="\^\+" end="\^\+" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocSuperscript scaladocInlineElement
syn region scaladocSubscript matchgroup=scaladocInlineElementQuote start=",\{2,}" end=",,,\@!" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocSubscript scaladocInlineElement
syn region scaladocEntityLink matchgroup=scaladocInlineElementQuote start="\[\[" end="\]\]" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocEntityLink scaladocInlineElement
syn region scaladocExternalLink matchgroup=scaladocInlineElement start="\[\[\%([A-Za-z][A-Za-z0-9+.-]*:\)\@=" end="\(\s.*\)\=\]\]" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocExternalLink Underlined

" Start of Block Elements, Tags or Annotations
syn match scaladocLeftMerginal "^" nextgroup=@scaladocLeftMerginalCluster contained " fallback
syn match scaladocLeftMerginal "^\s*\*\s" nextgroup=@scaladocLeftMerginalCluster contained
syn match scaladocLeftMerginal "\%(/\*\)\@<=\*\s" nextgroup=@scaladocLeftMerginalCluster contained
syn match scaladocLeftMerginal "^\s*\*[^ \t]\@=" nextgroup=@scaladocLeftMerginalCluster contained
syn match scaladocLeftMerginal "\%(/\*\)\@<=\*[^ \t]\@=" nextgroup=@scaladocLeftMerginalCluster contained
syn cluster scaladocLeftMerginalCluster contains=@scaladocTagCluster,@scaladocBlockElementCluster
hi link scaladocLeftMerginal scaladocLeftMergin


" Scaladoc Block Elements (https://wiki.scala-lang.org/display/SW/Syntax)

syn cluster scaladocBlockElementCluster contains=scaladocListItemStart,scaladocHeading
hi def link scaladocBlockElementQuote SpecialComment

syn region scaladocHeading matchgroup=scaladocHeadingQuote start="\s*\z(=\+\)" end="\z1" contains=@scaladocBodyCluster contained keepend 
hi def link scaladocHeadingQuote scaladocBlockElementQuote
hi def link scaladocHeading scaladoc

syn match scaladocListItemStart "\s\+-\s" contained
" syn match scaladocListItemStart "\s\+[0-9]\.\s" contained " not implemented?
hi link scaladocListItemStart scaladocListItemQuote 
hi def link scaladocListItemQuote scaladocBlockElementQuote


" Scaladoc Code Block
syn region scaladocCodeBlock matchgroup=scaladocCodeBlockQuote start="{{{" end="}}}" contains=@scaladocPreParseCluster contained keepend
hi def link scaladocCodeBlockQuote scaladocBlockElementQuote 
hi def link scaladocCodeBlock Normal


" Scaladoc Tags and Annotations (https://wiki.scala-lang.org/display/SW/Tags+and+Annotations)

syn cluster scaladocTagCluster contains=scaladocParam,scaladocTParam,scaladocReturn,scaladocThrows,scaladocSee,
    \ scaladocNote,scaladocExample,scaladocUsecase,scaladocAuthor,scaladocVersion,scaladocSince,scaladocTodo,scaladocDefine,scaladocInheritdoc
hi def link scaladocTag SpecialComment

syn match scaladocParam "\s*@constructor\>" contained 
hi def link scaladocParam scaladocTag
syn match scaladocParam "\s*@param\>" nextgroup=@scaladocIdHook contained skipwhite
hi def link scaladocParam scaladocTag
syn match scaladocTParam "\s*@tparam\>" nextgroup=@scaladocIdHook contained skipwhite
hi def link scaladocTParam scaladocTag
syn match scaladocReturn "\s*@return\>" contained
hi def link scaladocReturn scaladocTag
syn match scaladocThrows "\s*@throws\>" contained
hi def link scaladocThrows scaladocTag
syn match scaladocSee "\s*@see\>" contained
hi def link scaladocSee scaladocTag
syn match scaladocNote "\s*@note\>" contained
hi def link scaladocNote scaladocTag
syn match scaladocExample "\s*@example\>" contained
hi def link scaladocExample scaladocTag
syn match scaladocUsecase "\s*@usecase\>" contained
hi def link scaladocUsecase scaladocTag
syn match scaladocAuthor "\s*@author\>" contained
hi def link scaladocAuthor scaladocTag
syn match scaladocVersion "\s*@version\>" contained
hi def link scaladocVersion scaladocTag
syn match scaladocSince "\s*@since\>" contained
hi def link scaladocSince scaladocTag
syn match scaladocTodo "\s*@todo\>" contained
hi def link scaladocTodo scaladocTag
syn match scaladocDefine "\s*@define\>" nextgroup=scaladocEscapedId contained skipwhite
hi def link scaladocDefine scaladocTag
syn match scaladocInheritdoc "\s*@inheritdoc\>"
hi def link scaladocInheritdoc scaladocTag


" Afterword

let b:current_syntax = "scaladoc"

