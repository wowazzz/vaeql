grammar VerbQueryLanguage;
options {
  language = C;
  output = AST;
}

tokens {
  NODE_ARGUMENTS ;
  NODE_FUNCTION ;
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
	ADD = '+' ;
	SUB = '-' ;
	MULT = '*' ;
	MOD = '%';
	
	PIPE = '|';
	POOPOO = '$$$$$$$$$$$$' ;
	
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
	:	expr EOF -> ^(expr)
	| sqlQuery EOF -> ^(sqlQuery)
	;
	
sqlQuery
	:	SQL pathStep -> ^(NODE_SQL pathStep)
	;
	
expr
  : notExpr
	| orExpr
	;
	
notExpr
	:	NOT expr -> ^(NOT expr) 
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
  : valueExpr (multOper^ valueExpr)*
  ;

valueExpr
	: (LPAREN expr RPAREN) -> ^(expr)
	|	(value | function | path)
	;
	
function
	: FUNCTION expressionList? RPAREN -> ^(NODE_FUNCTION FUNCTION expressionList?)
	;
	
expressionList
  : expr ( COMMA expr )* -> ^(NODE_ARGUMENTS expr+)
  ;	

path 
  : unionPath -> ^(NODE_PATH unionPath)
  | idPath -> ^(NODE_PATH idPath)
  | absolutePath -> ^(NODE_PATH absolutePath)
  ;
    
absolutePath 
  : SLASH unionPath?
  ;
  
idPath
	: INT SLASH relativePath
	;
  
relativePath 
  : pathStep ( SLASH pathStep )*
  ;
  
unionPath
  : relativePath (PIPE relativePath)*
  ;

pathStep
  : ( axisSpecifier? NAME | DOT_STEP ) predicate*
  ;

axisSpecifier
  : XPATH_AXES XPATH_AXIS_SEP
  | AT
  ;

predicate
  : LBRACKET predicateExpr RBRACKET -> ^(NODE_PREDICATE predicateExpr)
  ;

predicateExpr
  : predicateAndExpr (orOper predicateAndExpr)*
  ;
  
predicateAndExpr
  : predicateComparisonExpr (andOper predicateComparisonExpr)?
  ;

predicateComparisonExpr
  : pathExpr (comparisonOper pathExpr)?
  ;

pathExpr
  : unionPath
  | filterExpr (SLASH relativePath)?
  ;

filterExpr
  : primaryExpr predicate?
  ;

primaryExpr
  : LPAREN predicateExpr RPAREN
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
	:	VARIABLE | STRING | INT | FLOAT
	;
	
comparisonOper
	:	EQUALITY | EQUALITY_ALT | INEQUALITY | INEQUALITY_ALT | LESS | LTE | GREATER | GTE
	;
	
addSubOper
	:	ADD | SUB
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