grammar VerbQueryLanguage;
options {
  language = C;
  output = AST;
}

tokens {
  NODE_ABSOLUTE ;
  NODE_FUNCTION ;
  NODE_IF ;
  NODE_PARENEXPR ;
	NODE_PATH ;
	NODE_PREDICATE ;
	NODE_SQL ;
	NODE_VALUE ;

	DIV = '//' ;
	SLASH = '/' ;
	SQL = '~' ;
	AT = '@' ;
	
	XPATH_AXIS_SEP = '::' ;
	EQUALITY = '==' ;
	EQUALITY_ALT = '=' ;
	INEQUALITY = '!=' ;
	INEQUALITY_ALT = '<>' ;
	LESS = '<' ;
	LTE = '<=' ;
	GREATER = '>' ;
	GTE = '>=' ;
	AND = '&&' ;
	OR = '||' ;
	XOR = '^' ;
	NOT = '!' ;
	ADD_TOK = '+' ;
	SUB = '-' ;
	MULT = '*' ;
	MOD = '%';
	
	PIPE = '|';
	POOPOO = '$$$$$$$$$$$$' ;
	
	IFTRUE = '?' ;
	COLON = ':' ;
	
	LBRACKET = '[' ;
	RBRACKET = ']' ;
	LPAREN = '(' ;
	RPAREN = ')' ;
	COMMA = ',' ;
}

/*------------------------------------------------------------------
 * PARSER RULES
 *------------------------------------------------------------------*/
 
start
	:	expr EOF -> ^(expr)
	;
	
expr
  : orExpr
	;
	
orExpr
  : xorExpr (orOper^ xorExpr)*
  ;
  	
xorExpr
  : andExpr (xorOper^ andExpr)*
  ;
  
andExpr
  : comparisonExpr (andOper^ comparisonExpr)*
  ;

comparisonExpr
  : addSubExpr (comparisonOper^ addSubExpr)*
  ;

addSubExpr
  : multExpr (addSubOper^ multExpr)*
  ;

multExpr
  : ifExpr (multOper^ ifExpr)*
  ;

ifExpr
	: e1=notExpr (IFTRUE^ notExpr COLON! notExpr)?
	;
	
notExpr
	: NOT valueExpr -> ^(NOT valueExpr) 
	| valueExpr
	;

valueExpr
	: (LPAREN expr RPAREN) -> ^(expr)
	|	(path | value | function)
	;
	
function
	: FUNCTION expressionList RPAREN -> ^(NODE_FUNCTION FUNCTION expressionList)
	;
	
expressionList
  : expr? ( COMMA^ expr )*
  ;
	
functionNoArgs
  : FUNCTION RPAREN -> ^(NODE_FUNCTION FUNCTION)
  ;

path 
  : unionPath -> ^(NODE_PATH unionPath)
  | idPath -> ^(NODE_PATH idPath)
  | absolutePath -> ^(NODE_PATH absolutePath)
  | PERMALINK -> ^(NODE_PATH PERMALINK)
	|	SQL pathStep -> ^(NODE_SQL pathStep)
  ;
    
absolutePath 
  : AT SLASH unionPath? -> ^(AT ^(NODE_ABSOLUTE unionPath))
  | SLASH unionPath? -> ^(NODE_ABSOLUTE unionPath)
  ;
	
idPath
	: AT^? (INT | variable | functionNoArgs) SLASH^ relativePath
	| AT^ (INT | variable | functionNoArgs)
	;
  
relativePath 
  : pathStep (SLASH^ pathStepInternal)*
  ;
  
relativePathWithoutPredicates
  : (NAME | DOT_STEP) (SLASH^ (NAME | DOT_STEP))*
  ;
  
unionPath
  : relativePath (PIPE^ relativePath)*
  ;

pathStep
  : ( axisSpecifier^? NAME | DOT_STEP ) predicate^*
  ;

pathStepInternal
  : INT
  | variable
  | function
  | pathStep
  ;

axisSpecifier
  : XPATH_AXES XPATH_AXIS_SEP^
  | AT^
  ;

predicate
  : LBRACKET predicateExpr RBRACKET -> ^(NODE_PREDICATE predicateExpr)
  ;

predicateExpr
  : predicateAndExpr (orOper^ predicateAndExpr)*
  | relativePathWithoutPredicates COLON^ function
  ;
  
predicateAndExpr
  : predicateComparisonExpr (andOper^ predicateComparisonExpr)?
  ;

predicateComparisonExpr
  : predicatePathExpr (comparisonOper^ predicatePathExpr)?
  ;

predicatePathExpr
  : unionPath
  | filterExpr (SLASH^ relativePath)?
  ;

filterExpr
  : primaryExpr predicate?
  ;

primaryExpr
  : LPAREN predicateExpr RPAREN -> ^(NODE_PARENEXPR predicateExpr)
  | value 
  | function
  ;
  
andOper
  : AND | AND_ALT
  ;
  
orOper
  : OR | OR_ALT
  ;
  
xorOper
  : XOR | XOR_ALT
  ;

value
	:	variable
	| STRING -> ^(NODE_VALUE STRING)
	| INT -> ^(NODE_VALUE INT)
	| FLOAT -> ^(NODE_VALUE FLOAT)
	;
	
variable
  : VARIABLE -> ^(NODE_VALUE VARIABLE)
  ;
	
comparisonOper
	:	EQUALITY | EQUALITY_ALT | INEQUALITY | INEQUALITY_ALT | LESS | LTE | GREATER | GTE
	;
	
addSubOper
	:	ADD_TOK | SUB
	;
	
multOper
  : MULT | DIV | MOD 
	;
	
/*------------------------------------------------------------------
 * LEXER RULES
 *------------------------------------------------------------------*/

STRING
  :  ('"' (~('\\'|'"') | ESC_SEQ)* '"')
  |  ('\'' (~('\\'|'\'') | ESC_SEQ)* '\'')
  ;
  
PERMALINK
  : 'permalink/' ('a'..'z'|'0'..'9'|'-'|'/')*
  ;
  
FLOAT
  : ('0'..'9')+ '.' ('0'..'9')*
  | '.' ('0'..'9')+
  ;
  
INT 
  :	'0'..'9'+
  ;
  
VARIABLE
	:	'$' ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
  ;

FUNCTION
	:	('a'..'z'|'A'..'Z'|'0'..'9'|'_')+ '('
  ;
  
AND_ALT
	:	('A'|'a') ('N'|'n') ('D'|'d')
	;
	
OR_ALT
	:	('O'|'o') ('R'|'r')
	;
  
XOR_ALT
	:	('X'|'x') ('O'|'o') ('R'|'r')
	;

XPATH_AXES
  : 'ancestor'  | 'ancestor-or-self'  | 'attribute' |
    'child'     | 'descendant'        | 'descendant-or-self' |
    'following' | 'following-sibling' | 'namespace' |
    'parent'    | 'preceding'         | 'preceding-sibling' |
    'self'
  ;
  
NAME
  : ('a'..'z'|'_') ('a'..'z'|'0'..'9'|'_')*
  ;
  
DOT_STEP 
  : '.' | '..'
  ;

WS
  : (' '|'\t'|'\r'|'\n') { $channel=HIDDEN; }
  ;
  
fragment
ESC_SEQ
  : '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
  ;