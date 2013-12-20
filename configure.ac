AC_PREREQ([2.61])
AC_INIT([sassc], [1.0], [support@moovweb.com])
AC_CONFIG_SRCDIR([sassc.c])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([1.10 foreign parallel-tests])
PKG_CHECK_MODULES(SASS, libsass)
LT_INIT
AC_PROG_CXX
AC_CHECK_HEADERS([sass_interface.h])
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
