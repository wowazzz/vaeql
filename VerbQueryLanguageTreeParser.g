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
}

@members
{
  int VerbQueryLanguagePath = 0;

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
returns [ pANTLR3_STRING result ]
  : root_path EOF
    {
      VerbQueryLanguagePath = 1;
      $result = $root_path.result;
    }
  | expr EOF
    {
      VerbQueryLanguagePath = 0;
      $result = $expr.result;
    }
  ;
  
expr
returns [ pANTLR3_STRING result ]
  : oper
    {
      $result = $oper.result;
    }
  | value
    {
      $result = $value.result;
    }
  ;
  
function
returns [ pANTLR3_STRING result ]
	:	^(FUNCTION expr (COMMA expr)*)
	  {
	    $result = $FUNCTION.text->subString($FUNCTION.text, 0, strlen($FUNCTION.text->chars) - 1);
	  }
	;
  
oper
returns [ pANTLR3_STRING result ]
	:	^((e=EQUALITY | e=EQUALITY_ALT) e1=expr e2=expr)
    {
      $result = booleanResponse((bothNumbers($e1.result, $e2.result) ? asNumber($e1.result) == asNumber($e2.result) : !strcmp($e1.result->chars, $e2.result->chars)), $e);
    }
	|	^((e=INEQUALITY | e=INEQUALITY_ALT) e1=expr e2=expr)
    {
      $result = booleanResponse((bothNumbers($e1.result, $e2.result) ? asNumber($e1.result) != asNumber($e2.result) : strcmp($e1.result->chars, $e2.result->chars)), $e);
    }
	|	^(e=LESS e1=expr e2=expr)
    {
      $result = booleanResponse((bothNumbers($e1.result, $e2.result) ? asNumber($e1.result) < asNumber($e2.result) : strcmp($e1.result->chars, $e2.result->chars) < 0), $e);
    }
	|	^(e=LTE e1=expr e2=expr)
    {
      $result = booleanResponse((bothNumbers($e1.result, $e2.result) ? asNumber($e1.result) <= asNumber($e2.result) : strcmp($e1.result->chars, $e2.result->chars) <= 0), $e);
    }
	|	^(e=GREATER e1=expr e2=expr)
    {
      $result = booleanResponse((bothNumbers($e1.result, $e2.result) ? asNumber($e1.result) > asNumber($e2.result) : strcmp($e1.result->chars, $e2.result->chars) > 0), $e);
    }
	|	^(e=GTE e1=expr e2=expr)
    {
      $result = booleanResponse((bothNumbers($e1.result, $e2.result) ? asNumber($e1.result) >= asNumber($e2.result) : strcmp($e1.result->chars, $e2.result->chars) >= 0), $e);
    }
	|	^((e=AND | e=AND_ALT) e1=expr e2=expr)
    {
      $result = booleanResponse(asBoolean($e1.result) && asBoolean($e2.result), $e);
    }
	|	^((e=OR | e=OR_ALT) e1=expr e2=expr)
    {
      $result = booleanResponse(asBoolean($e1.result) || asBoolean($e2.result), $e);
    }
	|	^((e=XOR | e=XOR_ALT) e1=expr e2=expr)
    {
      $result = booleanResponse(asBoolean($e1.result) ^ asBoolean($e2.result), $e);
    }
	|	^(e=ADD e1=expr e2=expr)
    {
      $result = numberResponse(asNumber($e1.result) + asNumber($e2.result), $e);
    }
	|	^(e=SUB e1=expr e2=expr)
    {
      $result = numberResponse(asNumber($e1.result) - asNumber($e2.result), $e);
    }
	|	^(e=MULT e1=expr e2=expr)
    {
      $result = numberResponse(asNumber($e1.result) * asNumber($e2.result), $e);
    }
	|	^(e=SLASH e1=expr e2=expr)
    {
      $result = numberResponse(asNumber($e1.result) / asNumber($e2.result), $e);
    }
	|	^(e=MOD e1=expr e2=expr)
    {
      $result = numberResponse(asInt($e1.result) \% asInt($e2.result), $e);
    }
	;
  
path
returns [ pANTLR3_STRING result ]
  : ^(SLASH p1=path p2=path)
    {
      $result = $p1.result;
      $result->append8($result, "/");
      $result->appendS($result, $p2.result);
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
  ;

predicate
returns [ pANTLR3_STRING result ]
  : INT
    {
      return $INT.text;
    }
	| v1=predicate_value_expr predicate_oper v2=predicate_value_expr
	  {
	    if (!strlen($v1.result->chars)) {
        $result = $v1.result;
	    } else if (!strlen($v2.result->chars)) {
        $result = $v2.result;
	    } else {
	      $result = $v1.result;
	      $result->appendS($result, $predicate_oper.result);
	      $result->appendS($result, $v2.result);
	    }
	  }
  ;
	
predicate_value_expr
returns [ pANTLR3_STRING result ]
	:	^(NODE_VALUE value)
	  {
	    if (!strlen($value.result->chars)) {
	      $result = $value.result;
	    } else {
	      $result = newStr($NODE_VALUE, "'");
	      $result->appendS($result, $value.result);
	      $result->append8($result, "'");
	    }
	  }
	| function 
	  {
	    $result = $function.result;
	  }
	| PATH
	  {
	    $result = $PATH.text;
	  }
	;
  
predicate_oper
returns [ pANTLR3_STRING result ]
	:	(v=EQUALITY | v=EQUALITY_ALT)
	  {
	    return newStr($v, "=");
	  }
	|	(v=INEQUALITY | v=INEQUALITY_ALT)
	  {
	    return newStr($v, "!=");
	  }
	|	(v=AND | v=AND_ALT)
	  {
	    return newStr($v, " and ");
	  }
	|	(v=OR | v=OR_ALT)
	  {
	    return newStr($v, " or ");
	  }
	|	(v=LESS | v=LTE | v=GREATER | v=GTE)
	  {
	    return $v.text;
	  }
	;
  
root_path
returns [ pANTLR3_STRING result ]
  : ^(NODE_SQL path)
    {
      $result = newStr($NODE_SQL, "~");
      $result->appendS($result, $path.result);
    }
  | ^(NODE_PATH path) 
    {
      $result = $path.result;
    }
  ;

value
returns [ pANTLR3_STRING result ]
  : VARIABLE
    {
      $result = $VARIABLE.text->subString($VARIABLE.text, 1, strlen($VARIABLE.text->chars) - 1);
      $result->set8($result, resolveVariable($result->chars));
    }
  | STRING
    {
      $result = $STRING.text->subString($STRING.text, 1, strlen($STRING.text->chars) - 1);
    }
  | FLOAT
    {
      $result = $FLOAT.text;
    }
  | INT
    {
      $result = $INT.text;
    }
	;