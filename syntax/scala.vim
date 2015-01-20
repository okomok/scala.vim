" Vim syntax file
" Language: Scala
" Maintainer: Shunsuke Sogame <okomok@gmail.com>
" References:
"   http://www.scala-lang.org/files/archive/spec/2.11/
"   http://docs.scala-lang.org/sips/pending/string-interpolation.html 
"   syntax/c.vim
"   syntax/html.vim
"   syntax/xml.vim
"   https://github.com/scala/scala-tool-support/tree/master/tool-support/vim
"   https://github.com/derekwyatt/vim-scala
"   http://www.tutorialspoint.com/scala/scala_basic_syntax.htm
"   http://blog.dieweltistgarnichtso.net/constructing-a-regular-expression-that-matches-uris


" Preamble

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif


" Includes

if exists("scala_has_xmlmode")
    syntax case match
    let g:xml_syntax_folding=1 " enables xmlRegion.
    syntax include @scalaXml syntax/xml.vim
    unlet b:current_syntax
endif


" The Scala syntax

syn case match
syn sync minlines=200 maxlines=1000

" XXX ORDER MATTERS!


" Syntax Error
syn match scalaSyntaxError "\S" " fallback
hi def link scalaSyntaxError Error

" Escape before parsing
if !exists("scala_scaladocmode")
    syn cluster scalaPreParseCluster contains=scalaUnicodeEscape,scalaUnicodeEscapeError
else " TODO or not TODO
    syn cluster scalaPreParseCluster contains=@scaladocPreParseCluster
endif

" Unicode Escape (SLS 1.0)
syn match scalaUnicodeEscapeError "\\\@<!\\u" " fallback
syn match scalaUnicodeEscape "\\u\+[0-9A-Fa-f]\{4}"
hi def link scalaUnicodeEscape SpecialChar
hi def link scalaUnicodeEscapeError scalaSyntaxError


" Identifiers

hi def link scalaNonOpId Identifier

" Alphanumeric Identifiers
syn match scalaAlphaId $[^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`0-9][^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`]*$  nextgroup=scalaProcessedStringLiteralElement
hi def link scalaAlphaId scalaNonOpId

" Mixed Identifiers
syn match scalaMixedId $[^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`0-9][^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`]*_[!#%&*+\-/:<=>?@\\^|~]\@=\%(//\|/\*\)\@!$ nextgroup=scalaOpInMixedId,scalaProcessedStringLiteralElement
hi def link scalaMixedId scalaNonOpId

" Operator-only Identifiers
"   extended and ends immediately.
syn region scalaOp          start="[!#%&*+\-/:<=>?@\\^|~]\+" end=".\@=" end="$" contains=@scalaCommentCluster,@scalaPreParseCluster oneline
syn region scalaOpInMixedId start="[!#%&*+\-/:<=>?@\\^|~]\+" end=".\@=" end="$" contains=@scalaCommentCluster,@scalaPreParseCluster nextgroup=scalaProcessedStringLiteralElement oneline contained
hi def link scalaOp Operator
hi link scalaOpInMixedId scalaMixedId

" Literal Identifiers (SLS 1.1.2)
syn region scalaLiteralId start="`" end="`" contains=scalaCharEscape,@scalaPreParseCluster oneline keepend
hi def link scalaLiteralId scalaNonOpId


" Delimiters
syn match scalaDelimiter "[()[\]{}.;,]"
hi def link scalaDelimiter Delimiter
syntax region scalaBlockExpr matchgroup=scalaDelimiter start="{" end="}" fold contains=TOP

" Reserved Words (SLS 1.1)
syn keyword scalaReservedWord abstract catch class def
syn keyword scalaReservedWord do else extends false final
syn keyword scalaReservedWord finally for forSome if implicit
syn keyword scalaReservedWord import lazy match new null
syn keyword scalaReservedWord object override package private protected
syn keyword scalaReservedWord return sealed super this throw
syn keyword scalaReservedWord trait try true type val
syn keyword scalaReservedWord var while with yield
syn keyword scalaReservedWord macro
hi def link scalaReservedWord Keyword

" Reserved Operators (SLS 1.1)
syn match scalaReservedOp "\%([:=#@]\|=>\|<-\|<:\|<%\|>:\|\%u21d2\|\%u2190\)[!#%&*+\-/:<=>?@\\^|~]\@!"
hi def link scalaReservedOp Keyword

" Wildcard
syn keyword scalaWildcard _
hi def link scalaWildcard Keyword

" Statement of Vim Standards
syn keyword scalaConditional else if
hi def link scalaConditional Conditional
syn keyword scalaRepeat do for while yield
hi def link scalaRepeat Repeat
syn keyword scalaLabel match
syn match scalaLabel "case\>" " keyword won't be beaten.
hi def link scalaLabel Label
syn keyword scalaException catch finally throw try
hi def link scalaException Exception
syn keyword scalaReturn return
hi def link scalaReturn Statement

" PreProc of Vim Standards
syn keyword scalaImport import
hi def link scalaImport Include
syn keyword scalaMacro macro
hi def link scalaMacro Macro

" Type of Vim Standards
syn keyword scalaStructure class extends forSome object package trait type with
hi def link scalaStructure Structure

" Modifiers
syn keyword scalaModifier abstract final sealed implicit lazy override
syn match scalaModifier "case\%(\s\|\n\)*\%(\<object\>\|\<class\>\)\@="
syn keyword scalaAccessModifier private protected
hi def link scalaModifier StorageClass
hi def link scalaAccessModifier scalaModifier


" Comments

syn cluster scalaCommentCluster contains=scalaSingleLineComment,scalaMultiLineComment
hi def link scalaComment Comment
syn cluster scalaCommentBodyCluster contains=@scalaCommentdocCluster,@Spell

" Single-line Comments (SLS 1.4)
syn match scalaSingleLineComment "//.*" contains=@scalaCommentBodyCluster
hi def link scalaSingleLineComment scalaComment

" Multi-line Comments (SLS 1.4) - can be nested.
syn region scalaMultiLineComment start="/\*" end="\*/" contains=scalaMultiLineComment,@scalaCommentBodyCluster keepend extend fold
hi def link scalaMultiLineComment scalaComment

" Commentdoc
syn cluster scalaCommentdocCluster contains=scalaCommentdocTodo,scalaCommentdocTag
syn keyword scalaCommentdocTodo TODO FIXME XXX nextgroup=scalaCommentdocTagDelimiter contained
syn match scalaCommentdocTag "\%(\%(/\*\|^\%(\s*\*\)*\|//\)\s*\)\@<=[A-Z][A-Za-z0-9+.-]*:\s\@=" contained " like a URI scheme
syn match scalaCommentdocTagDelimiter ":" contained
hi def link scalaCommentdocTodo Todo
hi def link scalaCommentdocTag SpecialComment
hi def link scalaCommentdocTagDelimiter scalaCommentdocTag


" Integer Literals (SLS 1.3.1)
syn match scalaIntegerLiteral "\%(0\|\%([1-9]\%(0\|[1-9]\)*\)\)[Ll]\=\>"
syn match scalaIntegerLiteral "0[xX][0-9A-Fa-f]\+[Ll]\=\>"
hi def link scalaIntegerLiteral Number

" Floating Point Literals (SLS 1.3.2)
syn match scalaFloatingPointLiteral "[0-9]\+\.[0-9]\+\%([Ee][+-]\=[0-9]\+\)\=[FfDd]\=\>"
syn match scalaFloatingPointLiteral "\.[0-9]\+\%([Ee][+-]\=[0-9]\+\)\=[FfDd]\=\>"
syn match scalaFloatingPointLiteral "[0-9]\+[Ee][+-]\=[0-9]\+[FfDd]\=\>"
syn match scalaFloatingPointLiteral "[0-9]\+\%([Ee][+-]\=[0-9]\+\)\=[FfDd]\>"
hi def link scalaFloatingPointLiteral Float

" Boolean Literals (SLS 1.3.3)
syn keyword scalaBooleanLiteral true false
hi def link scalaBooleanLiteral Keyword


" Symbol Literals (SLS 1.3.7) - placed before Character Literals

syn match scalaSymbolLiteral "'" nextgroup=scalaAlphaMixedIdInSymbolLiteral,scalaOpInSymbolLiteral
hi def link scalaSymbolLiteral Constant

" following scalac behavior
syn match scalaSymbolLiteral "'/"   nextgroup=scalaOpInSymbolLiteral
syn match scalaSymbolLiteral "'/\*" nextgroup=scalaOpInSymbolLiteral

syn match scalaAlphaMixedIdInSymbolLiteral $[^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`0-9][^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`]*$  contained
syn match scalaAlphaMixedIdInSymbolLiteral $[^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`0-9][^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`]*_$ nextgroup=scalaOpInAlphaMixedIdInSymbolLiteral,@scalaCommentCluster contained
hi link scalaAlphaMixedIdInSymbolLiteral scalaSymbolLiteral

syn region scalaOpInSymbolLiteral               start="[!#%&*+\-/:<=>?@\\^|~]\+" end=".\@=" end="$" contains=@scalaCommentCluster,@scalaPreParseCluster oneline contained
syn region scalaOpInAlphaMixedIdInSymbolLiteral start="[!#%&*+\-/:<=>?@\\^|~]\+" end=".\@=" end="$" contains=@scalaCommentCluster,@scalaPreParseCluster oneline contained

hi link scalaOpInSymbolLiteral scalaSymbolLiteral
hi link scalaOpInAlphaMixedIdInSymbolLiteral scalaSymbolLiteral


" Character Literals (SLS 1.3.4)
syn match scalaUnclosedCharacterLiteralError "'$"
syn match scalaUnclosedCharacterLiteralError "'\s\@="
syn match scalaUnclosedCharacterLiteralError "'\\\%(u\+[0-9A-Fa-f]\{4}\)\@!" " optimistic
hi def link scalaUnclosedCharacterLiteralError scalaSyntaxError
syn match scalaCharacterLiteral /'.'/
syn match scalaCharacterLiteral              /'\%(\\[btnfr"'\\]'\)\@=/
syn match scalaCharacterLiteral              /\%('\\[btnfr"'\\]\)\@<='/
syn match scalaCharEscapeInCharacterLiteral /'\@<=\\[btnfr"'\\]'\@=/
syn match scalaCharacterLiteral               /'\%(\\[0-7]\{1,3}'\)\@=/
syn match scalaCharacterLiteral               /\%('\\[0-7]\{1,3}\)\@<='/
syn match scalaOctalEscapeInCharacterLiteral /'\@<=\\[0-7]\{1,3}'\@=/
syn match scalaCharacterLiteral                 /'\%(\\u\+[0-9A-Fa-f]\{4}'\)\@=/
syn match scalaCharacterLiteral                 /\%('\\u\+[0-9A-Fa-f]\{4}\)\@<='/
syn match scalaUnicodeEscapeInCharacterLiteral /'\@<=\\u\+[0-9A-Fa-f]\{4}'\@=/
hi def link scalaCharacterLiteral Character
hi def link scalaOctalEscapeInCharacterLiteral scalaCharEscape
hi def link scalaUnicodeEscapeInCharacterLiteral scalaUnicodeEscape
hi def link scalaCharEscapeInCharacterLiteral scalaCharEscape

" Escape Sequences (SLS 1.3.6)
syn match scalaCharEscape /\\[btnfr"'\\]/ contained 
hi def link scalaCharEscape SpecialChar

" Null Literal 
syn keyword scalaNullLiteral null
hi def link scalaNullLiteral Keyword


" String Literals (SLS 1.3.5)

hi def link scalaStringLiteral String

" Single-line String Literals
"   not extended for better Error highlighting.
syn region scalaSingleLineStringLiteral start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=@scalaPreParseCluster,scalaCharEscape keepend oneline
hi def link scalaSingleLineStringLiteral scalaStringLiteral

" Multi-line String Literals - shall ignore scalaCharEscape.
syn region scalaMultiLineStringLiteral start=/"""/ end=/""""\@!/ contains=@scalaPreParseCluster keepend fold
hi def link scalaMultiLineStringLiteral scalaStringLiteral


" Processed String Literals (SIP-11) - shall ignore scalaCharEscape.

syn region scalaProcessedStringLiteralElement start=/"/   end=/"/       contains=@scalaProcessedStringEscapeCluster keepend contained oneline
syn region scalaProcessedStringLiteralElement start=/"""/ end=/""""\@!/ contains=@scalaProcessedStringEscapeCluster keepend contained fold
hi def link scalaProcessedStringLiteralElement scalaStringLiteral

syn cluster scalaProcessedStringEscapeCluster add=scalaEscape,scalaInvalidStringInterpolationError,scalaDollarEscape,@scalaPreParseCluster
syn match scalaEscape "\$" nextgroup=scalaEscapedId,scalaEscapedBlock contained

" scalaAlphaId except for `$`
syn match scalaEscapedId _[^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`0-9$][^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`$]*_ contained

syn match scalaDollarEscape "\$\$" contained
syn region scalaEscapedBlock matchgroup=scalaDelimiter start="{" end="}" contained contains=TOP keepend
hi def link scalaEscape scalaCharEscape
hi def link scalaEscapedId scalaAlphaId
hi def link scalaDollarEscape scalaCharEscape

syn match scalaInvalidStringInterpolationError "\$[ \t()[\]}.;,!#%&*+\-/:<=>?@\\^|~'"`0-9]\@=" contained
hi def link scalaInvalidStringInterpolationError scalaSyntaxError


" Standard Types (SLS 12.1)
syn keyword scalaStandardType Any AnyRef AnyVal Unit Boolean Char Byte Short Int Long Float Double ScalaObject String Null Nothing
hi def link scalaStandardType Type

" Scaladoc
if !exists("scala_no_scaladoc")
    syn cluster scaladocIdHook contains=scalaAlphaId,scalaMixedId,scalaOp,scalaReservedOp,scalaLiteralId
    runtime! syntax/scaladoc.vim
    unlet b:current_syntax
endif

" XML mode (SLS 1.5)
syn cluster xmlRegionHook add=scalaEscapedBlock
syn cluster xmlStartTagHook add=scalaEscapedBlock
syn match scalaXmlMode _[ \t({]\%(<[^ \t()[\]{}.;,!#%&*+\-/:<=>?@\\^|~'"`0-9]\)\@=_ nextgroup=@scalaXml


" Afterword

let b:current_syntax = "scala"

