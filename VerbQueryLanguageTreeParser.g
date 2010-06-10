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
  
root_path
returns [ pANTLR3_STRING result ]
  : NODE_PATH
    {
      $result = $NODE_PATH.text;
    }
    SQL?
    {
      printf("got a sql\n");
    }
    PATH
    {
      $result = $PATH.text;
    }
    predicate*
    {
      printf("got a pred\n");
    }
    EOF
  ;
  
predicate
  : NODE_PREDICATE
  ;
  
expr
returns [ pANTLR3_STRING result ]
  : oper
    {
      $result = $oper.result;
    }
  | VARIABLE
    {
      $result = $VARIABLE.text;
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
	;


/* TOOO:  XOR | XOR_ALT | ADD | SUB | MULT | SLASH | MOD  */