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

scriptencoding utf-8

if exists("scala_xmlmode")
    syntax case match
    syntax include @scalaXml syntax/xml.vim
    unlet b:current_syntax
endif

if exists("scaladoc_html")
    syntax case ignore
    syntax include @scalaHtml syntax/html.vim
    unlet b:current_syntax
endif

let b:current_syntax = "scala"
syn case match

syn sync minlines=200 maxlines=1000


" ORDER MATTERS!


" Escape before parsing

syn cluster scalaPreParseCluster contains=scalaUnicodeEscape,scalaUnicodeEscapeError

" Unicode Escape (SLS 1.0)
syn match scalaUnicodeEscapeError "\\u" " fallback
syn match scalaUnicodeEscape "\\u\+[0-9A-Fa-f]\{4}"
hi def link scalaUnicodeEscape SpecialChar
hi def link scalaUnicodeEscapeError Error


" Identifiers

syn cluster scalaIdCluster contains=scalaAlphaid,scalaOp,scalaReservedOp,scalaLiteralId
hi def link scalaId Normal

" Mixed Identifiers
syn match scalaAlphaid "[A-Z$_a-z][A-Z$_a-z0-9]*"  nextgroup=scalaProcessedStringLiteralElement
syn match scalaAlphaid "[A-Z$_a-z][A-Z$_a-z0-9]*_" nextgroup=scalaOpInAlphaid,scalaProcessedStringLiteralElement,scalaOpInAlphaidInProcessedStringLiteral
hi def link scalaAlphaid scalaId

" Operator-only Identifiers
"   extended and ends immediately.
syn region scalaOp           start="[!#%&*+-/:<=>?@\\^]\+" end=".\@<=" contains=@scalaCommentCluster,@scalaPreParseCluster oneline
syn region scalaOpInAlphaid  start="[!#%&*+-/:<=>?@\\^]\+" end=".\@<=" contains=@scalaCommentCluster,@scalaPreParseCluster oneline contained
hi def link scalaOp scalaId
hi link scalaOpInAlphaid scalaAlphaid

" Literal Identifiers (SLS 1.1.2)
syn region scalaLiteralIdError matchgroup=Error start ="`" end ="$" " fallback
syn region scalaLiteralId start="`" end="`" contains=scalaCharEscape,@scalaPreParseCluster oneline keepend
hi def link scalaLiteralId scalaAlphaid


" Operators

" Reserved Operators (SLS 1.1)
syn match scalaReservedOp "\%([:=#@]\|=>\|<-\|<:\|<%\|>:\|\%u21d2\|\%u2190\)[!#%&+-/:<=>?@\\^]\@!"
hi def link scalaReservedOp Operator


" Delimiters

syn match scalaDelimiter "[()[\]{}.;,]"
hi def link scalaDelimiter Delimiter

syntax region scalaBlockExpr matchgroup=scalaDelimiter start="{" end="}" fold contains=TOP


" Keywords

syn cluster scalaKeywordCluster contains=scalaReservedWord,scalaLocalModifier,scalaImport,scalaMacro,scalaWildcard,scalaStandardType

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

" Modifiers
syn keyword scalaLocalModifier abstract final sealed implicit lazy
syn keyword scalaAccessModifier private protected
syn keyword scalaOverride override
hi def link scalaModifier StorageClass
hi def link scalaLocalModifier scalaModifier
hi def link scalaAccessModifier scalaModifier
hi def link scalaOverride scalaModifier

" For Vim standards
syn keyword scalaImport import
hi def link scalaImport Include
syn keyword scalaMacro macro
hi def link scalaMacro Macro

" Wildcard (SLS 1.1)
syn keyword scalaWildcard _
hi def link scalaWildcard Keyword


" Comments

syn cluster scalaCommentCluster contains=scalaSingleLineComment,scalaMultiLineComment

" Single-line Comments (SLS 1.4)
syn match scalaSingleLineComment "//.*" contains=@scalaCommentdocCluster
hi def link scalaSingleLineComment Comment

" Multi-line Comments (SLS 1.4) - can be nested.
syn region scalaMultiLineComment start="/\*" end="\*/" contains=scalaMultiLineComment,@scalaCommentdocCluster extend fold
hi def link scalaMultiLineComment scalaSingleLineComment


" Commentdoc - obsolete or not

syn cluster scalaCommentdocCluster contains=scalaTodo

" Todo
syn keyword scalaTodo TODO FIXME XXX contained
hi def link scalaTodo Todo


" Literals

syn cluster scalaLiteralCluster contains=@scalaSingleLineLiteralCluster,@scalaMultiLineLiteralCluster
syn cluster scalaSingleLineLiteralCluster contains=scalaIntegerLiteral,scalaFloatingPointLiteral,scalaBooleanLiteral,
    \ scalaUnclosedCharacterLiteralError,scalaSymbolLiteral,scalaCharacterLiteral,scalaSingleLineStringLiteral,
    \ scalaNullLiteral,scalaProcessedSingleLineStringLiteral
syn cluster scalaMultiLineLiteralCluster contains=scalaMultiLineStringLiteral,scalaProcessedMultiLineStringLiteral

" Integer Literals (SLS 1.3.1)
syn match scalaIntegerLiteral "\<\%(0\|\%([1-9]\%(0\|[1-9]\)*\)\)[Ll]\=\>"
syn match scalaIntegerLiteral "\<0[xX][0-9A-Fa-f]\+[Ll]\=\>"
hi def link scalaIntegerLiteral Number

" Floating Point Literals (SLS 1.3.2)
syn match scalaFloatingPointLiteral "\<[0-9]\+\.[0-9]\+\%([Ee][+-]\=[0-9]\+\)\=[FfDd]\=\>"
syn match scalaFloatingPointLiteral "\.[0-9]\+\%([Ee][+-]\=[0-9]\+\)\=[FfDd]\=\>"
syn match scalaFloatingPointLiteral "\<[0-9]\+[Ee][+-]\=[0-9]\+[FfDd]\=\>"
syn match scalaFloatingPointLiteral "\<[0-9]\+\%([Ee][+-]\=[0-9]\+\)\=[FfDd]\>"
hi def link scalaFloatingPointLiteral Float

" Boolean Literals (SLS 1.3.3)
syn keyword scalaBooleanLiteral true false
hi def link scalaBooleanLiteral Keyword

" fallback
syn match scalaUnclosedCharacterLiteralError "'"
hi def link scalaUnclosedCharacterLiteralError Error


" Symbol Literals (SLS 1.3.7) - 'scalaAlphaid and 'scalaOp; placed before Character Literals

syn match scalaSymbolLiteral "'[ \\]\@!" nextgroup=scalaAlphaidInSymbolLiteral,scalaOpInSymbolLiteral
syn match scalaSymbolLiteral "'\%(\\u\+[0-9A-Fa-f]\{4}\)\@=" " optimistic
hi def link scalaSymbolLiteral Constant
syn match scalaUnclosedCharacterLiteralError "'$"

syn match scalaAlphaidInSymbolLiteral "[A-Z$_a-z][A-Z$_a-z0-9]*"  contained
syn match scalaAlphaidInSymbolLiteral "[A-Z$_a-z][A-Z$_a-z0-9]*_" nextgroup=scalaOpInAlphaidInSymbolLiteral,@scalaCommentCluster contained
hi link scalaAlphaidInSymbolLiteral scalaSymbolLiteral

syn region scalaOpInSymbolLiteral          start="[!#%&*+-/:<=>?@\\^]\+" end=".\@<=" contains=@scalaCommentCluster,@scalaPreParseCluster oneline contained
syn region scalaOpInAlphaidInSymbolLiteral start="[!#%&*+-/:<=>?@\\^]\+" end=".\@<=" contains=@scalaCommentCluster,@scalaPreParseCluster oneline contained

hi link scalaOpInSymbolLiteral scalaSymbolLiteral
hi link scalaOpInAlphaidInSymbolLiteral scalaSymbolLiteral


" Character Literals (SLS 1.3.4)
syn match scalaCharacterLiteral /'\p'/
syn match scalaCharacterEscapeLiteral /'\\[btnfr"'\\]'/
syn match scalaCharacterOctalEscapeLiteral /'\\[0-7]\{1,3}'/ " deprecated
syn match scalaCharacterUnicodeEscapeLiteral /'\\u\+[0-9A-Fa-f]\{4}'/
hi def link scalaCharacterLiteral Character
hi def link scalaCharacterEscapeLiteral scalaCharEscape
hi def link scalaCharacterOctalEscapeLiteral scalaCharEscape
hi def link scalaCharacterUnicodeEscapeLiteral scalaUnicodeEscape

" Escape Sequences (SLS 1.3.6)
syn match scalaCharEscape /\\[btnfr"'\\]/ contained
hi def link scalaCharEscape SpecialChar

" Null Literal 
syn keyword scalaNullLiteral null
hi def link scalaNullLiteral Keyword

" String Literals (SLS 1.3.5)
syn region scalaUnclosedStringLiteralError matchgroup=Error start =/"/ skip=/\\"/ end =/$/ " fallback
syn region scalaStringLiteral start=/"/ skip=/\\"/ end=/"/ contains=@scalaPreParseCluster,scalaCharEscape keepend oneline
syn region scalaStringLiteral start=/"""/ end=/""""\@!/    contains=@scalaPreParseCluster                 keepend fold  " shall ignore scalaCharEscape.
hi def link scalaStringLiteral String


" Processed String Literals (SIP-11) - shall ignore scalaCharEscape.

" syn match scalaProcessedStringLiteral "[A-Z$_a-z][A-Z$_a-z0-9]*"  nextgroup=scalaProcessedStringLiteralElement
" syn match scalaProcessedStringLiteral "[A-Z$_a-z][A-Z$_a-z0-9]*_" nextgroup=scalaOpInAlphaidInProcessedStringLiteral,scalaProcessedStringLiteralElement
hi link scalaProcessedStringLiteral Error

syn region scalaProcessedStringLiteralElement start=/"/   end=/"/       contains=@scalaProcessedStringEscapeCluster keepend contained oneline
syn region scalaProcessedStringLiteralElement start=/"""/ end=/""""\@!/ contains=@scalaProcessedStringEscapeCluster keepend contained fold
hi link scalaProcessedStringLiteralElement scalaStringLiteral

syn region scalaOpInAlphaidInProcessedStringLiteral start="[!#%&*+-/:<=>?@\\^]\+" end=".\@<=" contains=@scalaCommentCluster,@scalaPreParseCluster
    \ nextgroup=scalaProcessedStringLiteralElement oneline contained
hi link scalaOpInAlphaidInProcessedStringLiteral scalaId

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
hi def link scalaInvalidStringInterpolationError Error


" Annotations (SLS 11.0)

" ???
hi def link scalaAnnotation PreProc


" Standard Types (SLS 12.1)

syn keyword scalaStandardType Any AnyRef AnyVal Unit Boolean Char Byte Short Int Long Float Double ScalaObject String Null Nothing
hi def link scalaStandardType Type


" Scaladoc (https://wiki.scala-lang.org/display/SW/Scaladoc)

syn region scaladoc start="/\*\*/\@!" end="\*/" contains=@scaladocBodyCluster keepend fold
hi def link scaladoc scalaMultiLineComment

" Keep normal multi-line comments away, otherwise eaten up.
syn region scaladocMultiLineComment start="/\*\*\@!"       end="/*/" contains=scaladocMultiLineComment keepend extend contained fold
syn region scaladocMultiLineComment start="[^/*]/\*\*/\@!" end="\*/" contains=scaladocMultiLineComment keepend extend contained fold
hi def link scaladocMultiLineComment scalaMultiLineComment

" Before parsing
syn cluster scaladocPreParseCluster contains=scaladocEscape,scalaMultiLineComment

" Scaladoc Escape
syn match scaladocEscape  "\$[A-Za-z_]\%([A-Za-z_]\|[0-9]\)*" nextgroup=scaladocEscapedId contained
syn match scaladocEscapedId "[A-Za-z_]\%([A-Za-z_]\|[0-9]\)*" contained
hi def link scaladocEscape SpecialComment
hi def link scaladocEscapedId SpecialComment

syn cluster scaladocBodyCluster contains=@scaladocNonBlockElementCluster,scaladocLeftMerginal
syn cluster scaladocNonBlockElementCluster contains=@scaladocInlineElementCluster,scaladocCodeBlock,scaladocMultiLineComment,scaladocEscape,@scalaHtml


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

syn region scaladocCodeBlock matchgroup=SpecialComment start="{{{" end="}}}" contains=scaladocCodeBlockLeftMergin,@scaladocPreParseCluster contained keepend " contains=@scaladocCodeBlockSyntaxCluster contained keepend " fold
syn match scaladocCodeBlockLeftMergin "^\%( *\*\)\+\%( \+\|$\)" contained
hi def link scaladocCodeBlockLeftMergin scaladoc
hi def link scaladocCodeBlock Normal

" override multi-line syntax for left-mergin

syn cluster scalaSingleLineSyntaxCluster contains=@scalaPreParseCluster,@scalaIdCluster,scalaDelimiter,@scalaKeywordCluster,
    \ @scalaSingleLineLiteralCluster,scalaSingleLineComment
syn cluster scaladocCodeBlockSyntaxCluster contains=@scalaSingleLineSyntaxCluster,scaladocCodeBlockLeftMergin,scaladocCodeBlockBlock,
    \ scaladocCodeBlockMultiLineComment,scaladocCodeBlockMultiLineStringLiteral,scaladocCodeBlockProcessedMultiLineStringLiteral,
    \ scaladocCodeBlockScaladoc,scaladocCodeBlockMultiLineStringLiteral,scaladocCodeBlockProcessedMultiLineStringLiteral,scaladocCodeBlockScaladoc

syn region scaladocCodeBlockMultiLineStringLiteral start=/"""/ end=/""""\@!/ contains=@scalaPreParseCluster,scaladocCodeBlockLeftMergin,scaladocPreParseCluster keepend contained " fold
hi def link scaladocCodeBlockMultiLineStringLiteral scalaMultiLineStringLiteral

syn region scaladocCodeBlockProcessedMultiLineStringLiteral matchgroup=scalaAlphaid  start=~[A-Z$_a-z][A-Z$_a-z0-9]*\%(_\@<=[!#%&*+-/:<=>?@\\^]\+\)\="""~rs=e-3 end=/""""\@!/re=e contains=@scalaProcessedStringEscapeCluster,scaladocCodeBlockLeftMergin keepend contained " fold
hi def link scaladocCodeBlockProcessedMultiLineStringLiteral scalaProcessedMultiLineStringLiteral

syn region scaladocCodeBlockMultiLineComment start="/\*" end="\*/" contains=scaladocCodeBlockMultiLineComment,scaladocCodeBlockLeftMergin,@scalaCommentdocCluster extend contained keepend " fold
hi def link scaladocCodeBlockMultiLineComment scalaMultiLineComment

" override not to fold
syn region scaladocCodeBlockScaladoc start="/\*\*/\@!" end="\*/" contains=@scaladocBodyCluster keepend extend contained " fold
hi def link scaladocCodeBlockScaladoc scaladoc

syntax region scalaBlockExpr matchgroup=scalaDelimiter start="{" end="}" fold contains=TOP
syn region scaladocCodeBlockBlock start="{" end="}" contains=@scaladocCodeBlockSyntaxCluster,scaladocCodeBlockLeftMergin extend contained keepend " fold
hi def link scaladocCodeBlockBlock scalaMultiLineComment


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
syn match scaladocThrows "@throws\>" nextgroup=scaladocTypeName contained skipwhite
hi def link scaladocThrows scaladocTagCluster
syn match scaladocSee "@see\>" contained
hi def link scaladocSee scaladocTagCluster
syn match scaladocNote "@note\>" contained
hi def link scaladocNote scaladocTagCluster
syn match scaladocExample "@example\>" contained
hi def link scaladocExample scaladocTagCluster
syn match scaladocUsecase "@usecase\>" nextgroup=scaladocSimpleDef contained skipwhite
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
syn match scaladocTypeName "[^ ]\+" contained
hi def link scaladocTypeName scalaId

" Probably ok.
syn region scaladocSimpleDef start="." end="$" contains=@scalaSingleLineSyntaxCluster,scaladocEscape contained oneline


" XML mode (SLS 1.5) " TODO

syn region scalaXmlMode start="[ ({]<[A-Z$_a-z0-9!?]" end="$" contains=@scalaXml
hi def link scalaXmlMode Normal

