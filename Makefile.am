ACLOCAL_AMFLAGS = ${ACLOCAL_FLAGS} -I m4 -I script

AM_COPT = -Wall -O2
AM_COVLDFLAGS =

if ENABLE_COVERAGE
	AM_COPT = -O0 --coverage
	AM_COVLDFLAGS += -lgcov
endif

AM_CPPFLAGS = -I$(top_srcdir)/include
AM_CFLAGS   = $(AM_COPT)
AM_CXXFLAGS = $(AM_COPT)
AM_LDFLAGS  = $(AM_COPT) $(AM_COVLDFLAGS)

# only needed to support old source tree
# we have moved the files to src folder
AM_CPPFLAGS += -I$(top_srcdir)

SOURCES = sassc.c
if COMPILER_IS_MINGW32
  SOURCES += res/libsass.rc
  AM_CXXFLAGS += -std=gnu++0x
  AM_LDFLAGS += -std=gnu++0x
else
  AM_CXXFLAGS += -std=c++0x
  AM_LDFLAGS += -std=c++0x
endif

if ENABLE_COVERAGE
  AM_CFLAGS += -O0 --coverage
  AM_CXXFLAGS += -O0 --coverage
  AM_LDFLAGS += -O0 --coverage -lgcov
else
  AM_CFLAGS += -O2
  AM_CXXFLAGS += -O2
endif

bin_PROGRAMS = sassc
sassc_SOURCES = $(SOURCES)
sassc_LDFLAGS = $(AM_LDFLAGS)

# Dummy C++ source to cause C++ linking.
# Otherwise the plain C linker is used
nodist_EXTRA_sassc_SOURCES = dummy.cxx