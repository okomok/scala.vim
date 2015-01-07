
/**
 * @define COLL a
 * @throws My.T hello $COLL
 * @usecase def hello(): a $COLL a$COLL
 * @usecase def hello(val k = "$COLL what"): Int 
 * {{{
 *     $HELLO
 * }}}
 **/
def hello = ()

/**
 * `hell*/
def ok()


// FIXME
/**
 * {{{
 *     " */ "
 * }}}
 */
def hello = ()


val *// comment
  = 3
val */* = x */ = 3 

// FIXME
/**
 * {{{
 *     " /* "
 * }}}
 */
def hello = ()
}}} */

def hello = 3 * 2

// TODO FIXME XXX
/* TODO FIXME XXX */

/**
 * {{{
 *       // FIXME TODO XXX
 *       /* FIXME XXX TODO */
 * }}}
 **/

/*
 * /*i*/
*/
nested

/**
 * /*i */
*/
nested

    /**
     * @param i hello /* nested */
     *i/**
     *   @param i hello // not a scaladoc
     *   hello
     *   /** */ not a scaladoc
     *  */
     * 
     **/
    hello

/** ==hello==
 * ===hello `world` {{{ throw new () }}} ===
 **
 *  - one
 *  - two
 *A
 *  1. one `hello` 1. hello
 *  2. two 
 *      A. a {{{ val i = 3 }}}
 *      B. b
 *px
 * - should be a list 
 * - should be a list
 * 
 */
def hello = ()

/** Start the comment here
  * and use the left star followed by a white space on every line.
  *
  * Even on empty paragraph-break lines.
  *
  * Note that the * on each line is aligned with the second * in /** so that the  */
  * left margin is on the same column * on the first line and on subsequent ones.
  *
  * The closing scaladoc tag goes on its own, separate line.
  */
def document: Nothing

// shall be nested comment
/**
 * `
 * ` __color__
 * ` __color__/**` // ` is colored...compromise...
 */
def hello
*/


def hello()

// compromise...
/**
 * {{{
 *   """ /* nested comment. never be a string. 
 *     hello """
 * }}}
*/
def hello
eeae """ }}}
*/

// compromise..
/**
 * {{{
 *   /*
 * }}}
 */
def hello() }}}
*/

/**
 * ii  * @param i // not a scaladoc
 */

/** This is a paragraph
  *
  * This is another paragraph (note the empty line above) containing '''bold''',
  * ''italic'', `monospace`,
  * __underline__, ^superscript^, and ,,subscript,, words.
  *
  * {{{
  * 
  * /**
  *  * @param i hello // scaladoc! who needs. 
  *  * {{{
  *  *     s"hello $x"
  *  * }}}
  *  */
  * object Hello {
  *   /**
  *     * @param i hello // scaladoc! who needs
  *     */
  *     val x = foo(): Int // hello
  *     val c = 'a'
  *     """hello
  *
  *        world """
  *    /* */
  *    /** */
  *
  *     val c = 'b'
  *     s"""hello
  *         world $yeh"""
  *     s"hello $yeh"
  *     +++"hello $yeh" // just a string
  *     +++"""hello // I'm just a string
              world $yeh"""
  *     val k = foo(): Double
  * }
  * }}}
  *
  * * @param i wrongly scaladoc...
  *
  *
  * In the near future, wiki syntax will also support bullet or number lists as
  * well as links to the www and to other pages inside the documentation.
  *
  * Code here: {{{val x: Int = 3 }}} heyhey {{{ hello(): Int }}}
  * Code here: {{{ 
  * val x: Int = 3 * 3}}}
  */
def hello() = x * 3

/** @param i hello
 */

   /** @param i hello
    */

/** Class representing a thing.  This will appear in the class
  * documentation.
  *
  * Some further documentation that will appear in the class docs.
  *
  * @constructor Create a new Thing instance from a Wotsit.  This
  * will appear in the primary __constructor__ documentation.
  *
  * @param wotsit Wotsit to be converted into a Thing.  This tag
  * appears in the primary constructor docs.
  */

class Thing (wotsit: Wotsit) {
  // ...
}


package scaladoc.example

/**
 * The A class
 * @define THIS A
 * @define PARENT no other class
 * @define RESULT 3
 */
class A {
 /** 
  * The function f defined in $THIS returns some integer without no special property. (previously defined in $PARENT)
  * @param i An ignored parameter.
  * @return The value $RESULT.
  * @tparams
  */
 def f(i: Int) = 3
}

/** /*hell*/
 * nested comment supported 
 */ 

/**
 * The B class, that extends A
 * @define THIS B
 * @define PARENT A
 * @define RESULT `i + 3`
 * @param i $THIS
 */
class B extends A {

/**
 * The next comment shows the three ways of inheritance:
 * - we use "@inheritdoc" to explicitly inherit the main comment of A and add our specific explanation later
 * - we override the "@param i" with a new explanation and use @inheritdoc to also inherit the previous explanation
 * - we leave the "@return" statement alone, it will be inherited anyway
 *
 * As you can see, variables are orthogonal to the problem: they are always updated
 */

 /**
  * @inheritdoc
  * Some notes on implementation performance, the function runs in O(1).
  * @param i An important parameter
  */
 override def f(i: Int) = i + 3
}


/**/ // the empty comment
hello

