class VerbQueryLanguage {
  
public:
  VerbQueryLanguage();
  ~VerbQueryLanguage();
  char *query(char *input);
  virtual char *resolvePath(char *input);
  
  pVerbQueryLanguageLexer	lxr;
  pVerbQueryLanguageParser psr;
  pVerbQueryLanguageTreeParser treePsr;
  VerbQueryLanguageParser_start_return langAST;
  pANTLR3_INPUT_STREAM istream;
  pANTLR3_COMMON_TOKEN_STREAM	tstream;
  pANTLR3_COMMON_TREE_NODE_STREAM	nodes;
};