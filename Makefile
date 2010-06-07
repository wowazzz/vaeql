C = gcc
CXX = g++
CFLAGS = -g -O2 -fPIC -I/usr/local/include -I. -c
LDFLAGS =  -L/usr/local/lib -g -o
LIBS =  -lantlr3c

GEN_SRC = VerbQueryLanguageLexer.c VerbQueryLanguageParser.c VerbQueryLanguage.tokens
GEN_HEADERS = VerbQueryLanguageLexer.h VerbQueryLanguageParser.h
OBJS = VerbQueryLanguageLexer.o VerbQueryLanguageParser.o
HEADERS = ${GEN_HEADERS}
	
default: verbql verbql.so

clean:
	$(RM) verbql *.o *.so

generate: generate-grammar generate-swig

generate-grammar: VerbQueryLanguage.g
	java -classpath vendor/antlr-3.2.jar org.antlr.Tool VerbQueryLanguage.g

generate-swig: verbql.i
	swig -php -c++ verbql.i

install: install-verbql install-verbql.so

install-verbql:
	cp verbql /usr/local/bin

install-verbql.so:
	sudo cp verbql.so `php-config --extension-dir`
	
main.o: main.c ${HEADERS}
	${CXX} ${CFLAGS} main.c

verbql: ${OBJS} main.o
	${CXX} ${LDFLAGS} verbql main.o ${LIBS} ${OBJS}

verbql.o: verbql.cpp
	${CXX} ${CFLAGS} verbql.cpp
	
verbql.so: VerbQueryLanguageLexer.o VerbQueryLanguageParser.o verbql.o verbql_wrap.o
	${C} -shared -fPIC -Wl,-undefined,dynamic_lookup verbql.o verbql_wrap.o ${LIBS} -o verbql.so
	
verbql_wrap.o: verbql_wrap.cpp php_verbql.h
	${CXX} `php-config --includes` -fpic -c verbql_wrap.cpp
	
VerbQueryLanguageLexer.o: ${HEADERS}
	${C} ${CFLAGS} VerbQueryLanguageLexer.c
	
VerbQueryLanguageParser.o: ${HEADERS}
	${C} ${CFLAGS} VerbQueryLanguageParser.c