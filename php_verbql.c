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

char *resolveFunction(char *function, char **args) {
  zval func, retval, function_param, arguments_param, *params[2];
  char *result, **arg;
  INIT_ZVAL(function_param);
  params[0] = &function_param;
  params[1] = &arguments_param;
  ZVAL_STRING(params[0], function, 0);
  ZVAL_STRING(&func, "_verbql_function", 0);
  array_init(&arguments_param);
  for (arg = args; *arg; arg++) {
    add_next_index_string(&arguments_param, *arg, 1);
  } 
  if (call_user_function(EG(function_table), NULL, &func, &retval, 2, params TSRMLS_CC) == FAILURE) {
    return "";
  }
  convert_to_string(&retval);
  result = (char *)Z_STRVAL_P(&retval);
  return result;
}

char *resolvePath(char *path) {
  zval func, retval, param, *params[1];
  char *result;
  INIT_ZVAL(param);
  params[0] = &param;
  ZVAL_STRING(params[0], path, 0);
  ZVAL_STRING(&func, "_verbql_path", 0);
  if (call_user_function(EG(function_table), NULL, &func, &retval, 1, params TSRMLS_CC) == FAILURE) {
    return "";
  }
  convert_to_string(&retval);
  result = (char *)Z_STRVAL_P(&retval);
  return result;
}

char *resolveVariable(char *variable) {
  zval func, retval, param, *params[1];
  char *result;
  INIT_ZVAL(param);
  params[0] = &param;
  ZVAL_STRING(params[0], variable, 0);
  ZVAL_STRING(&func, "_verbql_variable", 0);
  if (call_user_function(EG(function_table), NULL, &func, &retval, 1, params TSRMLS_CC) == FAILURE) {
    return "";
  }
  convert_to_string(&retval);
  result = (char *)Z_STRVAL_P(&retval);
  return result;
}

ZEND_NAMED_FUNCTION(_verbql_query_internal) {
  
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
		RETURN_NULL();
    return;
  }
  tstream = antlr3CommonTokenStreamSourceNew(ANTLR3_SIZE_HINT, TOKENSOURCE(lxr));
  if (tstream == NULL) {
		RETURN_NULL();
    return;
  }
  psr	= VerbQueryLanguageParserNew(tstream);
  if (psr == NULL) {
		RETURN_NULL();
    return;
  }
  langAST = psr->start(psr);
	if (psr->pParser->rec->state->errorCount == 0) {
		nodes	= antlr3CommonTreeNodeStreamNewTree(langAST.tree, ANTLR3_SIZE_HINT);
		//printf("Nodes: %s\n", langAST.tree->toStringTree(langAST.tree)->chars);
    treePsr	= VerbQueryLanguageTreeParserNew(nodes);
	  result = treePsr->start(treePsr);
    array_init(return_value);
    add_next_index_bool(return_value, result.isPath);
    add_next_index_string(return_value, result.result->chars, 1); 
	  treePsr->free(treePsr);
	  nodes->free(nodes);
	} else {
    RETURN_NULL();
  }
	tstream->free(tstream);
	psr->free(psr);
	lxr->free(lxr);
	istream->close(istream);
}

/* PHP Function Table */
static zend_function_entry VerbQueryLanguage_functions[] = {
  ZEND_NAMED_FE(_verbql_query_internal, _verbql_query_internal, NULL)
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
