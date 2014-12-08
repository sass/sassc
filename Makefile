CC ?= gcc

ifeq "$(SASSC_VERSION)" ""
  ifneq "$(wildcard ./.git/ )" ""
    SASSC_VERSION = $(shell git describe --abbrev=4 --dirty --always --tags)
  endif
endif

SASSC_VERSION ?= [NA]

CFLAGS = -DSASSC_VERSION="\"$(SASSC_VERSION)\"" -Wall -O2 -I $(SASS_LIBSASS_PATH) $(EXTRA_CFLAGS)
LDFLAGS = -O2 $(EXTRA_LDFLAGS)

ifneq (,$(findstring /cygdrive/,$(PATH)))
	UNAME := Cygwin
else
ifneq (,$(findstring WINDOWS,$(PATH)))
	UNAME := Windows
else
	UNAME := $(shell uname -s)
endif
endif

ifeq ($(UNAME),Darwin)
	LDLIBS = -lstdc++ -lm -stdlib=libc++
else
	LDLIBS = -lstdc++ -lm
endif

SOURCES = sassc.c
OBJECTS = $(SOURCES:.c=.o)
TARGET = bin/sassc
SPEC_PATH = $(SASS_SPEC_PATH)

ifneq ($(BUILD), shared)
	BUILD = static
endif

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

clean:
	rm -f $(OBJECTS) $(TARGET)
ifdef SASS_LIBSASS_PATH
	$(MAKE) -C $(SASS_LIBSASS_PATH) clean
endif

.PHONY: clean libsass libsass-static libsass-shared build-static build-shared test
.DELETE_ON_ERROR:
