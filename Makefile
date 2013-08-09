CC = gcc
CFLAGS = -Wall -O2
LDFLAGS = -O2
LDLIBS = -lstdc++ -lm

SOURCES = sassc.c
OBJECTS = $(SOURCES:.c=.o)
TARGET = bin/sassc
SPEC_PATH = $(SASS_SPEC_PATH)

all: libsass $(TARGET)

$(TARGET): $(OBJECTS) libsass/libsass.a
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

libsass/libsass.a: libsass
libsass:
	$(MAKE) -C libsass

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

test: all
	ruby $(SASS_SPEC_PATH)/sass-spec.rb -s -d=$(SASS_SPEC_PATH) -c=$(TARGET)

test_issues: all
	ruby $(SASS_SPEC_PATH)/sass-spec.rb -s -d=$(SASS_SPEC_PATH)/spec/issues -c=$(TARGET)

clean:
	rm -f $(OBJECTS) $(TARGET)
	$(MAKE) -C libsass clean

.PHONY: clean libsass test
.DELETE_ON_ERROR:
