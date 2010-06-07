#include "VerbQueryLanguageLexer.h"
#include "VerbQueryLanguageParser.h"

int ANTLR3_CDECL main(int argc, char *argv[]) {
  pVerbQueryLanguageLexer	lxr;
  pVerbQueryLanguageParser psr;
  VerbQueryLanguageParser_start_return langAST;
  
  pANTLR3_INPUT_STREAM input;
  pANTLR3_COMMON_TOKEN_STREAM	tstream;
  pANTLR3_COMMON_TREE_NODE_STREAM	nodes;

  //pVerbQueryLanguageDumpDecl		    treePsr;

  input = antlr3NewAsciiStringInPlaceStream ((uint8_t *)argv[1], (ANTLR3_UINT64)strlen(argv[1]), NULL);

  lxr	= VerbQueryLanguageLexerNew(input);
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
	if (psr->pParser->rec->state->errorCount > 0) {
		fprintf(stderr, "The parser returned %d errors, tree walking aborted.\n", psr->pParser->rec->state->errorCount);
	} else {
		nodes	= antlr3CommonTreeNodeStreamNewTree(langAST.tree, ANTLR3_SIZE_HINT);
		printf("Nodes: %s\n", langAST.tree->toStringTree(langAST.tree)->chars);
/*
		treePsr	= VerbQueryLanguageDumpDeclNew(nodes);

		treePsr->decl(treePsr);
		nodes   ->free  (nodes);	    nodes	= NULL;
		treePsr ->free  (treePsr);	    treePsr	= NULL;*/
	}

	psr	    ->free  (psr);		psr		= NULL;
	tstream ->free  (tstream);	tstream	= NULL;
	lxr	    ->free  (lxr);	    lxr		= NULL;
	input   ->close (input);	input	= NULL;

  return 0;
}
