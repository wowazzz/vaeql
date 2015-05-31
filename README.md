# vaeql

PHP Extension that provides accelerated parsing for queries


## Prerequisites

 - PHP 5.3
 - libantlr3c


### Installing prerequisites on Mac:

    brew install libantlr3c

Install PHP using the Homebrew instructions in vae_remote.  Do that
first before compiling VaeQL!


## Compiling:

    make
    make install

Then add this line to your php.ini.  If you are using Homebrew the path
is /usr/local/etc/php/5.3/php.ini.  Otherwise, it might be in /etc.

    extension=vaeql.so
