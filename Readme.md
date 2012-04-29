SassC
=======

[![Build Status](https://secure.travis-ci.org/hcatlin/sassc.png?branch=master)](http://travis-ci.org/hcatlin/sassc)

Written by Aaron Leung and Hampton Catlin (@hcatlin)

http://github.com/hcatlin/sassc

About SassC
-----------

SassC is a wrapper around libsass (http://github.com/hcatlin/libsass)
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
of the language has all been the result of years of work by Nathan
Weizenbaum (@nex3) and Chris Eppstein (@chriseppstein). 

For more information about Sass itself, please visit http://sass-lang.com

Building
--------

After you checkout the project, please make sure to update the
submodules.

	git submodule init
	git submodule update
	
Then run make:
  make

OR

  make sassc
  
The executable will be in the bin folder. To run it, simply try something like

  ./bin/sassc [input file]

Contribution Agreement
----------------------

Any contribution to the project are seen as copyright assigned to Hampton Catlin. Your contribution warrants that you have the right to assign copyright on your work. This is to ensure that the project remains free and open -- similar to the Apache Foundation.