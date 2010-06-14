tree grammar VerbQueryLanguageTreeParser;

options 
{
  tokenVocab = VerbQueryLanguage;
  language = C;
  ASTLabelType = pANTLR3_BASE_TREE;
}

@header
{
#include "verbql.h"
#define FUNCTION_ARG_LIST_SIZE 10
}

@members
{

  char *functionArgList[FUNCTION_ARG_LIST_SIZE];
  char functionArgCount;

  int asBoolean(pANTLR3_STRING a) {
    double dummy;
    if (sscanf(a->chars, "\%lf", &dummy)) return (dummy != 0);
    return strcmp(a->chars, "");
  }
  
  int asInt(pANTLR3_STRING a) {
    return atoi(a->chars);
  }
  
  double asNumber(pANTLR3_STRING a) {
    return strtod(a->chars, NULL);
  }

  int bothNumbers(pANTLR3_STRING a, pANTLR3_STRING b) {
    double dummy;
    return (sscanf(a->chars, "\%lf", &dummy) && sscanf(b->chars, "\%lf", &dummy));
  }
  
  pANTLR3_STRING booleanResponse(int t, pANTLR3_BASE_TREE e) {
    if (t) {
      return e->strFactory->newStr(e->strFactory, "1");
    } else {
      return e->strFactory->newStr(e->strFactory, "0");
    }
  }
  
  pANTLR3_STRING newStr(pANTLR3_BASE_TREE e, char *c) {
    return e->strFactory->newStr(e->strFactory, c);
  }
  
  pANTLR3_STRING numberResponse(double t, pANTLR3_BASE_TREE e) {
    char buf[30];
    sprintf(buf, "\%lg", t);
    return e->strFactory->newStr(e->strFactory, buf);
  }
}

start
returns [ pANTLR3_STRING result, int isPath ]
  : expr EOF
    {
      $isPath = $expr.isPath;
      $result = $expr.result;
    }
  ;
  
rootExpr
returns [ pANTLR3_STRING result, int isPath ]
  : oper
    {
      $isPath = $oper.isPath;
      $result = $oper.result;
    }
  | value
    {
      $isPath = 0;
      $result = $value.result;
    }
  ;
  
expr
returns [ pANTLR3_STRING result, int isPath ]
  : rootExpr
    {
      $isPath = $rootExpr.isPath;
      $result = $rootExpr.result;
    }
	| rootPath
	  {
	    $isPath = 1;
	    $result = $rootPath.result;
	  }
	;
	
evaledExpr
returns [ pANTLR3_STRING result ]
  : expr
    {
      if ($expr.isPath) {
        $result = $expr.result;
        $result->set8($result, resolvePath($expr.result->chars));
      } else {
        $result = $expr.result;
      }
    }
  ;
	
function
returns [ pANTLR3_STRING result ]
	:	^(NODE_FUNCTION FUNCTION 
	    {
	      functionArgCount = 0;
        functionArgList[0] = NULL;
	    }
	    expressionList?
	  )
	  {
	    $result = newStr($FUNCTION, resolveFunction($FUNCTION.text->subString($FUNCTION.text, 0, strlen($FUNCTION.text->chars) - 1)->chars, functionArgList));
	  }
	;
	
expressionList
  : ^(COMMA expressionList expressionList) 
  | evaledExpr
    {
      functionArgList[functionArgCount] = $evaledExpr.result->chars;
      functionArgCount++;
      functionArgList[functionArgCount] = NULL;
    }
  ;
  
oper
returns [ pANTLR3_STRING result, int isPath ]
	:	^(e=IFTRUE e1=evaledExpr ie2=expr ie3=expr)
    {
      int t = asBoolean($e1.result);
      $isPath = (t ? $ie2.isPath : $ie3.isPath);
      $result = (t ? $ie2.result : $ie3.result);
    }
	|	^((e=EQUALITY | e=EQUALITY_ALT) e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = booleanResponse((bothNumbers($e1.result, $e2.result) ? asNumber($e1.result) == asNumber($e2.result) : !strcmp($e1.result->chars, $e2.result->chars)), $e);
    }
	|	^((e=INEQUALITY | e=INEQUALITY_ALT) e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = booleanResponse((bothNumbers($e1.result, $e2.result) ? asNumber($e1.result) != asNumber($e2.result) : strcmp($e1.result->chars, $e2.result->chars)), $e);
    }
	|	^(e=LESS e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = booleanResponse((bothNumbers($e1.result, $e2.result) ? asNumber($e1.result) < asNumber($e2.result) : strcmp($e1.result->chars, $e2.result->chars) < 0), $e);
    }
	|	^(e=LTE e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = booleanResponse((bothNumbers($e1.result, $e2.result) ? asNumber($e1.result) <= asNumber($e2.result) : strcmp($e1.result->chars, $e2.result->chars) <= 0), $e);
    }
	|	^(e=GREATER e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = booleanResponse((bothNumbers($e1.result, $e2.result) ? asNumber($e1.result) > asNumber($e2.result) : strcmp($e1.result->chars, $e2.result->chars) > 0), $e);
    }
	|	^(e=GTE e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = booleanResponse((bothNumbers($e1.result, $e2.result) ? asNumber($e1.result) >= asNumber($e2.result) : strcmp($e1.result->chars, $e2.result->chars) >= 0), $e);
    }
	|	^((e=AND | e=AND_ALT) e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = booleanResponse(asBoolean($e1.result) && asBoolean($e2.result), $e);
    }
	|	^((e=OR | e=OR_ALT) e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = booleanResponse(asBoolean($e1.result) || asBoolean($e2.result), $e);
    }
	|	^((e=XOR | e=XOR_ALT) e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = booleanResponse(asBoolean($e1.result) ^ asBoolean($e2.result), $e);
    }
	|	^(e=ADD e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = numberResponse(asNumber($e1.result) + asNumber($e2.result), $e);
    }
	|	^(e=SUB e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = numberResponse(asNumber($e1.result) - asNumber($e2.result), $e);
    }
	|	^(e=MULT e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = numberResponse(asNumber($e1.result) * asNumber($e2.result), $e);
    }
	|	^(e=DIV e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = numberResponse(asNumber($e1.result) / asNumber($e2.result), $e);
    }
	|	^(e=MOD e1=evaledExpr e2=evaledExpr)
    {
      $isPath = 0;
      $result = numberResponse(asInt($e1.result) \% asInt($e2.result), $e);
    }
  | ^(e=NOT e1=evaledExpr)
    {
      $isPath = 0;
      $result = numberResponse(!asInt($e1.result), $e);
    }
	;
  
at
returns [ pANTLR3_STRING result ]
  : ^(AT p1=path)
    {
      $result = $p1.result;
      $result->insert8($result, 0, "@");
    }
  | ^(XPATH_AXIS_SEP XPATH_AXES p2=path)
    {
      $result = $XPATH_AXES.text;
      $result->appendS($result, $XPATH_AXIS_SEP.text);
      $result->appendS($result, $p2.result);
    }
  ;
  
path
returns [ pANTLR3_STRING result ]
  : slash
    {
      $result = $slash.result;
    }
  | at
    {
      $result = $at.result;
    }
  | piper
    {
      $result = $piper.result;
    }
  | ^(NODE_PREDICATE predicate p3=path)
    {
      if (strlen($predicate.result->chars)) {
        $result = $p3.result;
        $result->append8($result, "[");
        $result->appendS($result, $predicate.result);
        $result->append8($result, "]");
      } else {
        $result = newStr($NODE_PREDICATE, "");
      }
    }
  | INT
    {
      $result = $INT.text;
    }
  | NAME
    {
      $result = $NAME.text;
    }
  | variable
    {
      $result = $variable.result;
    }
  | function
    {
      $result = $function.result;
    }
  ;
  
piper  
returns [ pANTLR3_STRING result ]
  : ^(PIPE p1=path p2=path)
    {
      $result = $p1.result;
      $result->append8($result, "|");
      $result->appendS($result, $p2.result);
    }
  ;

predicate
returns [ pANTLR3_STRING result ]
  : ^(NODE_VALUE INT)
    {
      return $INT.text;
    }
  | predicateOper
    {
      return $predicateOper.result;
    }
  ;
  
predicateExpr
returns [ pANTLR3_STRING result ]
  : predicatePath
    {
      return $predicatePath.result;
    }
  | value
	  {
	    $result = $value.result;
	    if (strlen($value.result->chars)) {
	      $result->insert8($result, 0, "'");
	      $result->append8($result, "'");
	    }
	  }
  | predicateOper
    {
      return $predicateOper.result;
    }
  ;
  
predicateOper
returns [ pANTLR3_STRING result ]
  : predicateEqualityOper
    {
      return $predicateEqualityOper.result;
    }
  | predicateInequalityOper
    {
      return $predicateInequalityOper.result;
    }
  | predicateAndOper
    {
      return $predicateAndOper.result;
    }
  | predicateOrOper
    {
      return $predicateOrOper.result;
    }
  | predicateComparisonOper
    {
      return $predicateComparisonOper.result;
    }
  ;
  
predicateEqualityOper
returns [ pANTLR3_STRING result ]
  : ^(equalityOper p1=predicateExpr p2=predicateExpr)
	  {
	    $result = $p1.result;
      $result->append8($result, "=");
      $result->appendS($result, $p2.result);
	  }
	;
	
predicateInequalityOper
returns [ pANTLR3_STRING result ]
  : ^(inequalityOper p1=predicateExpr p2=predicateExpr)
	  {
	    $result = $p1.result;
      $result->append8($result, "!=");
      $result->appendS($result, $p2.result);
	  }
	;
	
predicateAndOper
returns [ pANTLR3_STRING result ]
  : ^(andOper p1=predicateExpr p2=predicateExpr)
	  {
	    $result = $p1.result;
      $result->append8($result, " and ");
      $result->appendS($result, $p2.result);
	  }
	;
	
predicateOrOper
returns [ pANTLR3_STRING result ]
  : ^(orOper p1=predicateExpr p2=predicateExpr)
	  {
	    $result = $p1.result;
      $result->append8($result, " or ");
      $result->appendS($result, $p2.result);
	  }
	;
	
predicateComparisonOper
returns [ pANTLR3_STRING result ]
  : ^(comparisonOper p1=predicateExpr p2=predicateExpr)
	  {
	    $result = $p1.result;
      $result->appendS($result, $comparisonOper.text);
      $result->appendS($result, $p2.result);
	  }
	;

predicatePath
returns [ pANTLR3_STRING result ]
  : slash
    {
      $result = $slash.result;
    }
  | NAME
    {
      $result = $NAME.text;
    }
  ;
  
slash  
returns [ pANTLR3_STRING result ]
  : ^(NODE_ABSOLUTE p3=path)
    {
      $result = $p3.result;
      $result->insert8($result, 0, "/");
    }
  | ^(SLASH p1=path p2=path)
    {
      $result = $p1.result;
      $result->append8($result, "/");
      $result->appendS($result, $p2.result);
    }
  ;
	
value
returns [ pANTLR3_STRING result ]
  : ^(NODE_VALUE STRING)
    {
      $result = $STRING.text->subString($STRING.text, 1, strlen($STRING.text->chars) - 1);
    }
  | ^(NODE_VALUE FLOAT)
    {
      $result = $FLOAT.text;
    }
  | ^(NODE_VALUE INT)
    {
      $result = $INT.text;
    }
	| variable
	  {
	    $result = $variable.result;
	  }
	| function 
	  {
	    $result = $function.result;
	  }
	;
	
variable
returns [ pANTLR3_STRING result ]
  : ^(NODE_VALUE VARIABLE)
    {
      $result = $VARIABLE.text->subString($VARIABLE.text, 1, strlen($VARIABLE.text->chars));
      $result->set8($result, resolveVariable($result->chars));
    }
  ;
    
rootPath
returns [ pANTLR3_STRING result, int isPath ]
  : ^(NODE_SQL path)
    {
      $result = newStr($NODE_SQL, "~");
      $result->appendS($result, $path.result);
      $isPath = 1;
    }
  | ^(NODE_PATH path) 
    {
      $isPath = 1;
      $result = $path.result;
    }
  ;

andOper
  : AND | AND_ALT
  ;
  
orOper
  : OR | OR_ALT
  ;
	
equalityOper
	:	EQUALITY | EQUALITY_ALT
	;
	
inequalityOper
	:	INEQUALITY | INEQUALITY_ALT
	;

comparisonOper
  : LESS | LTE | GREATER | GTE
	;