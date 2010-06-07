%module VerbQueryLanguage
%{
#include "verbql.h"
%}

class VerbQueryLanguage {
  
public:
  static char *query(char *input);
  
};