#include "VerbQueryLanguageLexer.h"
#include "VerbQueryLanguageParser.h"
#include "VerbQueryLanguageTreeParser.h"
#include "php_verbql.h"

VerbQueryLanguage::VerbQueryLanguage() {
  psr = NULL;
  istream = NULL;
}

VerbQueryLanguage::~VerbQueryLanguage() {
	istream->close(istream);
	psr->free(psr);
}

char *VerbQueryLanguage::query(char *input) {
  char *result;
	if (istream) {
	  istream->close(istream);
  }
  if (psr) {
    psr->free(psr);
  }
  istream = antlr3NewAsciiStringInPlaceStream((uint8_t *)input, (ANTLR3_UINT64)strlen(input), NULL);
  lxr	= VerbQueryLanguageLexerNew(istream);
  if (lxr == NULL) {
		fprintf(stderr, "Unable to create the lexer due to malloc() failure1\n");
    return NULL;
  }
  tstream = antlr3CommonTokenStreamSourceNew(ANTLR3_SIZE_HINT, TOKENSOURCE(lxr));
  if (tstream == NULL) {
		fprintf(stderr, "Out of memory trying to allocate token stream\n");
    return NULL;
  }
  psr	= VerbQueryLanguageParserNew(tstream);
  if (psr == NULL) {
		fprintf(stderr, "Out of memory trying to allocate parser\n");
    return NULL;
  }
  langAST = psr->start(psr);
	if (psr->pParser->rec->state->errorCount > 0) {
    result = (char *)"_PARSE_ERROR";
	} else {
		nodes	= antlr3CommonTreeNodeStreamNewTree(langAST.tree, ANTLR3_SIZE_HINT);
		printf("Nodes: %s\n", langAST.tree->toStringTree(langAST.tree)->chars);
    treePsr	= VerbQueryLanguageTreeParserNew(nodes);
	  result = (char *)treePsr->start(treePsr)->chars;
	  treePsr->free(treePsr);
	}
	nodes->free(nodes);
	tstream->free(tstream);
	lxr->free(lxr);
  return result;
}

char *VerbQueryLanguage::resolvePath(char *input) {
  return input;
}
