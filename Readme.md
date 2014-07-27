SassC
=======

[![Build Status](https://secure.travis-ci.org/sass/sassc.png?branch=master)](http://travis-ci.org/sass/sassc)

Written by Aaron Leung (@akhleung) and Hampton Catlin (@hcatlin)

http://github.com/sass/sassc

About SassC
-----------

SassC is a wrapper around libsass (http://github.com/sass/libsass)
used to generate a useful command-line application that can be installed
and packaged for several operating systems.

SassC currently statically links the libsass library, but might one
day using dynamic linking if libsass supports that in the future.

About Sass
----------

Sass is a CSS pre-processor language to add on exciting, new, 
awesome features to CSS. Sass was the first language of its kind
and by far the most mature and up to date codebase.

Sass was originally created by the co-creator of this library, 
Hampton Catlin (@hcatlin). The extension and continuing evolution
of the language has all been the result of years of work by Natalie
Weizenbaum (@nex3) and Chris Eppstein (@chriseppstein). 

For more information about Sass itself, please visit http://sass-lang.com

Building
--------

To build SassC, you must have either local copy of the libsass source or it must be installed into your system. For development, please use the source version. You must then setup an environment variable pointing to the libsass folder, like:
  
    export SASS_LIBSASS_PATH=/Users/you/path/libsass
  
The executable will be in the bin folder. To run it, simply try something like

    ./bin/sassc [input file] > output.css


Test
----

The official libsass/sassc test suite is located at http://github.com/hcatlin/sass-spec. It's a specialized project just to ensure that Sass works as expected. First, go clone (and ensure its up-to-date) the sass-spec repo. THEN, you must setup an environment variable to point to the spec folder. Also, if you want to test against the lastest libsass, you MUST define the location of a copy of the libsass repo.

For instance, this is in my profile.

    export SASS_SPEC_PATH=/Users/you/dev/sass/sass-spec
    export SASS_SASSC_PATH=/Users/you/dev/sass/sassc
    export SASS_LIBSASS_PATH=/Users/you/dev/sass/libsass

Then, run the SassC specific tests this way:

    make test

Or, if you want to run the whole SassSpec suite

    make test_spec

Contribution Agreement
----------------------

Any contribution to the project are seen as copyright assigned to Hampton Catlin. Your contribution warrants that you have the right to assign copyright on your work. This is to ensure that the project remains free and open -- similar to the Apache Foundation.
