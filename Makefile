CC       ?= cc
CXX      ?= c++
RM       ?= rm -f
CP       ?= cp -a
CHDIR    ?= chdir
MKDIR    ?= mkdir
WINDRES  ?= windres
INSTALL  ?= install
CFLAGS   ?= -Wall
CXXFLAGS ?= -Wall
LDFLAGS  ?= -Wall
ifneq "$(COVERAGE)" "yes"
  CFLAGS   += -O2
  CXXFLAGS += -O2
  LDFLAGS  += -O2
endif
LDFLAGS  += -Wl,-undefined,error
CAT      ?= $(if $(filter $(OS),Windows_NT),type,cat)

# If you run this under windows cmd.com interpreter:
# You must provide UnxUtils rm.exe and cp.exe in path
# Otherwise certain targets may not work as intended!
# Note: It seems impossible to replace `mkdir` command

ifneq (,$(findstring /cygdrive/,$(PATH)))
	UNAME := Cygwin
	TARGET := Windows
else ifneq (,$(findstring Windows_NT,$(OS)))
	UNAME := Windows
	TARGET := Windows
else ifneq (,$(findstring mingw32,$(MAKE)))
	UNAME := MinGW
	TARGET := Windows
else ifneq (,$(findstring MINGW32,$(shell uname -s)))
	UNAME := MinGW
	TARGET := Windows
else
	UNAME := $(shell uname -s)
	TARGET := $(shell uname -s)
endif

ifeq ($(SASS_SASSC_PATH),)
	SASS_SASSC_PATH = $(abspath $(CURDIR))
endif
ifeq ($(SASS_LIBSASS_PATH),)
	SASS_LIBSASS_PATH = $(abspath $(CURDIR)/..)
endif

ifeq ($(SASSC_VERSION),)
	ifneq ($(wildcard ./.git/ ),)
		SASSC_VERSION ?= $(shell git describe --abbrev=4 --dirty --always --tags)
	endif
endif

ifeq ($(SASSC_VERSION),)
	ifneq ($(wildcard VERSION),)
		SASSC_VERSION ?= $(shell $(CAT) VERSION)
	endif
endif

ifneq ($(SASSC_VERSION),)
	CFLAGS   += -DSASSC_VERSION="\"$(SASSC_VERSION)\""
	CXXFLAGS += -DSASSC_VERSION="\"$(SASSC_VERSION)\""
endif

# enable mandatory flag
ifeq (Windows,$(TARGET))
	ifneq ($(BUILD),shared)
		STATIC_ALL     ?= 1
	endif
	STATIC_LIBGCC    ?= 1
	STATIC_LIBSTDCPP ?= 1
	CXXFLAGS += -std=c++11
	LDFLAGS  += -std=c++11
else
	STATIC_ALL       ?= 0
	STATIC_LIBGCC    ?= 0
	STATIC_LIBSTDCPP ?= 0
	CXXFLAGS += -std=c++11
	LDFLAGS  += -std=c++11
endif

ifneq ($(SASS_LIBSASS_PATH),)
	CFLAGS   += -I $(SASS_LIBSASS_PATH)/include
	CXXFLAGS += -I $(SASS_LIBSASS_PATH)/include
	# only needed to support old source tree
	# we have moved the files to src folder
	CFLAGS   += -I $(SASS_LIBSASS_PATH)
	CXXFLAGS += -I $(SASS_LIBSASS_PATH)
else
	# this is needed for mingw
	CFLAGS   += -I include
	CXXFLAGS += -I include
endif

ifneq ($(EXTRA_CFLAGS),)
	CFLAGS   += $(EXTRA_CFLAGS)
endif
ifneq ($(EXTRA_CXXFLAGS),)
	CXXFLAGS += $(EXTRA_CXXFLAGS)
endif
ifneq ($(EXTRA_LDFLAGS),)
	LDFLAGS  += $(EXTRA_LDFLAGS)
endif

LDLIBS = -lm

ifneq ($(BUILD),shared)
	LDLIBS += -lstdc++
endif

# link statically into lib
# makes it a lot more portable
# increases size by about 50KB
ifeq ($(STATIC_ALL),1)
	LDFLAGS += -static
endif
ifeq ($(STATIC_LIBGCC),1)
	LDFLAGS += -static-libgcc
endif
ifeq ($(STATIC_LIBSTDCPP),1)
	LDFLAGS += -static-libstdc++
endif

ifeq ($(UNAME),Darwin)
	CFLAGS += -stdlib=libc++
	CXXFLAGS += -stdlib=libc++
	LDFLAGS += -stdlib=libc++
endif

ifneq (Windows,$(TARGET))
	ifneq (FreeBSD,$(UNAME))
    ifneq (OpenBSD,$(UNAME))
			LDFLAGS += -ldl
			LDLIBS += -ldl
		endif
	endif
endif

ifneq ($(BUILD),shared)
	BUILD = static
endif

ifeq (,$(PREFIX))
	ifeq (,$(TRAVIS_BUILD_DIR))
		PREFIX = /usr/local
	else
		PREFIX = $(TRAVIS_BUILD_DIR)
	endif
endif

SOURCES = sassc.c

LIB_STATIC = $(SASS_LIBSASS_PATH)/lib/libsass.a
LIB_SHARED = $(SASS_LIBSASS_PATH)/lib/libsass.so

RESOURCES =
SASSC_EXE = bin/sassc
ifeq ($(UNAME),Darwin)
	SHAREDLIB = lib/libsass.dylib
	LIB_SHARED = $(SASS_LIBSASS_PATH)/lib/libsass.dylib
endif
ifeq (Windows,$(TARGET))
	RESOURCES = libsass.res
	SASSC_EXE = bin/sassc.exe
	ifeq (shared,$(BUILD))
		CFLAGS     += -D ADD_EXPORTS
		CXXFLAGS   += -D ADD_EXPORTS
		LIB_SHARED  = $(SASS_LIBSASS_PATH)/lib/libsass.dll
	endif
else
	CFLAGS   += -fPIC
	CXXFLAGS += -fPIC
	LDFLAGS  += -fPIC
endif

OBJECTS = $(SOURCES:.c=.o)
SPEC_PATH = $(SASS_SPEC_PATH)
all: sassc

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.rc
	$(WINDRES) -i $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

sassc: $(SASSC_EXE)
build: build-$(BUILD)
libsass: libsass-$(BUILD)

$(SASSC_EXE): libsass build

$(DESTDIR)$(PREFIX)/:
	$(MKDIR) $(DESTDIR)$(PREFIX)

$(DESTDIR)$(PREFIX)/bin/:
	$(MKDIR) $(DESTDIR)$(PREFIX)/bin

$(DESTDIR)$(PREFIX)/bin/%: bin/%
	$(INSTALL) -D -v -m0755 "$<" "$@"

install: libsass-install-$(BUILD) \
	$(DESTDIR)$(PREFIX)/$(SASSC_EXE)

build-static: $(RESOURCES) $(OBJECTS) $(LIB_STATIC)
	$(CC) $(LDFLAGS) -o $(SASSC_EXE) $^ $(LDLIBS)

build-shared: $(RESOURCES) $(OBJECTS) $(LIB_SHARED)
	$(CC) $(LDFLAGS) -o $(SASSC_EXE) $(RESOURCES) $(OBJECTS) \
		-Wl,-rpath,$(DESTDIR)$(PREFIX)/lib \
		-Wl,-rpath,$(SASS_LIBSASS_PATH)/lib \
		$(LDLIBS) -L$(SASS_LIBSASS_PATH)/lib -lsass

$(LIB_STATIC): libsass-static
$(LIB_SHARED): libsass-shared

libsass-static:
ifdef SASS_LIBSASS_PATH
	$(MAKE) BUILD="static" -C $(SASS_LIBSASS_PATH)
else
	$(error SASS_LIBSASS_PATH must be defined)
endif

libsass-shared:
ifdef SASS_LIBSASS_PATH
	$(MAKE) BUILD="shared" -C $(SASS_LIBSASS_PATH)
else
	$(error SASS_LIBSASS_PATH must be defined)
endif

# nothing to do for static
libsass-install-static: libsass-static
ifdef SASS_LIBSASS_PATH
	$(MAKE) BUILD="static" -C $(SASS_LIBSASS_PATH) install
else
	$(error SASS_LIBSASS_PATH must be defined)
endif

# install shared library
libsass-install-shared: libsass-shared
ifdef SASS_LIBSASS_PATH
	$(MAKE) BUILD="shared" -C $(SASS_LIBSASS_PATH) install
else
	$(error SASS_LIBSASS_PATH must be defined)
endif

test: all
	$(MAKE) -C $(SASS_LIBSASS_PATH) version

libsass.res:
	$(WINDRES) res/libsass.rc -O coff libsass.res

specs: all
ifdef SASS_LIBSASS_PATH
	$(MAKE) -C $(SASS_LIBSASS_PATH) test_build
else
	$(error SASS_LIBSASS_PATH must be defined)
endif

clean:
	rm -f $(OBJECTS) $(SASSC_EXE) \
	      bin/*.so bin/*.dll bin/*.dylib libsass.res
ifdef SASS_LIBSASS_PATH
	$(MAKE) -C $(SASS_LIBSASS_PATH) clean
endif

.PHONY: test specs clean sassc \
        all build-static build-shared \
        libsass libsass-static libsass-shared
.DELETE_ON_ERROR:
