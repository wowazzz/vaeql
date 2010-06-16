/** \file
 *  This C header file was generated by $ANTLR version 3.2 Sep 23, 2009 12:02:23
 *
 *     -  From the grammar source file : VerbQueryLanguageTreeParser.g
 *     -                            On : 2010-06-15 17:37:04
 *     -           for the tree parser : VerbQueryLanguageTreeParserTreeParser *
 * Editing it, at least manually, is not wise. 
 *
 * C language generator and runtime by Jim Idle, jimi|hereisanat|idle|dotgoeshere|ws.
 *
 *
 * The tree parser VerbQueryLanguageTreeParser has the callable functions (rules) shown below,
 * which will invoke the code for the associated rule in the source grammar
 * assuming that the input stream is pointing to a token/text stream that could begin
 * this rule.
 * 
 * For instance if you call the first (topmost) rule in a parser grammar, you will
 * get the results of a full parse, but calling a rule half way through the grammar will
 * allow you to pass part of a full token stream to the parser, such as for syntax checking
 * in editors and so on.
 *
 * The parser entry points are called indirectly (by function pointer to function) via
 * a parser context typedef pVerbQueryLanguageTreeParser, which is returned from a call to VerbQueryLanguageTreeParserNew().
 *
 * The methods in pVerbQueryLanguageTreeParser are  as follows:
 *
 *  - VerbQueryLanguageTreeParser_start_return      pVerbQueryLanguageTreeParser->start(pVerbQueryLanguageTreeParser)
 *  - VerbQueryLanguageTreeParser_rootExpr_return      pVerbQueryLanguageTreeParser->rootExpr(pVerbQueryLanguageTreeParser)
 *  - VerbQueryLanguageTreeParser_expr_return      pVerbQueryLanguageTreeParser->expr(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->evaledExpr(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->function(pVerbQueryLanguageTreeParser)
 *  - void      pVerbQueryLanguageTreeParser->expressionList(pVerbQueryLanguageTreeParser)
 *  - VerbQueryLanguageTreeParser_oper_return      pVerbQueryLanguageTreeParser->oper(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->at(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->path(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->piper(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->predicate(pVerbQueryLanguageTreeParser)
 *  - VerbQueryLanguageTreeParser_predicateExpr_return      pVerbQueryLanguageTreeParser->predicateExpr(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->predicateOper(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->predicateRangeOper(pVerbQueryLanguageTreeParser)
 *  - VerbQueryLanguageTreeParser_rangeFunction_return      pVerbQueryLanguageTreeParser->rangeFunction(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->predicateEqualityOper(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->predicateInequalityOper(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->predicateAndOper(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->predicateOrOper(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->predicateComparisonOper(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->predicatePath(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->slash(pVerbQueryLanguageTreeParser)
 *  - VerbQueryLanguageTreeParser_value_return      pVerbQueryLanguageTreeParser->value(pVerbQueryLanguageTreeParser)
 *  - pANTLR3_STRING      pVerbQueryLanguageTreeParser->variable(pVerbQueryLanguageTreeParser)
 *  - VerbQueryLanguageTreeParser_rootPath_return      pVerbQueryLanguageTreeParser->rootPath(pVerbQueryLanguageTreeParser)
 *  - void      pVerbQueryLanguageTreeParser->andOper(pVerbQueryLanguageTreeParser)
 *  - void      pVerbQueryLanguageTreeParser->orOper(pVerbQueryLanguageTreeParser)
 *  - void      pVerbQueryLanguageTreeParser->equalityOper(pVerbQueryLanguageTreeParser)
 *  - void      pVerbQueryLanguageTreeParser->inequalityOper(pVerbQueryLanguageTreeParser)
 *  - VerbQueryLanguageTreeParser_comparisonOper_return      pVerbQueryLanguageTreeParser->comparisonOper(pVerbQueryLanguageTreeParser)
 *
 * The return type for any particular rule is of course determined by the source
 * grammar file.
 */
// [The "BSD licence"]
// Copyright (c) 2005-2009 Jim Idle, Temporal Wave LLC
// http://www.temporal-wave.com
// http://www.linkedin.com/in/jimidle
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. The name of the author may not be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef	_VerbQueryLanguageTreeParser_H
#define _VerbQueryLanguageTreeParser_H
/* =============================================================================
 * Standard antlr3 C runtime definitions
 */
#include    <antlr3.h>

/* End of standard antlr 3 runtime definitions
 * =============================================================================
 */
 
#ifdef __cplusplus
extern "C" {
#endif

// Forward declare the context typedef so that we can use it before it is
// properly defined. Delegators and delegates (from import statements) are
// interdependent and their context structures contain pointers to each other
// C only allows such things to be declared if you pre-declare the typedef.
//
typedef struct VerbQueryLanguageTreeParser_Ctx_struct VerbQueryLanguageTreeParser, * pVerbQueryLanguageTreeParser;



#include "verbql.h"
#define FUNCTION_ARG_LIST_SIZE 10


#ifdef	ANTLR3_WINDOWS
// Disable: Unreferenced parameter,							- Rules with parameters that are not used
//          constant conditional,							- ANTLR realizes that a prediction is always true (synpred usually)
//          initialized but unused variable					- tree rewrite variables declared but not needed
//          Unreferenced local variable						- lexer rule declares but does not always use _type
//          potentially unitialized variable used			- retval always returned from a rule 
//			unreferenced local function has been removed	- susually getTokenNames or freeScope, they can go without warnigns
//
// These are only really displayed at warning level /W4 but that is the code ideal I am aiming at
// and the codegen must generate some of these warnings by necessity, apart from 4100, which is
// usually generated when a parser rule is given a parameter that it does not use. Mostly though
// this is a matter of orthogonality hence I disable that one.
//
#pragma warning( disable : 4100 )
#pragma warning( disable : 4101 )
#pragma warning( disable : 4127 )
#pragma warning( disable : 4189 )
#pragma warning( disable : 4505 )
#pragma warning( disable : 4701 )
#endif
typedef struct VerbQueryLanguageTreeParser_start_return_struct
{
    pANTLR3_BASE_TREE       start;
    pANTLR3_BASE_TREE       stop;   
    pANTLR3_STRING result;
    int isPath;
}
    VerbQueryLanguageTreeParser_start_return;

typedef struct VerbQueryLanguageTreeParser_rootExpr_return_struct
{
    pANTLR3_BASE_TREE       start;
    pANTLR3_BASE_TREE       stop;   
    pANTLR3_STRING result;
    int isPath;
}
    VerbQueryLanguageTreeParser_rootExpr_return;

typedef struct VerbQueryLanguageTreeParser_expr_return_struct
{
    pANTLR3_BASE_TREE       start;
    pANTLR3_BASE_TREE       stop;   
    pANTLR3_STRING result;
    int isPath;
}
    VerbQueryLanguageTreeParser_expr_return;

typedef struct VerbQueryLanguageTreeParser_oper_return_struct
{
    pANTLR3_BASE_TREE       start;
    pANTLR3_BASE_TREE       stop;   
    pANTLR3_STRING result;
    int isPath;
}
    VerbQueryLanguageTreeParser_oper_return;

typedef struct VerbQueryLanguageTreeParser_predicateExpr_return_struct
{
    pANTLR3_BASE_TREE       start;
    pANTLR3_BASE_TREE       stop;   
    pANTLR3_STRING result;
    int isBlankVariable;
}
    VerbQueryLanguageTreeParser_predicateExpr_return;

typedef struct VerbQueryLanguageTreeParser_rangeFunction_return_struct
{
    pANTLR3_BASE_TREE       start;
    pANTLR3_BASE_TREE       stop;   
    pANTLR3_STRING lowResult;
    pANTLR3_STRING highResult;
}
    VerbQueryLanguageTreeParser_rangeFunction_return;

typedef struct VerbQueryLanguageTreeParser_value_return_struct
{
    pANTLR3_BASE_TREE       start;
    pANTLR3_BASE_TREE       stop;   
    pANTLR3_STRING result;
    int isPath;
    int isBlankVariable;
}
    VerbQueryLanguageTreeParser_value_return;

typedef struct VerbQueryLanguageTreeParser_rootPath_return_struct
{
    pANTLR3_BASE_TREE       start;
    pANTLR3_BASE_TREE       stop;   
    pANTLR3_STRING result;
    int isPath;
}
    VerbQueryLanguageTreeParser_rootPath_return;

typedef struct VerbQueryLanguageTreeParser_comparisonOper_return_struct
{
    pANTLR3_BASE_TREE       start;
    pANTLR3_BASE_TREE       stop;   
}
    VerbQueryLanguageTreeParser_comparisonOper_return;



/** Context tracking structure for VerbQueryLanguageTreeParser
 */
struct VerbQueryLanguageTreeParser_Ctx_struct
{
    /** Built in ANTLR3 context tracker contains all the generic elements
     *  required for context tracking.
     */
    pANTLR3_TREE_PARSER	    pTreeParser;


     VerbQueryLanguageTreeParser_start_return (*start)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     VerbQueryLanguageTreeParser_rootExpr_return (*rootExpr)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     VerbQueryLanguageTreeParser_expr_return (*expr)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*evaledExpr)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*function)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     void (*expressionList)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     VerbQueryLanguageTreeParser_oper_return (*oper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*at)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*path)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*piper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*predicate)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     VerbQueryLanguageTreeParser_predicateExpr_return (*predicateExpr)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*predicateOper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*predicateRangeOper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     VerbQueryLanguageTreeParser_rangeFunction_return (*rangeFunction)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*predicateEqualityOper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*predicateInequalityOper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*predicateAndOper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*predicateOrOper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*predicateComparisonOper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*predicatePath)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*slash)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     VerbQueryLanguageTreeParser_value_return (*value)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     pANTLR3_STRING (*variable)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     VerbQueryLanguageTreeParser_rootPath_return (*rootPath)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     void (*andOper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     void (*orOper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     void (*equalityOper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     void (*inequalityOper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
     VerbQueryLanguageTreeParser_comparisonOper_return (*comparisonOper)	(struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
    // Delegated rules
    const char * (*getGrammarFileName)();
    void	    (*free)   (struct VerbQueryLanguageTreeParser_Ctx_struct * ctx);
        
};

// Function protoypes for the constructor functions that external translation units
// such as delegators and delegates may wish to call.
//
ANTLR3_API pVerbQueryLanguageTreeParser VerbQueryLanguageTreeParserNew         (pANTLR3_COMMON_TREE_NODE_STREAM instream);
ANTLR3_API pVerbQueryLanguageTreeParser VerbQueryLanguageTreeParserNewSSD      (pANTLR3_COMMON_TREE_NODE_STREAM instream, pANTLR3_RECOGNIZER_SHARED_STATE state);

/** Symbolic definitions of all the tokens that the tree parser will work with.
 * \{
 *
 * Antlr will define EOF, but we can't use that as it it is too common in
 * in C header files and that would be confusing. There is no way to filter this out at the moment
 * so we just undef it here for now. That isn't the value we get back from C recognizers
 * anyway. We are looking for ANTLR3_TOKEN_EOF.
 */
#ifdef	EOF
#undef	EOF
#endif
#ifdef	Tokens
#undef	Tokens
#endif 
#define AND_ALT      48
#define FUNCTION      42
#define EQUALITY      17
#define MOD      32
#define NODE_FUNCTION      5
#define GTE      24
#define SUB      30
#define FLOAT      52
#define NOT      28
#define AND      25
#define EOF      -1
#define LTE      22
#define LPAREN      39
#define INEQUALITY_ALT      20
#define DOT_STEP      46
#define EQUALITY_ALT      18
#define AT      15
#define LBRACKET      37
#define NODE_ABSOLUTE      4
#define SQL      14
#define RPAREN      40
#define NAME      45
#define ESC_SEQ      54
#define SLASH      13
#define GREATER      23
#define COMMA      41
#define NODE_VALUE      11
#define XPATH_AXIS_SEP      16
#define LESS      21
#define OR_ALT      49
#define PIPE      33
#define XOR_ALT      50
#define XPATH_AXES      47
#define RBRACKET      38
#define XOR      27
#define NODE_PATH      8
#define NODE_PREDICATE      9
#define ADD_TOK      29
#define POOPOO      34
#define IFTRUE      35
#define NODE_PARENEXPR      7
#define PERMALINK      43
#define INEQUALITY      19
#define INT      44
#define MULT      31
#define NODE_IF      6
#define COLON      36
#define WS      55
#define VARIABLE      53
#define OR      26
#define DIV      12
#define NODE_SQL      10
#define STRING      51
#ifdef	EOF
#undef	EOF
#define	EOF	ANTLR3_TOKEN_EOF
#endif

#ifndef TOKENSOURCE
#define TOKENSOURCE(lxr) lxr->pLexer->rec->state->tokSource
#endif

/* End of token definitions for VerbQueryLanguageTreeParser
 * =============================================================================
 */
/** \} */

#ifdef __cplusplus
}
#endif

#endif

/* END - Note:Keep extra line feed to satisfy UNIX systems */
