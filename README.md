# vaeql

PHP Extension that provides accelerated parsing for queries


## Prerequisites

 - PHP 5.3
 - libantlr3c


### Installing prerequisites on Mac:

    brew install libantlr3c


## Compiling:

    make
    make install

Then add this line to /etc/php.ini:

    extension=vaeql.so
