CC       ?= cc
CXX      ?= g++
RM       ?= rm -f
MKDIR    ?= mkdir -p
CFLAGS   ?= -Wall -fPIC -O2
CXXFLAGS ?= -Wall -fPIC -O2
LDFLAGS  ?= -Wall -fPIC -O2

ifeq "$(SASSC_VERSION)" ""
  ifneq "$(wildcard ./.git/ )" ""
    SASSC_VERSION = $(shell git describe --abbrev=4 --dirty --always --tags)
  endif
endif

ifneq "$(SASSC_VERSION)" ""
  CFLAGS   += -DSASSC_VERSION="\"$(SASSC_VERSION)\""
  CXXFLAGS += -DSASSC_VERSION="\"$(SASSC_VERSION)\""
endif

# enable mandatory flag
CXXFLAGS += -std=c++0x
LDFLAGS  += -std=c++0x

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

ifneq (,$(findstring /cygdrive/,$(PATH)))
	UNAME := Cygwin
else
	ifneq (,$(findstring WINDOWS,$(PATH)))
		UNAME := Windows
	else
		UNAME := $(shell uname -s)
	endif
endif

LDLIBS = -lstdc++ -lm
ifeq ($(UNAME),Darwin)
	CFLAGS += -stdlib=libc++
	CXXFLAGS += -stdlib=libc++
	LDFLAGS += -stdlib=libc++
endif

ifneq ($(BUILD), shared)
	BUILD = static
endif

SOURCES = sassc.c
OBJECTS = $(SOURCES:.c=.o)
TARGET = bin/sassc
SPEC_PATH = $(SASS_SPEC_PATH)

all: libsass $(TARGET)

$(TARGET): build-$(BUILD)

build-static: $(OBJECTS) $(SASS_LIBSASS_PATH)/lib/libsass.a
	$(CC) $(LDFLAGS) -o $(TARGET) $^ $(LDLIBS)

build-shared: $(OBJECTS) $(SASS_LIBSASS_PATH)/lib/libsass.so
	$(CC) $(LDFLAGS) -o $(TARGET) $^ $(LDLIBS)

$(SASS_LIBSASS_PATH)/lib/libsass.a: libsass-static
$(SASS_LIBSASS_PATH)/lib/libsass.so: libsass-shared

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

clean:
	rm -f $(OBJECTS) $(TARGET)
ifdef SASS_LIBSASS_PATH
	$(MAKE) -C $(SASS_LIBSASS_PATH) clean
endif

.PHONY: clean libsass libsass-static libsass-shared build-static build-shared test
.DELETE_ON_ERROR:
