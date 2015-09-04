#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.61])

AC_INIT([sassc], m4_esyscmd_s([./version.sh]), [support@moovweb.com])
AC_CONFIG_SRCDIR([sassc.c])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([sassc_version.h])
AC_CONFIG_AUX_DIR([script])
# These are flags passed to automake
# Though they look like gcc flags!
AM_INIT_AUTOMAKE([foreign parallel-tests -Wall])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([no])])

# the new prefered way
# only need install path
AC_ARG_WITH([libsass],
  [AS_HELP_STRING([--with-libsass],
    [libsass install location])],
  [LDFLAGS="$LDFLAGS -L$withval/lib"]
  [CPPFLAGS="$CPPFLAGS -I$withval/include"])

# this is discouraged, use `with-libsass`:
AC_ARG_WITH([libsass-lib],
  [AS_HELP_STRING([--with-libsass-lib],
    [location of libsass library])],
  [AC_MSG_WARN([use of --with-libsass-lib is discouraged!
  use new syntax: ./configure --with-libsass="prefix"])]
  [LDFLAGS="$LDFLAGS -L$withval"])

# this is discouraged, use `with-libsass`:
# ./configure INCLUDE_PATH="build/include"
AC_ARG_WITH([libsass-include],
  [AS_HELP_STRING([--with-libsass-include],
    [location of libsass headers])],
  [AC_MSG_WARN([use of --with-libsass-include is discouraged,
  use new syntax: ./configure --with-libsass="prefix"])]
  [CPPFLAGS="$CPPFLAGS -I$withval"])

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AC_LANG([C++])
AC_GNU_SOURCE
# Check fails on Travis, but it works fine
# AX_CXX_COMPILE_STDCXX_11([ext],[optional])
AC_CHECK_TOOL([AR], [ar], [false])
AC_CHECK_TOOL([DLLTOOL], [dlltool], [false])
AC_CHECK_TOOL([DLLWRAP], [dllwrap], [false])
AC_CHECK_TOOL([WINDRES], [windres], [false])
m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
AM_PROG_AR([])
LT_INIT([dlopen])

AS_CASE([$host], [*-*-mingw*], [is_mingw32=yes], [is_mingw32=no])
AM_CONDITIONAL(COMPILER_IS_MINGW32, test "x$is_mingw32" = "xyes")

dnl The dlopen() function is in the C library for *BSD and in
dnl libdl on GLIBC-based systems
if test "x$is_mingw32" != "xyes"; then
  AC_SEARCH_LIBS([dlopen], [dl dld], [], [
    AC_MSG_ERROR([unable to find the dlopen() function])
  ])
fi

# check the main assets needed to link to libsass (headers and library)
AC_CHECK_LIB([sass],[libsass_version],, [AC_MSG_ERROR([unable to find libsass library (use --with-libsass?)])])
AC_CHECK_HEADERS([sass.h],, [AC_MSG_ERROR([unable to find libsass headers (use --with-libsass?)])])

# also check for additional libsass headers (just in case)
AC_CHECK_HEADERS([sass2scss.h],, [AC_MSG_ERROR([unable to find sass2scss.h])])
AC_CHECK_HEADERS([sass/values.h],, [AC_MSG_ERROR([unable to find sass/values.h])])
AC_CHECK_HEADERS([sass/functions.h],, [AC_MSG_ERROR([unable to find sass_functions.h])])
AC_CHECK_HEADERS([sass/context.h],, [AC_MSG_ERROR([unable to find sass/context.h])])

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

AC_CHECK_PROG(WINDRES, windres, windres)

AM_CONDITIONAL(ENABLE_COVERAGE, test "x$enable_cov" = "xyes")

AC_MSG_NOTICE([Building sassc ($VERSION)])

AC_CONFIG_FILES([GNUmakefile])
AC_OUTPUT
