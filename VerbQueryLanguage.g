grammar VerbQueryLanguage;

options {
    language=C;
    output=AST;
}

tokens {
	NODE_STRING;
	NODE_VARIABLE;
	NODE_OPERATOR;
	NODE_FUNCTION;
	NODE_PREDICATE;
	NODE_PATH;

	SLASH = '/' ;
	SQL = '~' ;
	AT = '@';
	
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
	ADD = '+' ;
	SUB = '-' ;
	MULT = '*' ;
	MOD = '%';
	
	IFTRUE = '?' ;
	IFFALSE = ':' ;
	
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
	:	(expr | sqlquery) EOF 
	;

sqlquery
	:	SQL PATH -> ^(SQL PATH)
	;

expr
	:	NOT expr -> ^(NOT expr) 
	| value_expr (oper^ value_expr)*
	;

value_expr
	: (LPAREN expr RPAREN) -> ^(expr)
	|	(value | function | path)
	;

value
	:	VARIABLE -> ^(NODE_VARIABLE VARIABLE)
	|	STRING -> ^(NODE_STRING STRING)
	| INT | FLOAT
	;

function
	:	FUNCTION expr? (COMMA expr)* RPAREN -> ^(NODE_FUNCTION FUNCTION expr (COMMA expr)*)
	;
	
path
	:	(v=PATH | v=AXIS) predicate* -> ^(NODE_PATH $v predicate*)
	| AT path -> ^(AT path)
	;

predicate
	:	LBRACKET expr RBRACKET -> ^(NODE_PREDICATE expr)
	;
	
oper
	:	EQUALITY | EQUALITY_ALT | INEQUALITY | INEQUALITY_ALT | LESS | LTE | GREATER | GTE | AND | AND_ALT | OR | OR_ALT | XOR | XOR_ALT | ADD | SUB | MULT | SLASH | MOD 
	;

	
/*------------------------------------------------------------------
 * LEXER RULES
 *------------------------------------------------------------------*/

STRING
  :  ('"' (~('\\'|'"') | ESC_SEQ)* '"')
  |  ('\'' (~('\\'|'\'') | ESC_SEQ)* '\'')
  ;
    
VARIABLE
	:	'$' ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
  ;

FUNCTION
	:	('a'..'z'|'A'..'Z'|'0'..'9')+ '('
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

AXIS 
	:	('a'..'z') ('a'..'z'|'0'..'9'|'_'|'-'|'/')* '::' ('a'..'z'|'0'..'9'|'_'|'/')*
  ;
    
PATH 
  :	 ('..' ('/..')*)
	|	('/' PATH_END)
	|	(('../')+ PATH_END)
	|	(PATH_END)
  ;
    
FLOAT
  : ('0'..'9')+ '.' ('0'..'9')*
  | '.' ('0'..'9')+
  ;

INT 
  :	'0'..'9'+
  ;

WS
  : (' '|'\t'|'\r'|'\n') { $channel=HIDDEN; }
  ;

fragment
ESC_SEQ
  :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
  ;

fragment
PATH_END
  : ('a'..'z') ('a'..'z'|'0'..'9'|'_'|'/../'|('/' 'a'..'z'))* ('/..')?
  ;
  