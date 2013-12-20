AC_PREREQ([2.61])
AC_INIT([sassc], [1.0], [support@moovweb.com])
AC_CONFIG_SRCDIR([sassc.c])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([1.10 foreign])

AC_ARG_WITH([libsass-include],
  [AS_HELP_STRING([--with-libass-include],
    [location of the libsass headers, defaults to /usr/include])],
  [LIBSASS_CFLAGS="-I$withval"],
  [LIBSASS_CFLAGS='-I/usr/include'])
AC_SUBST([LIBSASS_CFLAGS])

AC_ARG_WITH([libsass-lib],
  [AS_HELP_STRING([--with-libsass-lib], [location of the libsass library])],
  [LIBSASS_LIBS="-L$withval -lsass"],
  [LIBSASS_LIBS='-lsass'])
AC_SUBST([LIBSASS_LIBS])

LT_INIT
AC_PROG_CXX
AC_CHECK_HEADERS([sass_interface.h])
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
