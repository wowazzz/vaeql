#ifndef PHP_VERBQL_H
#define PHP_VERBQL_H

extern zend_module_entry VerbQueryLanguage_module_entry;
#define phpext_VerbQueryLanguage_ptr &VerbQueryLanguage_module_entry;

#define PHP_VERBQUERYLANGUAGE_API

#ifdef ZTS
#include "TSRM.h"
#endif

PHP_MINIT_FUNCTION(VerbQueryLanguage);
PHP_MSHUTDOWN_FUNCTION(VerbQueryLanguage);
PHP_RINIT_FUNCTION(VerbQueryLanguage);
PHP_RSHUTDOWN_FUNCTION(VerbQueryLanguage);
PHP_MINFO_FUNCTION(VerbQueryLanguage);

ZEND_NAMED_FUNCTION(_verbql_query_internal);

#endif
