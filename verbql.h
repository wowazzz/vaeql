class VerbQueryLanguage {
  
public:
  ~VerbQueryLanguage();
  char *query(char *input);
  virtual char *resolvePath(char *input);
  
};