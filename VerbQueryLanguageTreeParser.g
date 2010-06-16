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
  
  pANTLR3_STRING predicateResult(pANTLR3_STRING p1, pANTLR3_STRING p2, char *sym) {
    if (!strlen(p1->chars)) {
      return p1;
    } else if (!strlen(p2->chars)) {
      return p2;
    } else {
      p1->append8(p1, sym);
      p1->appendS(p1, p2);
      return p1;
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
      $isPath = ($expr.isPath > 0);
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
      $isPath = $value.isPath;
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
      if ($expr.isPath == 1) {
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
	|	^(e=ADD_TOK e1=evaledExpr e2=evaledExpr)
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
      $result = $p3.result;
      if (strlen($predicate.result->chars)) {
        $result->append8($result, "[");
        $result->appendS($result, $predicate.result);
        $result->append8($result, "]");
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
  | DOT_STEP
    {
      $result = $DOT_STEP.text;
    }
  | PERMALINK
    {
      $result = $PERMALINK.text;
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
returns [ pANTLR3_STRING result, int isBlankVariable ]
  : predicatePath
    {
      $isBlankVariable = 0;
      $result = $predicatePath.result;
    }
  | value
	  {
	    $result = $value.result;
	    if (!$value.isBlankVariable) {
	      $result->insert8($result, 0, "'");
	      $result->append8($result, "'");
      }
	  }
  | predicateOper
    {
      $result = $predicateOper.result;
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
  | predicateRangeOper
    {
      return $predicateRangeOper.result;
    }
  ;
  
predicateRangeOper
returns [ pANTLR3_STRING result ]
  : ^(COLON p1=predicateExpr p2=rangeFunction)
	  {
      $result = newStr($COLON, $p1.result->chars);
      if (strcmp($p2.lowResult->chars, "") && strcmp($p2.highResult->chars, "")) {
        $result->append8($result, ">='");
        $result->appendS($result, $p2.lowResult);
        $result->append8($result, "'][");
        $result->appendS($result, $p1.result);
        $result->append8($result, "<'");
        $result->appendS($result, $p2.highResult);
        $result->append8($result, "'");
      } else {
        $result->append8($result, "='0'");
      }
	  }
	;
	
rangeFunction
returns [ pANTLR3_STRING lowResult, pANTLR3_STRING highResult ]
	:	^(NODE_FUNCTION FUNCTION 
	    {
	      functionArgCount = 0;
        functionArgList[0] = NULL;
	    }
	    expressionList?
	  )
	  {
	    RangeFunctionRange ret = resolveRangeFunction($FUNCTION.text->subString($FUNCTION.text, 0, strlen($FUNCTION.text->chars) - 1)->chars, functionArgList);
	    $lowResult = newStr($FUNCTION, ret.low);
	    $highResult = newStr($FUNCTION, ret.high);
	  }
	;
	
predicateEqualityOper
returns [ pANTLR3_STRING result ]
  : ^(equalityOper p1=predicateExpr p2=predicateExpr)
	  {
	    $result = predicateResult($p1.result, $p2.result, "=");
	  }
	;
	
predicateInequalityOper
returns [ pANTLR3_STRING result ]
  : ^(inequalityOper p1=predicateExpr p2=predicateExpr)
	  {
	    $result = predicateResult($p1.result, $p2.result, "!=");
	  }
	;
	
predicateAndOper
returns [ pANTLR3_STRING result ]
  : ^(andOper p1=predicateExpr p2=predicateExpr)
	  {
	    $result = predicateResult($p1.result, $p2.result, " and ");
	  }
	;
	
predicateOrOper
returns [ pANTLR3_STRING result ]
  : ^(orOper p1=predicateExpr p2=predicateExpr)
	  {
	    $result = predicateResult($p1.result, $p2.result, " or ");
	  }
	;
	
predicateComparisonOper
returns [ pANTLR3_STRING result ]
  : ^(comparisonOper p1=predicateExpr p2=predicateExpr)
	  {
	    $result = predicateResult($p1.result, $p2.result, $comparisonOper.text->chars);
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
returns [ pANTLR3_STRING result, int isPath, int isBlankVariable ]
  : ^(NODE_VALUE STRING)
    {
      $isPath = 0;
      $isBlankVariable = 0;
      $result = $STRING.text->subString($STRING.text, 1, strlen($STRING.text->chars) - 1);
    }
  | ^(NODE_VALUE FLOAT)
    {
      $isPath = 0;
      $isBlankVariable = 0;
      $result = $FLOAT.text;
    }
  | ^(NODE_VALUE INT)
    {
      $isPath = 2;
      $isBlankVariable = 0;
      $result = $INT.text;
    }
	| variable
	  {
      $isPath = 0;
	    $result = $variable.result;
      $isBlankVariable = (strlen($result->chars) == 0);
	  }
	| function 
	  {
      $isPath = 0;
      $isBlankVariable = 0;
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