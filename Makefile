C = gcc
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

generate: VerbQueryLanguage.g VerbQueryLanguageTreeParser.g
	java -classpath vendor/antlr-3.2.jar org.antlr.Tool VerbQueryLanguage.g VerbQueryLanguageTreeParser.g

install: install-verbql.so

install-verbql.so:
	sudo cp verbql.so `php-config --extension-dir`

php_verbql.o: php_verbql.c
	${C} `php-config --includes` ${CFLAGS} php_verbql.c
	
verbql: verbql.o ${OBJS}
	${C} verbql.o ${OBJS} -lantlr3c -g -O0 -o verbql

verbql.o: verbql.c
	${C} ${CFLAGS} verbql.c
	
verbql.so: ${OBJS} php_verbql.o
	${C} -shared -fPIC -Wl,-undefined,dynamic_lookup php_verbql.o ${OBJS} /usr/local/lib/libantlr3c.a -o verbql.so
	
VerbQueryLanguageLexer.o: ${HEADERS} VerbQueryLanguageLexer.c
	${C} ${CFLAGS} VerbQueryLanguageLexer.c
	
VerbQueryLanguageParser.o: ${HEADERS} VerbQueryLanguageParser.c
	${C} ${CFLAGS} VerbQueryLanguageParser.c
	
VerbQueryLanguageTreeParser.o: ${HEADERS} VerbQueryLanguageTreeParser.c
	${C} ${CFLAGS} VerbQueryLanguageTreeParser.c