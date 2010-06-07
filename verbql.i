%module(directors="1") VerbQueryLanguage
%{
#include "verbql.h"
%}

%feature("director") VerbQueryLanguage;
class VerbQueryLanguage {
  
public:
  virtual ~VerbQueryLanguage();
  char *query(char *input);
  virtual char *resolvePath(char *path);
  
};