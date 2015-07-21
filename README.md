# VaeQL

PHP Extension that provides accelerated parsing for VaeDB queries.

Build and install this before Vae Remote.


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
    ./configure --enable-64bit
    make
    make install


I recommend using Homebrew for PHP so future version management of PHP
is easier.  To do so, run: 

    brew tap homebrew/dupes
    brew tap homebrew/versions
    brew tap homebrew/homebrew-php
    brew install php53

As part of installing PHP 5.3 from Homebrew, you'll need to update your
$PATH in your shell to use their PHP 5.3 as the default PHP binaries.
This is key because VaeQL uses the "php-config" binary for its
installation process.

At this point, running `php` should work.

With these two things ready, you should be able to compile VaeQL.


## Compiling:

    make
    make install

Then add this line to your php.ini.  If you are using Homebrew the path
is /usr/local/etc/php/5.3/php.ini.  Otherwise, it might be in /etc.  Run
php --ini to look for candidate locations for the file.

    extension=vaeql.so


## Testing:

You should be able to run this command and see some output.  There
should be no dylib or load errors.

    php -i | grep VaeQueryLanguage

This project is tested entirely using the test suite in Vae Remote.  It
is very easy to add more tasks to that test suite and we likely do not
need one here.