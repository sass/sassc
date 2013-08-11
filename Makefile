CC = gcc
CFLAGS = -Wall -O2 -I $(SASS_LIBSASS_PATH)
LDFLAGS = -O2
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
	$(MAKE) -C $(SASS_LIBSASS_PATH)

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

test: all

clean:
	rm -f $(OBJECTS) $(TARGET)
	$(MAKE) -C $(SASS_LIBSASS_PATH) clean

.PHONY: clean libsass test
.DELETE_ON_ERROR:
