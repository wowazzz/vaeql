C = gcc
CFLAGS = -g -O2 -fPIC -I/usr/local/include -I. -c
LDFLAGS =  -L/usr/local/lib -g -o
LIBS =  -lantlr3c

GEN_SRC = VaeQueryLanguageLexer.c VaeQueryLanguageParser.c VaeQueryLanguageTreeParser.c VaeQueryLanguage.tokens
GEN_HEADERS = VaeQueryLanguageLexer.h VaeQueryLanguageParser.h VaeQueryLanguageTreeParser.h
OBJS = VaeQueryLanguageLexer.o VaeQueryLanguageParser.o VaeQueryLanguageTreeParser.o
HEADERS = ${GEN_HEADERS}
	
default: vaeql.so

clean:
	$(RM) vaeql *.o *.so

generate: VaeQueryLanguage.g VaeQueryLanguageTreeParser.g
	java -classpath vendor/antlr-3.2.jar org.antlr.Tool VaeQueryLanguage.g VaeQueryLanguageTreeParser.g

install: install-vaeql.so

install-vaeql.so:
	mkdir -p `php-config --extension-dir`
	sudo cp vaeql.so `php-config --extension-dir`

php_vaeql.o: php_vaeql.c
	${C} `php-config --includes` ${CFLAGS} php_vaeql.c
	
vaeql.o: vaeql.c
	${C} ${CFLAGS} vaeql.c
	
vaeql.so: ${OBJS} php_vaeql.o
	${C} ${LDFLAGS} -shared -fPIC -Wl,-undefined,dynamic_lookup php_vaeql.o ${OBJS} ${LIBS} -o vaeql.so
	
VaeQueryLanguageLexer.o: ${HEADERS} VaeQueryLanguageLexer.c
	${C} ${CFLAGS} VaeQueryLanguageLexer.c
	
VaeQueryLanguageParser.o: ${HEADERS} VaeQueryLanguageParser.c
	${C} ${CFLAGS} VaeQueryLanguageParser.c
	
VaeQueryLanguageTreeParser.o: ${HEADERS} VaeQueryLanguageTreeParser.c
	${C} ${CFLAGS} VaeQueryLanguageTreeParser.c
