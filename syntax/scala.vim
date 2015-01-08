" Vim syntax file
" Language: Scala
" Maintainer: Shunsuke Sogame <okomok@gmail.com>
" References:
"   Stefan Matthias Aust 2006
"   https://github.com/derekwyatt/vim-scala


" Preamble

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif


" Includes

if exists("scala_has_xmlmode")
    syntax case match
    syntax include @scalaXml syntax/xml.vim
    unlet b:current_syntax
endif

if exists("scaladoc_has_html")
    syntax case ignore
    syntax include @scalaHtml syntax/html.vim
    unlet b:current_syntax
endif


" The Scala syntax

let b:current_syntax = "scala"
syn case match
syn sync minlines=200 maxlines=1000

" XXX ORDER MATTERS!


" Syntax Error
syn match scalaSyntaxError "\S" "fallback
if !exists("scala_has_unicode")
    hi def link scalaSyntaxError Error
else
    hi def link scalaSyntaxError Normal
endif

" Escape before parsing
if !exists("scala_scaladocmode")
    syn cluster scalaPreParseCluster contains=scalaUnicodeEscape,scalaUnicodeEscapeError
else " TODO
    syn cluster scalaPreParseCluster contains=@scaladocPreParseCluster
endif

" Unicode Escape (SLS 1.0)
syn match scalaUnicodeEscapeError "\\u" " fallback
syn match scalaUnicodeEscape "\\u\+[0-9A-Fa-f]\{4}"
hi def link scalaUnicodeEscape SpecialChar
hi link scalaUnicodeEscapeError scalaSyntaxError

" Identifiers
syn cluster scalaIdCluster contains=scalaAlphaid,scalaOp,scalaReservedOp,scalaLiteralId

" Mixed Identifiers
syn match scalaAlphaid "[A-Z$_a-z][A-Z$_a-z0-9]*"  nextgroup=scalaProcessedStringLiteralElement
syn match scalaAlphaid "[A-Z$_a-z][A-Z$_a-z0-9]*_" nextgroup=scalaOpInAlphaid,scalaProcessedStringLiteralElement,scalaOpInAlphaidInProcessedStringLiteral
if !exists("scala_has_unicode")
    hi def link scalaAlphaid Identifier
else
    hi def link scalaAlphaid Normal
endif
hi link scalaOpInAlphaid scalaAlphaid

" Operator-only Identifiers
"   extended and ends immediately.
syn region scalaOp           start="[!#%&*+-/:<=>?@\\^|~]\+" end=".\@<=" contains=@scalaCommentCluster,@scalaPreParseCluster oneline
syn region scalaOpInAlphaid  start="[!#%&*+-/:<=>?@\\^|~]\+" end=".\@<=" contains=@scalaCommentCluster,@scalaPreParseCluster oneline contained
if !exists("scala_has_unicode")
    hi def link scalaOp Operator
else
    hi def link scalaOp Normal
endif

" Literal Identifiers (SLS 1.1.2)
syn region scalaLiteralId start="`" end="`" contains=scalaCharEscape,@scalaPreParseCluster oneline keepend
hi def link scalaLiteralId scalaAlphaid

" Delimiters
syn match scalaDelimiter "[()[\]{}.;,]"
hi def link scalaDelimiter Delimiter
syntax region scalaBlockExpr matchgroup=scalaDelimiter start="{" end="}" fold contains=TOP

" Reserved Words (SLS 1.1)
syn keyword scalaReservedWord abstract case catch class def
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
syn match scalaReservedOp "\%([:=#@]\|=>\|<-\|<:\|<%\|>:\|\%u21d2\|\%u2190\)[!#%&*+-/:<=>?@\\^|~]\@!"
hi def link scalaReservedOp Keyword

" Modifiers
syn keyword scalaModifier abstract final sealed implicit lazy override
syn keyword scalaAccessModifier private protected
hi def link scalaModifier StorageClass
hi def link scalaAccessModifier scalaModifier

" Wildcard
syn keyword scalaWildcard _
hi def link scalaWildcard Keyword

" Statement for Vim Standards
syn keyword scalaConditional else if
hi def link scalaConditional Conditional
syn keyword scalaRepeat do for while yield
hi def link scalaRepeat Repeat
syn keyword scalaLabel case match
" syn match scalaLabel "\<case\>" " you can't win against keyword.
hi def link scalaLabel Label
syn keyword scalaException catch finally throw try
hi def link scalaException Exception
syn keyword scalaReturn return
hi def link scalaReturn Statement

" PreProc for Vim Standards
syn keyword scalaImport import
hi def link scalaImport Include
syn keyword scalaMacro macro
hi def link scalaMacro Macro

" Type for Vim Standards
syn keyword scalaStructure class extends forSome object package trait type
hi def link scalaStructure Structure

" Case Modifier
" TODO: how to skip newlines?
" syn region scalaCaseModifier start="case\%(\%(\W\)*class\>\)\@=" end="\%(class\)\@<=" 
" syn match scalaCaseModifier "case\s*\%(class\>\|object\>\)\@="
" hi def link scalaCaseModifier scalaModifier

" Comments
syn cluster scalaCommentCluster contains=scalaSingleLineComment,scalaMultiLineComment

" Single-line Comments (SLS 1.4)
syn match scalaSingleLineComment "//.*" contains=@scalaCommentdocCluster
hi def link scalaSingleLineComment Comment

" Multi-line Comments (SLS 1.4) - can be nested.
syn region scalaMultiLineComment start="/\*" end="\*/" contains=scalaMultiLineComment,@scalaCommentdocCluster extend fold
hi def link scalaMultiLineComment scalaSingleLineComment

" Commentdoc - obsolete or not
syn cluster scalaCommentdocCluster contains=scalaCommentdocTag
syn keyword scalaCommentdocTag TODO FIXME XXX NOTE contained
hi def link scalaCommentdocTag Todo

" Literals
syn cluster scalaLiteralCluster contains=@scalaSingleLineLiteralCluster,@scalaMultiLineLiteralCluster
syn cluster scalaSingleLineLiteralCluster contains=scalaIntegerLiteral,scalaFloatingPointLiteral,scalaBooleanLiteral,
    \ scalaUnclosedCharacterLiteralError,scalaSymbolLiteral,scalaCharacterLiteral,scalaSingleLineStringLiteral,
    \ scalaNullLiteral,scalaProcessedSingleLineStringLiteral
syn cluster scalaMultiLineLiteralCluster contains=scalaMultiLineStringLiteral,scalaProcessedMultiLineStringLiteral

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


" Symbol Literals (SLS 1.3.7) - 'scalaAlphaid and 'scalaOp; placed before Character Literals

syn match scalaSymbolLiteral "'" nextgroup=scalaAlphaidInSymbolLiteral,scalaOpInSymbolLiteral
hi def link scalaSymbolLiteral Constant

" following scalac behavior
syn match scalaSymbolLiteral "'/"   nextgroup=scalaOpInSymbolLiteral
syn match scalaSymbolLiteral "'/\*" nextgroup=scalaOpInSymbolLiteral

syn match scalaAlphaidInSymbolLiteral "[A-Z$_a-z][A-Z$_a-z0-9]*"  contained
syn match scalaAlphaidInSymbolLiteral "[A-Z$_a-z][A-Z$_a-z0-9]*_" nextgroup=scalaOpInAlphaidInSymbolLiteral,@scalaCommentCluster contained
hi link scalaAlphaidInSymbolLiteral scalaSymbolLiteral

syn region scalaOpInSymbolLiteral          start="[!#%&*+-/:<=>?@\\^|~]\+" end=".\@<=" contains=@scalaCommentCluster,@scalaPreParseCluster oneline contained
syn region scalaOpInAlphaidInSymbolLiteral start="[!#%&*+-/:<=>?@\\^|~]\+" end=".\@<=" contains=@scalaCommentCluster,@scalaPreParseCluster oneline contained

hi link scalaOpInSymbolLiteral scalaSymbolLiteral
hi link scalaOpInAlphaidInSymbolLiteral scalaSymbolLiteral


" Character Literals (SLS 1.3.4)
syn match scalaUnclosedCharacterLiteralError "'$"
syn match scalaUnclosedCharacterLiteralError "'\s\@="
syn match scalaUnclosedCharacterLiteralError "'\\\%(u\+[0-9A-Fa-f]\{4}\)\@!" " optimistic
hi link scalaUnclosedCharacterLiteralError scalaSyntaxError
syn match scalaCharacterLiteral /'\p'/
syn match scalaCharEscapeCharacterLiteral /'\\[btnfr"'\\]'/
syn match scalaOctalEscapeCharacterLiteral /'\\[0-7]\{1,3}'/ " deprecated
syn match scalaUnicodeEscapeCharacterLiteral /'\\u\+[0-9A-Fa-f]\{4}'/
hi def link scalaCharacterLiteral Character
hi def link scalaCharEscapeCharacterLiteral scalaCharacterLiteral
hi def link scalaOctalEscapeCharacterLiteral scalaCharacterLiteral
hi def link scalaUnicodeEscapeCharacterLiteral scalaCharacterLiteral

" Escape Sequences (SLS 1.3.6)
syn match scalaCharEscape /\\[btnfr"'\\]/ contained
hi def link scalaCharEscape SpecialChar

" Null Literal 
syn keyword scalaNullLiteral null
hi def link scalaNullLiteral Keyword

" String Literals (SLS 1.3.5)
syn region scalaStringLiteral start=/"/ skip=/\\"/ end=/"/ contains=@scalaPreParseCluster,scalaCharEscape keepend oneline
syn region scalaStringLiteral start=/"""/ end=/""""\@!/    contains=@scalaPreParseCluster                 keepend fold  " shall ignore scalaCharEscape.
hi def link scalaStringLiteral String


" Processed String Literals (SIP-11) - shall ignore scalaCharEscape.

syn region scalaProcessedStringLiteralElement start=/"/   end=/"/       contains=@scalaProcessedStringEscapeCluster keepend contained oneline
syn region scalaProcessedStringLiteralElement start=/"""/ end=/""""\@!/ contains=@scalaProcessedStringEscapeCluster keepend contained fold
hi link scalaProcessedStringLiteralElement scalaStringLiteral

syn region scalaOpInAlphaidInProcessedStringLiteral start="[!#%&*+-/:<=>?@\\^|~]\+" end=".\@<=" contains=@scalaCommentCluster,@scalaPreParseCluster
    \ nextgroup=scalaProcessedStringLiteralElement oneline contained
hi link scalaOpInAlphaidInProcessedStringLiteral scalaAlphaId

syn cluster scalaProcessedStringEscapeCluster add=scalaEscape,scalaInvalidStringInterpolationError,scalaDollarEscape,@scalaPreParseCluster

syn match scalaEscape "\$" nextgroup=scalaEscapedId,scalaEscapedBlock contained
" slightly different from scalaAlphaid for some reason
syn match scalaEscapedId "[A-Za-z_]\%([A-Za-z_]\|[0-9]\)*" contained
syn match scalaDollarEscape "\$\$" contained
syn region scalaEscapedBlock matchgroup=scalaDelimiter start="{" end="}" contained contains=TOP keepend
hi def link scalaEscape SpecialChar
hi def link scalaDollarEscape SpecialChar
hi def link scalaEscapedId scalaAlphaid

syn match scalaInvalidStringInterpolationError "\$[A-Za-z$_{]\@!" contained
hi def link scalaInvalidStringInterpolationError scalaSyntaxError


" Annotations (SLS 11.0)
" hi def link scalaAnnotation PreProc

" Standard Types (SLS 12.1)
syn keyword scalaStandardType Any AnyRef AnyVal Unit Boolean Char Byte Short Int Long Float Double ScalaObject String Null Nothing
hi def link scalaStandardType Type


" Scaladoc (https://wiki.scala-lang.org/display/SW/Scaladoc)

syn region scaladoc start="/\*\*/\@!" end="\*/" contains=@scaladocBodyCluster keepend fold
hi def link scaladoc scalaMultiLineComment
syn cluster scaladocBodyCluster contains=@scaladocNonBlockElementCluster,scaladocLeftMerginal
syn cluster scaladocNonBlockElementCluster contains=@scaladocInlineElementCluster,scaladocCodeBlock,scaladocMultiLineComment,scaladocEscape,@scalaHtml

" Keep normal multi-line comments away, otherwise eaten up.
syn region scaladocMultiLineComment start="/\*\*\@!"       end="/*/" contains=scaladocMultiLineComment keepend extend contained fold
syn region scaladocMultiLineComment start="[^/*]/\*\*/\@!" end="\*/" contains=scaladocMultiLineComment keepend extend contained fold
hi def link scaladocMultiLineComment scalaMultiLineComment

" Before parsing
syn cluster scaladocPreParseCluster contains=scaladocEscape,scalaMultiLineComment,scaladocCodeBlockLeftMergin

" Scaladoc Escape
syn match scaladocEscape  "\$[A-Za-z_]\%([A-Za-z_]\|[0-9]\)*" nextgroup=scaladocEscapedId contained
syn match scaladocEscapedId "[A-Za-z_]\%([A-Za-z_]\|[0-9]\)*" contained
hi def link scaladocEscape SpecialComment
hi def link scaladocEscapedId SpecialComment

" Scaladoc Inline Elements (https://wiki.scala-lang.org/display/SW/Syntax)
syn cluster scaladocInlineElementCluster contains=scaladocItalic,scaladocBold,scaladocUnderline,scaladocMonospace,scaladocSuperscript,
    \ scaladocSubscript,scaladocEntityLink
hi def link scaladocInlineElement SpecialComment
syn region scaladocItalic start="''" end="''" contains=@scaladocPreParseCluster contained oneline keepend
hi def link scaladocItalic scaladocInlineElement
syn region scaladocBold start="'''" end="'''" contains=@scaladocPreParseCluster contained oneline keepend
hi def link scaladocBold scaladocInlineElement
syn region scaladocUnderline start="__" end="__" contains=@scaladocPreParseCluster contained oneline keepend
hi def link scaladocUnderline scaladocInlineElement
syn region scaladocMonospace start="`" end="`" contains=@scaladocPreParseCluster contained oneline keepend
hi def link scaladocMonospace scaladocInlineElement
syn region scaladocSuperscript start="\^" end="\^" contains=@scaladocPreParseCluster contained oneline keepend
hi def link scaladocSuperscript scaladocInlineElement
syn region scaladocSubscript start=",," end=",," contains=@scaladocPreParseCluster contained oneline keepend
hi def link scaladocSubscript scaladocInlineElement
syn region scaladocEntityLink start="\[\[" end="\]\]" contains=@scaladocPreParseCluster contained oneline keepend
hi def link scaladocEntityLink scaladocInlineElement

" Start of Block Elements, Tags or Annotations
syn match scaladocLeftMerginal "\%(/\*\* *\|^\%( *\*\)\+\%( \+\|$\)\)" nextgroup=@scaladocTagCluster,@scaladocBlockElementCluster contained
hi def link scaladocLeftMerginal scaladoc


" Scaladoc Block Elements (https://wiki.scala-lang.org/display/SW/Syntax)

syn cluster scaladocBlockElementCluster contains=scaladocListBlock,scaladocHeading
hi def link scaladocBlockElementCluster SpecialComment

syn region scaladocHeading matchgroup=scaladocHeadingQuote start="=\+" end="=\+" contains=@scaladocNonBlockElementCluster contained keepend oneline
hi def link scaladocHeadingQuote SpecialComment
hi def link scaladocHeading scaladoc

syn match scaladocListBlock "- " contained
syn match scaladocListBlock "[A-Za-z0-9]\. " contained
hi def link scaladocListBlock SpecialComment


" Scaladoc Code Block
syn region scaladocCodeBlock matchgroup=SpecialComment start="{{{" end="}}}" contains=@scaladocPreParseCluster contained keepend
syn match scaladocCodeBlockLeftMergin "^\%( *\*\)\+\%( \+\|$\)" contained
hi def link scaladocCodeBlockLeftMergin scaladoc
hi def link scaladocCodeBlock Normal


" Scaladoc Tags and Annotations (https://wiki.scala-lang.org/display/SW/Tags+and+Annotations)

syn cluster scaladocTagCluster contains=scaladocParam,scaladocTParam,scaladocReturn,scaladocThrows,scaladocSee,
    \ scaladocNote,scaladocExample,scaladocUsecase,scaladocAuthor,scaladocVersion,scaladocSince,scaladocTodo,scaladocDefine,scaladocInheritdoc
hi def link scaladocTagCluster SpecialComment

syn match scaladocParam "@constructor\>" contained 
hi def link scaladocParam scaladocTagCluster
syn match scaladocParam "@param\>" nextgroup=@scalaIdCluster contained skipwhite
hi def link scaladocParam scaladocTagCluster
syn match scaladocTParam "@tparam\>" nextgroup=@scalaIdCluster contained skipwhite
hi def link scaladocTParam scaladocTagCluster
syn match scaladocReturn "@return\>" contained
hi def link scaladocReturn scaladocTagCluster
syn match scaladocThrows "@throws\>" contained " nextgroup=scaladocTypeName contained skipwhite
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

" Type? - I don't know how to parse a type followed by text.
" syn match scaladocTypeName "\S\+" contained
" hi def link scaladocTypeName scalaId

" XML mode (SLS 1.5) " TODO
syn region scalaXmlMode start="[ ({]<[A-Z$_a-z0-9!?]" end="$" contains=@scalaXml
hi def link scalaXmlMode Normal
