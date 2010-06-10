C = gcc
CXX = g++
CFLAGS = -g -O2 -fPIC -I/usr/local/include -I. -c
LDFLAGS =  -L/usr/local/lib -g -o
LIBS =  -lantlr3c

GEN_SRC = VerbQueryLanguageLexer.c VerbQueryLanguageParser.c VerbQueryLanguageTreeParser.c VerbQueryLanguage.tokens
GEN_HEADERS = VerbQueryLanguageLexer.h VerbQueryLanguageParser.h VerbQueryLanguageTreeParser.h
OBJS = VerbQueryLanguageLexer.o VerbQueryLanguageParser.o VerbQueryLanguageTreeParser.o
HEADERS = ${GEN_HEADERS}
	
default: verbql verbql.so

clean:
	$(RM) verbql *.o *.so

generate: generate-grammar

generate-grammar: VerbQueryLanguage.g
	java -classpath vendor/antlr-3.2.jar org.antlr.Tool VerbQueryLanguage.g VerbQueryLanguageTreeParser.g

install: install-verbql.so

install-verbql.so:
	sudo cp verbql.so `php-config --extension-dir`

php_verbql.o: php_verbql.cpp
	${CXX} ${CFLAGS} php_verbql.cpp
	
verbql: verbql.o ${OBJS}
	${CXX} verbql.o ${OBJS} -lantlr3c -o verbql

verbql.o: verbql.c
	${C} ${CFLAGS} verbql.c
	
verbql.so: ${OBJS} php_verbql.o verbql_wrap.o
	${CXX} -shared -fPIC -Wl,-undefined,dynamic_lookup php_verbql.o verbql_wrap.o ${OBJS} /usr/local/lib/libantlr3c.a -o verbql.so
	
verbql_wrap.o: verbql_wrap.cpp php_VerbQueryLanguage.h
	${CXX} `php-config --includes` -fpic -c verbql_wrap.cpp
	
VerbQueryLanguageLexer.o: ${HEADERS}
	${C} ${CFLAGS} VerbQueryLanguageLexer.c
	
VerbQueryLanguageParser.o: ${HEADERS}
	${C} ${CFLAGS} VerbQueryLanguageParser.c
	
VerbQueryLanguageTreeParser.o: ${HEADERS}
	${C} ${CFLAGS} VerbQueryLanguageTreeParser.c