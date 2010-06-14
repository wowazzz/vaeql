#include "VerbQueryLanguageLexer.h"
#include "VerbQueryLanguageParser.h"
#include "VerbQueryLanguageTreeParser.h"

#include "zend.h"
#include "zend_API.h"
#include "zend_exceptions.h"
#include "php.h"
#include "ext/standard/php_string.h"

#include "verbql.h"
#include "php_verbql.h"

char *resolveFunction(char *variable, char **args) {
  return "125";
}

char *resolvePath(char *path) {
  return "124";
}

char *resolveVariable(char *variable) {
  return "123";
}

ZEND_NAMED_FUNCTION(_verbql_query) {
  
  /* PHP */
  zval **args[1];
  char *query;
  
  /* VerbQueryLanguage */
  VerbQueryLanguageParser_start_return langAST;
  pVerbQueryLanguageLexer	lxr;
  pVerbQueryLanguageParser psr;
  pVerbQueryLanguageTreeParser treePsr;
  pANTLR3_INPUT_STREAM istream;
  pANTLR3_COMMON_TOKEN_STREAM	tstream;
  pANTLR3_COMMON_TREE_NODE_STREAM	nodes;
  VerbQueryLanguageTreeParser_start_return result;
  
  /* Pull in arg from PHP */
  if(ZEND_NUM_ARGS() != 1 || zend_get_parameters_array_ex(1, args) != SUCCESS) {
    WRONG_PARAM_COUNT;
  }
  if ((*args[0])->type==IS_NULL) {
    query = (char *)0;
  } else {
    convert_to_string_ex(args[0]);
    query = (char *)Z_STRVAL_PP(args[0]);
  }

  /* Lex and Parse */
  istream = antlr3NewAsciiStringInPlaceStream((uint8_t *)query, (ANTLR3_UINT64)strlen(query), NULL);
  lxr	= VerbQueryLanguageLexerNew(istream);
  if (lxr == NULL) {
		fprintf(stderr, "Unable to create the lexer due to malloc() failure1\n");
		exit(ANTLR3_ERR_NOMEM);
  }
  tstream = antlr3CommonTokenStreamSourceNew(ANTLR3_SIZE_HINT, TOKENSOURCE(lxr));
  if (tstream == NULL) {
		fprintf(stderr, "Out of memory trying to allocate token stream\n");
		exit(ANTLR3_ERR_NOMEM);
  }
  psr	= VerbQueryLanguageParserNew(tstream);
  if (psr == NULL) {
		fprintf(stderr, "Out of memory trying to allocate parser\n");
		exit(ANTLR3_ERR_NOMEM);
  }
  langAST = psr->start(psr);
	if (psr->pParser->rec->state->errorCount == 0) {
		nodes	= antlr3CommonTreeNodeStreamNewTree(langAST.tree, ANTLR3_SIZE_HINT);
		//printf("Nodes: %s\n", langAST.tree->toStringTree(langAST.tree)->chars);
    treePsr	= VerbQueryLanguageTreeParserNew(nodes);
	  result = treePsr->start(treePsr);
	  if (result.isPath) {
      //printf("Path: %s\n", result.result->chars);
    } else {
      //printf("Result: %s\n", result.result->chars);
    }
    ZVAL_STRING(return_value, result.result->chars, 1);
	  treePsr->free(treePsr);
	  nodes->free(nodes);
	} else {
    zend_throw_exception(zend_exception_get_default(), "Unable to Parse VerbQL Query.", 0);  
  }
	tstream->free(tstream);
	psr->free(psr);
	lxr->free(lxr);
	istream->close(istream);
  return;
}

/* PHP Function Table */
static zend_function_entry VerbQueryLanguage_functions[] = {
  ZEND_NAMED_FE(_verbql_query, _verbql_query, NULL)
  {NULL, NULL, NULL}
};

/* PHP Boilerplate */
zend_module_entry VerbQueryLanguage_module_entry = {
#if ZEND_MODULE_API_NO > 20010900
    STANDARD_MODULE_HEADER,
#endif
    (char *)"VerbQueryLanguage",
    VerbQueryLanguage_functions,
    PHP_MINIT(VerbQueryLanguage),
    PHP_MSHUTDOWN(VerbQueryLanguage),
    PHP_RINIT(VerbQueryLanguage),
    PHP_RSHUTDOWN(VerbQueryLanguage),
    PHP_MINFO(VerbQueryLanguage),
#if ZEND_MODULE_API_NO > 20010900
    NO_VERSION_YET,
#endif
    STANDARD_MODULE_PROPERTIES
};

PHP_MINIT_FUNCTION(VerbQueryLanguage) {
  return SUCCESS;
}

PHP_RINIT_FUNCTION(VerbQueryLanguage) {
  return SUCCESS;
}

PHP_MSHUTDOWN_FUNCTION(VerbQueryLanguage) {
  return SUCCESS;
}

PHP_RSHUTDOWN_FUNCTION(VerbQueryLanguage) {
  return SUCCESS;
}

PHP_MINFO_FUNCTION(VerbQueryLanguage) {
}

ZEND_GET_MODULE(VerbQueryLanguage)