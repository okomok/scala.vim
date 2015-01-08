

// Modified https://github.com/derekwyatt/vim-scala/syntax/testfile.scala
//   and more.


package testfile
import java.something.com

private object ModifierTest {
    // TODO
    case object x
    case class x
    case
        object x
    case
        class x
    private val i = x
}

object StandardTest {
    if (true) {
    }

    match x {
        case i => hello
        case object2 => hello
        case class2 => hello
    }

    try {
        throw new X
    } catch {
    } finally {
    }
}

object Identifier {
    val A_/* comment */ =3l
    val -*-*/* comment */ = 3
    val **// comment
        = 3
    val \ = 3
    val / = 3
    ++/**/"hello" = 3

    /*  */

    val A_/ = 3
    val abc = 3

    val _/* comment */ = 3
    val _// comment
       = 3
    val A_/* comment */ = 3
    val __// comment
       = 3

    /*^**/
    val A_/**/ = 3
    val k = a|b
}

object UnicodeEscape {
    val \u1431 = 0
    val \\\\\uuuuuu1543= 0 // should be broken
    val \u12345 = 0 // shall be broken, but optimistically no errors.
    val \\\\u1533 // shall be broken
    val s = "\\u1532" // '\\' should win.
    val a\u1323d = b
}

object ReservedWordEscape {
    val x = true 
    val x = TRUE // not a keyword
    val y = `true` // not a keyword
    val z = `=` // not a keyword
    val k = ` \n ` // shall escape.
    val k = ` \u0061 ` // shall escape.
    val k = 3 +* 2
    val k = 3 + 2
    val k = 3 * 2
    val err = `
    val err = `true
    val ok = ` // s `
    val ok = ` /* s */ `
}

object ReservedOperator {
    for {
        x <- y
        v<-z
    } yield ()

    import x._
    val f = Int ==> Double

    val f: Int=>Int = 0
    val f: Int<:Double = 0
    def foo: Int = 0
    type x = y#zz
    def foo[x<:Int>:Int] = 0
    def foo[x<%Foo] = 0
+1
$hello
    $h$h

    val \u = 3 // error
    val \ua = 3 // error
    val \\\ = 3
    val ::: : A = 3
    val _ : A => B = 3
    val A_<% = 4
    val _x = 3 // not reserved
    val __+ = 3 // not reserved
    val --> = 3 // not reserved
    val `:` = 3 // not reserved
    val a_\ = 4
    val A_/**/ = 3
}

object NullLiteral {
    val x = null
}

object SingleLineComments {
    val x: Int = 0 // lookma

    val z = 'fa+ 3 // ' fa + 3 comment
    val k = "fa + 3 // " fa + 3 // no comment
}

object MultiLineComments {
    val x /**/ = 0
    val y = /*lookma*/0

    /**
     * I forgot comments! [[scala.Option]]
     *
     * {{{
     * scala> This is a REPL line
     * scala> and this is another one
     * }}}
     *
     * <li></li>
     *
     * @param parameter Explanation of the parameter.
     * @return 
     */
    val z = 0

    /* hello /* nested */ */
    hello()    

    //scala doc commented out
    /*
     *
     *
    /**
     * @param hello world
     */
     *
     *
     **/

    /**
     * @param hello world
     **/
    def hello = ()

    /*
     * 
     */


    /*
     *
     * /*
     * */
    */
}

sealed class IntegerLiterals {
    private val x = 0x31f5
    final val y = 0X31f5 
    val z = 0352 // error 
    val i = 3+2
    val i = .3+2
}

object FloatingPointLiterals {
    def float = 1f
    def float = 1F
    def float = 1.1f
    def float = 1.1F
    def float = 231.1232f
    def float = 231.2321F
    def float = .2ff // error 
    def float = .2F
    def double = 1d
    def double = 1D
    def double = 1.1d
    def double = 1.1D
    def double = 231.1232d
    def double = 231.2321D
    def double = 231.2321
    def double = .2d
    def double = .2
    def double = .2D
    def exp = 1.2342e-24
    def exp = 1e+24
}

object SymbolLiterals {
    val k = '\ // SLS accepts, but scalac doesn't.
    val separated = 'fa+
    val a = '++:\++
    val b = 'fa__:
    val c = 'fa_+:
    val d = 'fa_%
    val x = 'Hello
    val y = 'H' // a character
    val z = 'Hello
    val w = 'H' // a character
    val ok = '\u0061 // optimistically a symbol
    val error = '\u0 
    val ok = 'a\u0061
    val withcomment = 'abc_/**/
    '+++/**/ // a symbol and the empty commen
    val +++/**/= 3
    '/**/ // symbol wrt scalac
    '/**/**/ // '/**
    '/**//a  // '/**
    '// // symbol wrt scalac
    '/// // '/
    '//^ // '//^
    '//**/ // '/
    '/////**/ '/

    val x = ' // error
    val x = '
}

object CharacterLiterals { 
    val aChar = '\1'
    val aChar = '\"'
    val aChar = '\\'
    val aChar = '"';
    val aChar = '\'';
    val aChar = '\n'
    val aChar = '\12'
    val aChar = '\012'
    val aChar = '\123'
    val err   = '\a'
    val aChar = '\1234' // error
    val aChar = 'a'
    val aChar = '$h' // error
    val anEscapedChar = '\\'
    val aChar = ' '// whitespace char
    val err = '\na

    val anotherEscapedChar = '\n'
    val aUnicodeChar = '\u00ab'
    val aChar = 'ab' // error
    val aChar = 'abcd' // error
    val aChar = ' // error
    val err = '
}

object StringLiterals {
    val z = " \" "
    val p = "\""
    val x = " $h " // shall not escape
    val soManyEscapes = "\\\"\u0031ahb\n\bp\r\f\t" // and a comment
    val soManyEscapes = "\\\"\u0031\n\b\r\f\t" // and a comment
  
    val thing = "'"
    val thing = "A String" // this is a trailing comment
    val thing = "A String with a \" and \\ and \' in it"
    val intString = "A string with $stuff // and a comment in it"
    val str = "$hello" // no escape
    
    val error = "
    val error = "\na

}

object MultiLineStringLiterals {
    val x = """ $h """ // shall not escape
    val soManyEscapes = """\\\"\u0031\n\b\r\f\t""" // only unicode escapes
    val something = """bar="foo""""
    val otherThings = """|This is a string
                         |that spans multiple lines.
                         |""".stripMargin 
}

object ProcessedStringLiterals {
    val err = q" unclosed

    val x = ++" $hello " // shall not escape, it is a string.

    val ok = s""" ${
        // blur
        hello()
        val i = 3
    } blur"""

    val q"This $is a $string" = something

    f"return \n this $thing" // only $thing escapes.
    q"""return \n this $thing""" // only $thing escapes.
    tq"""return this $thing"""
    tq"return this $thing"
    cq"""return this $thing"""
    _0"return this $thing"
    a$f"return this $thing"
    A_@"""return this $thing"""
    pq"return this $__+" // $__ escapes.
    p/**/"return this $thing" // shall not escape.
    p_/**/"$thing" // shall not escape, but scalac does!
    p"return this $thing" // shall escape.
    p_"a $thing" // shall escape.

    val intString = sql"select * from T where id = $id and name = ${name}"
    val intString = sql"""
        select * from T
        where id = $id and name = ${s"$name Jr"} and age > ${age + 10}
    """

    val soManyEscapes =   s"\\\"\u0031\n\b\r\f\t" // no escape, shall be broken.
    val soManyEscapes =  "\\\"\u0031\n\b\r\f\t" // all escapes.
    val soManyEscapes = """\\\"\u0031\n\b\r\f\t""" // only unicode escapes.
    val error = " a \ua "

    val intString =  "A string with $stuff // and a comment in it"
    val intString = s"A string /* a comment and */ with $stuff and ${stuff} in it"
    val intString = s"""A string /* a comment and */ with $stuff and ${stuff} in it"""
    val intFString = f"A string with $$ a $2142  $stuff and ${stuff} and ${eval this}%-2.2f and $stuff%2d in it"
    val intFString = f"""A string with $stuff and ${stuff} and ${eval this}%-2.2f and $stuff%2d in it"""
    
    val x= s"""$$ f$fea $$ $$$ f$f$ f$$f""" // shows error. 
    val y = s"""$$$$""" // two escapes.
    val x = s""" pq$big_bob++='def' """ // $big_bob escapes
    val x = s"""$big_++ """ // $big_ escapes, while $big_++ is an identifier.
    
    val something = s"""bar="foo""""
    val something = f"""bar="foo""""
}

@hello
object Annotations {
    @hello def foo = 0
    @hello("hello") val x = 0
    @__+("hello") val z = 0
    @hello.type
    def foo[x @hello](x: Int) = 0
    x @@ y
}
=
@
:
\\\\
\
