/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.0
 * 
 * This file is not intended to be easily readable and contains a number of 
 * coding conventions designed to improve portability and efficiency. Do not make
 * changes to this file unless you know what you are doing--modify the SWIG 
 * interface file instead. 
 * ----------------------------------------------------------------------------- */

#ifndef PHP_VERBQUERYLANGUAGE_H
#define PHP_VERBQUERYLANGUAGE_H

extern zend_module_entry VerbQueryLanguage_module_entry;
#define phpext_VerbQueryLanguage_ptr &VerbQueryLanguage_module_entry

#ifdef PHP_WIN32
# define PHP_VERBQUERYLANGUAGE_API __declspec(dllexport)
#else
# define PHP_VERBQUERYLANGUAGE_API
#endif

#ifdef ZTS
#include "TSRM.h"
#endif

PHP_MINIT_FUNCTION(VerbQueryLanguage);
PHP_MSHUTDOWN_FUNCTION(VerbQueryLanguage);
PHP_RINIT_FUNCTION(VerbQueryLanguage);
PHP_RSHUTDOWN_FUNCTION(VerbQueryLanguage);
PHP_MINFO_FUNCTION(VerbQueryLanguage);

ZEND_NAMED_FUNCTION(_wrap_VerbQueryLanguage_query);
ZEND_NAMED_FUNCTION(_wrap_VerbQueryLanguage_resolvePath);
ZEND_NAMED_FUNCTION(_wrap_new_VerbQueryLanguage);
#endif /* PHP_VERBQUERYLANGUAGE_H */
