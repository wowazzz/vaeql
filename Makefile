C = gcc
CFLAGS = -g -O2 -I/usr/local/include -I. -c
LDFLAGS =  -L/usr/local/lib -g -o
LIBS =  -lantlr3c

GEN_SRC = VerbQueryLanguageLexer.c VerbQueryLanguageParser.c VerbQueryLanguage.tokens
GEN_HEADERS = VerbQueryLanguageLexer.h VerbQueryLanguageParser.h
OBJS = VerbQueryLanguageLexer.o VerbQueryLanguageParser.o main.o
HEADERS = ${GEN_HEADERS}
	
default: verbql

clean:
	$(RM) verbql *.o

generate: VerbQueryLanguage.g
	java -classpath vendor/antlr-3.2.jar org.antlr.Tool VerbQueryLanguage.g

install: verbql
	cp verbql /usr/local/bin
	
main.o: main.c ${HEADERS}
	${C} ${CFLAGS} main.c

verbql: ${OBJS}
	${C} ${LDFLAGS} verbql ${LIBS} ${OBJS}
	
VerbQueryLanguageLexer.o: ${HEADERS}
	${C} ${CFLAGS} VerbQueryLanguageLexer.c
	
VerbQueryLanguageParser.o: ${HEADERS}
	${C} ${CFLAGS} VerbQueryLanguageParser.c