CC       ?= gcc
CXX      ?= g++
RM       ?= rm -f
CP       ?= cp -a
MKDIR    ?= mkdir -p
WINDRES  ?= windres
CFLAGS   ?= -Wall -O2
CXXFLAGS ?= -Wall -O2
LDFLAGS  ?= -Wall -O2

ifneq (,$(findstring /cygdrive/,$(PATH)))
	UNAME := Cygwin
else
	ifneq (,$(findstring WINDOWS,$(PATH)))
		UNAME := Windows
	else
		ifneq (,$(findstring mingw32,$(MAKE)))
			UNAME := MinGW
		else
			UNAME := $(shell uname -s)
		endif
	endif
endif


ifeq "$(SASSC_VERSION)" ""
	ifneq "$(wildcard ./.git/ )" ""
		SASSC_VERSION = $(shell git describe --abbrev=4 --dirty --always --tags)
	endif
endif

ifeq "$(SASSC_VERSION)" ""
	ifneq ("$(wildcard VERSION)","")
		SASSC_VERSION ?= $(shell $(CAT) VERSION)
	endif
endif

ifneq "$(SASSC_VERSION)" ""
	CFLAGS   += -DSASSC_VERSION="\"$(SASSC_VERSION)\""
	CXXFLAGS += -DSASSC_VERSION="\"$(SASSC_VERSION)\""
endif

# enable mandatory flag
ifeq (MinGW,$(UNAME))
	CXXFLAGS += -std=gnu++0x
	LDFLAGS  += -std=gnu++0x
else
	CXXFLAGS += -std=c++0x
	LDFLAGS  += -std=c++0x
endif

ifneq "$(SASS_LIBSASS_PATH)" ""
	CFLAGS   += -I $(SASS_LIBSASS_PATH)
	CXXFLAGS += -I $(SASS_LIBSASS_PATH)
endif

ifneq "$(EXTRA_CFLAGS)" ""
	CFLAGS   += $(EXTRA_CFLAGS)
endif
ifneq "$(EXTRA_CXXFLAGS)" ""
	CXXFLAGS += $(EXTRA_CXXFLAGS)
endif
ifneq "$(EXTRA_LDFLAGS)" ""
	LDFLAGS  += $(EXTRA_LDFLAGS)
endif

LDLIBS = -lstdc++ -lm
ifeq ($(UNAME),Darwin)
	CFLAGS += -stdlib=libc++
	CXXFLAGS += -stdlib=libc++
	LDFLAGS += -stdlib=libc++
endif

ifneq (MinGW,$(UNAME))
	LDFLAGS += -ldl
	LDLIBS += -ldl
endif

ifneq ($(BUILD),shared)
	BUILD = static
endif

SOURCES = sassc.c

LIB_STATIC = $(SASS_LIBSASS_PATH)/lib/libsass.a
LIB_SHARED = $(SASS_LIBSASS_PATH)/lib/libsass.so

ifeq (MinGW,$(UNAME))
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
TARGET = bin/sassc
SPEC_PATH = $(SASS_SPEC_PATH)

ifeq (MinGW,$(UNAME))
	TARGET = bin/sassc.exe
endif
ifeq (Windows,$(UNAME))
	TARGET = bin/sassc.exe
endif

all: libsass $(TARGET)

$(TARGET): build-$(BUILD)

build-static: $(OBJECTS) $(LIB_STATIC)
	$(CC) $(LDFLAGS) -o $(TARGET) $^ $(LDLIBS)

build-shared: $(OBJECTS) $(LIB_SHARED)
	$(CP) $(LIB_SHARED) bin/
	$(CC) $(LDFLAGS) -o $(TARGET) $^ $(LDLIBS)

$(LIB_STATIC): libsass-static
$(LIB_SHARED): libsass-shared

libsass: libsass-$(BUILD)

libsass-static:
ifdef SASS_LIBSASS_PATH
	BUILD="static" $(MAKE) -C $(SASS_LIBSASS_PATH)
else
	$(error SASS_LIBSASS_PATH must be defined)
endif

libsass-shared:
ifdef SASS_LIBSASS_PATH
	BUILD="shared" $(MAKE) -C $(SASS_LIBSASS_PATH)
else
	$(error SASS_LIBSASS_PATH must be defined)
endif

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

test: all
	bin/sassc -h
	bin/sassc -v

specs: all
ifdef SASS_LIBSASS_PATH
	$(MAKE) -C $(SASS_LIBSASS_PATH) test_build
else
	$(error SASS_LIBSASS_PATH must be defined)
endif

clean:
	rm -f $(OBJECTS) $(TARGET) bin/*.so bin/*.dll
ifdef SASS_LIBSASS_PATH
	$(MAKE) -C $(SASS_LIBSASS_PATH) clean
endif

.PHONY: clean libsass libsass-static libsass-shared build-static build-shared test specs
.DELETE_ON_ERROR:
