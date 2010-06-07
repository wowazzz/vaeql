#include "verbql.h"
#include "VerbQueryLanguageLexer.h"
#include "VerbQueryLanguageParser.h"

VerbQueryLanguage::~VerbQueryLanguage() {
  // do nothing
}

char *VerbQueryLanguage::query(char *input) {
  pVerbQueryLanguageLexer	lxr;
  pVerbQueryLanguageParser psr;
  VerbQueryLanguageParser_start_return langAST;
  
  pANTLR3_INPUT_STREAM istream;
  pANTLR3_COMMON_TOKEN_STREAM	tstream;
  pANTLR3_COMMON_TREE_NODE_STREAM	nodes;

  //pVerbQueryLanguageDumpDecl		    treePsr;

  istream = antlr3NewAsciiStringInPlaceStream ((uint8_t *)input, (ANTLR3_UINT64)strlen(input), NULL);

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
	if (psr->pParser->rec->state->errorCount > 0) {
		fprintf(stderr, "The parser returned %d errors, tree walking aborted.\n", psr->pParser->rec->state->errorCount);
	} else {
		nodes	= antlr3CommonTreeNodeStreamNewTree(langAST.tree, ANTLR3_SIZE_HINT);
		return (char *)langAST.tree->toStringTree(langAST.tree)->chars;
/*
		treePsr	= VerbQueryLanguageDumpDeclNew(nodes);

		treePsr->decl(treePsr);
		nodes   ->free  (nodes);	    nodes	= NULL;
		treePsr ->free  (treePsr);	    treePsr	= NULL;*/
	}

	psr	    ->free  (psr);		psr		= NULL;
	tstream ->free  (tstream);	tstream	= NULL;
	lxr	    ->free  (lxr);	    lxr		= NULL;
	istream   ->close (istream);	istream	= NULL;

}

char *VerbQueryLanguage::resolvePath(char *input) {
  return input;
}
