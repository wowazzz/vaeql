# vaeql

PHP Extension that provides accelerated parsing for queries


## Prerequisites

 - PHP 5.3
 - libantlr3c (MUST be version 3.2)


### Installing prerequisites on Mac:

DO NOT install libantlr3c using Homebrew, as that only supplies 
version 3.4.

To compile libantlr3c:

    wget http://www.antlr3.org/download/C/libantlr3c-3.2.tar.gz
    tar -zxvf libantlr3c-3.2.tar.gz
    cd libantlr3c-3.2
    ./configure
    make
    make install

Install PHP using the Homebrew instructions in vae_remote.  Do that
first before compiling VaeQL!


## Compiling:

    make
    make install

Then add this line to your php.ini.  If you are using Homebrew the path
is /usr/local/etc/php/5.3/php.ini.  Otherwise, it might be in /etc.

    extension=vaeql.so
