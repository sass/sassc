SassC
=======

[![Unix CI](https://secure.travis-ci.org/sass/sassc.svg?branch=master)](http://travis-ci.org/sass/sassc)
[![Windows CI](https://ci.appveyor.com/api/projects/status/github/sass/sassc?svg=true)](https://ci.appveyor.com/project/sass/sassc/branch/master)

by Aaron Leung ([@akhleung]), Hampton Catlin ([@hcatlin]), Marcel Greter ([@mgreter]) and Michael Mifsud ([@xzyfer])

http://github.com/sass/sassc

**Warning:** [LibSass and SassC are deprecated](https://sass-lang.com/blog/libsass-is-deprecated).
While it will continue to receive maintenance releases indefinitely, there are no
plans to add additional features or compatibility with any new CSS or Sass features.
Projects that still use it should move onto
[Dart Sass](https://sass-lang.com/dart-sass).

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

Sass was originally conceived of by the co-creator of this library,
Hampton Catlin ([@hcatlin]). Most of the language has been the result of years
of work by Natalie Weizenbaum ([@nex3]) and Chris Eppstein ([@chriseppstein]).

For more information about Sass itself, please visit https://sass-lang.com

Initial development of SassC by Aaron Leung and Hampton Catlin was supported by [Moovweb](http://www.moovweb.com).

Documentation
-------------

* [Building on Unix](docs/building/unix-instructions.md)
* [Building on Windows](docs/building/windows-instructions.md)
* [Testing on Unix](docs/testing/unix-instructions.md)
* [Testing on Windows](docs/testing/windows-instructions.md)

Licensing
---------

Our MIT license is designed to be as simple, and liberal as possible.

[@hcatlin]: https://github.com/hcatlin
[@akhleung]: https://github.com/akhleung
[@chriseppstein]: https://github.com/chriseppstein
[@nex3]: https://github.com/nex3
[@mgreter]: https://github.com/mgreter
[@xzyfer]: https://github.com/xzyfer
