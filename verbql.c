#include "VerbQueryLanguageLexer.h"
#include "VerbQueryLanguageParser.h"
#include "VerbQueryLanguageTreeParser.h"

extern int VerbQueryLanguagePath;

char *resolveFunction(char *variable, char **args) {
  return "125";
}

char *resolvePath(char *path) {
  return "124";
}

char *resolveVariable(char *variable) {
  return "123";
}

int ANTLR3_CDECL main(int argc, char *argv[]) {
  VerbQueryLanguageParser_start_return langAST;
  
  pVerbQueryLanguageLexer	lxr;
  pVerbQueryLanguageParser psr;
  pVerbQueryLanguageTreeParser treePsr;
  
  pANTLR3_INPUT_STREAM istream;
  pANTLR3_COMMON_TOKEN_STREAM	tstream;
  pANTLR3_COMMON_TREE_NODE_STREAM	nodes;
  pANTLR3_STRING result;

  istream = antlr3NewAsciiStringInPlaceStream((uint8_t *)argv[1], (ANTLR3_UINT64)strlen(argv[1]), NULL);

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
		printf("Nodes: %s\n", langAST.tree->toStringTree(langAST.tree)->chars);
    treePsr	= VerbQueryLanguageTreeParserNew(nodes);
	  result = treePsr->start(treePsr);
	  if (VerbQueryLanguagePath) {
      printf("Path: %s\n", result->chars);
    } else {
      printf("Result: %s\n", result->chars);
    }
	  treePsr->free(treePsr);
	  nodes->free(nodes);
	} else {
    printf("Unable to parse VerbQL Expression\n");
  }
	tstream->free(tstream);
	psr->free(psr);
	lxr->free(lxr);
	istream->close(istream);
  return 0;
}
