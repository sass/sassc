CC = gcc
CFLAGS = -Wall -O2
LDFLAGS = -O2
LDLIBS = -lstdc++ -lm

SOURCES = sassc.c
OBJECTS = $(SOURCES:.c=.o)
TARGET = bin/sassc

all: libsass $(TARGET)

$(TARGET): $(OBJECTS) libsass/libsass.a
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

libsass/libsass.a: libsass
libsass:
	$(MAKE) -C libsass

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

test: all
	ruby spec.rb spec/basic/

test_all: all
	ruby spec.rb spec/

test_flags: test_flags.css
.INTERMEDIATE: test_flags.css
test_flags.css: all
	$(TARGET) -t compressed -o $@ -I spec/getopt/inc spec/getopt/input.scss
	diff -u spec/getopt/expected_output.css $@
	@printf '\nCommand-line flag test passed\n\n'

clean:
	rm -f $(OBJECTS) $(TARGET)
	$(MAKE) -C libsass clean

.PHONY: clean libsass test test_all test_flags
.DELETE_ON_ERROR:
