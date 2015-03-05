ACLOCAL_AMFLAGS = -I m4

AM_LDFLAGS =
AM_CFLAGS = -Wall -fPIC
AM_CXXFLAGS = -Wall -fPIC
AM_CFLAGS += -DSASSC_VERSION="\"$(VERSION)\""
AM_CXXFLAGS += -DSASSC_VERSION="\"$(VERSION)\""

if COMPILER_IS_MINGW32
  AM_CXXFLAGS += -std=gnu++0x
  AM_LDFLAGS += -std=gnu++0x
else
  AM_CXXFLAGS += -std=c++0x
  AM_LDFLAGS += -std=c++0x -ldl
endif

LDLIBS = -lstdc++ -lm

if ENABLE_COVERAGE
  AM_CFLAGS += -O0 --coverage
  AM_CXXFLAGS += -O0 --coverage
  AM_LDFLAGS += -O0 --coverage -lgcov
else
  AM_CFLAGS += -O2
  AM_CXXFLAGS += -O2
endif

bin_PROGRAMS = sassc
sassc_SOURCES = sassc.c
sassc_CFLAGS = $(AM_CFLAGS) $(LIBSASS_CFLAGS)
sassc_CXXFLAGS = $(AM_CXXFLAGS) $(LIBSASS_CFLAGS)
sassc_LDFLAGS= $(AM_LDFLAGS) $(LIBSASS_LIBS) $(LDLIBS)
