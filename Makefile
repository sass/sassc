CC = gcc
CFLAGS = -Wall -O2 -I $(SASS_LIBSASS_PATH) $(EXTRA_CFLAGS)
LDFLAGS = -O2 $(EXTRA_LDFLAGS)
LDLIBS = -lstdc++ -lm

SOURCES = sassc.c
OBJECTS = $(SOURCES:.c=.o)
TARGET = bin/sassc
SPEC_PATH = $(SASS_SPEC_PATH)

all: libsass $(TARGET)

$(TARGET): $(OBJECTS) $(SASS_LIBSASS_PATH)/libsass.a
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(SASS_LIBSASS_PATH)/libsass.a: libsass
libsass:
ifdef SASS_LIBSASS_PATH
	$(MAKE) -C $(SASS_LIBSASS_PATH)
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

.PHONY: clean libsass test
.DELETE_ON_ERROR:
