#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.61])

AC_INIT([sassc], m4_esyscmd_s([./version.sh]), [support@moovweb.com])
AC_CONFIG_SRCDIR([sassc.c])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([sassc_version.h])
# These are flags passed to automake
# Though they look like gcc flags!
AM_INIT_AUTOMAKE([foreign parallel-tests -Wall])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([no])])
# would fail with mingw otherwise
m4_pattern_allow([AM_PROG_AR])

AC_ARG_WITH([libsass-include],
  [AS_HELP_STRING([--with-libsass-include],
    [location of the libsass headers, defaults to /usr/include])],
  [LIBSASS_CFLAGS="-I$withval"],
  [LIBSASS_CFLAGS='-I/usr/include'])
AC_SUBST([LIBSASS_CFLAGS])

AC_ARG_WITH([libsass-lib],
  [AS_HELP_STRING([--with-libsass-lib], [location of the libsass library])],
  [LIBSASS_LIBS="-L$withval -lsass"],
  [LIBSASS_LIBS='-lsass'])
AC_SUBST([LIBSASS_LIBS])

AC_PROG_CXX
AC_LANG([C++])
AM_PROG_AR([])
LT_INIT([dlopen])

AC_CHECK_HEADERS([sass.h])
AC_CHECK_HEADERS([sass2scss.h])
AC_CHECK_HEADERS([sass_values.h])
AC_CHECK_HEADERS([sass_context.h])
AC_CHECK_HEADERS([sass_functions.h])
AC_CHECK_HEADERS([sass_interface.h])

AC_ARG_ENABLE([coverage],
  [AS_HELP_STRING([--enable-coverage],
    [enable coverage report for test suite])],
    [enable_cov=$enableval],
    [enable_cov=no])

if test "x$enable_cov" = "xyes"; then

    AC_CHECK_PROG(GCOV, gcov, gcov)

    # Remove all optimization flags from C[XX]FLAGS
    changequote({,})
    CFLAGS=`echo "$CFLAGS" | $SED -e 's/-O[0-9]*//g'`
    CXXFLAGS=`echo "$CXXFLAGS" | $SED -e 's/-O[0-9]*//g'`
    changequote([,])

    AC_SUBST(GCOV)
fi

AM_CONDITIONAL(ENABLE_COVERAGE, test "x$enable_cov" = "xyes")

AS_CASE([$host], [*-*-mingw32], [is_mingw32=yes], [is_mingw32=no])
AM_CONDITIONAL(COMPILER_IS_MINGW32, test "x$is_mingw32" = "xyes")

AC_MSG_NOTICE([Building sassc ($VERSION)])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
