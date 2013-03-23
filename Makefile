CC = gcc
CFLAGS = -Wall -O2 -Ilibsass
LDFLAGS = -Llibsass
LDLIBS = -lstdc++ -lm -lsass

SOURCES = sassc.c
OBJECTS = $(SOURCES:.c=.o)
TARGET = bin/sassc

all: submodule $(TARGET)

shared:
	@$(MAKE) $(TARGET) CFLAGS='-Wall -O2 -fPIC' LDFLAGS=''

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

submodule:
	$(MAKE) -C libsass

test: all
	ruby spec.rb spec/basic/

test_all: all
	ruby spec.rb spec/

test_flags: all
	$(TARGET) -t compressed -o $@.css -I spec/getopt/inc spec/getopt/input.scss
	diff -u $@.css spec/getopt/expected.css
	rm -f $@.css
	@printf '\nCommand-line flag test passed\n\n'

clean:
	rm -f $(OBJECTS) $(TARGET)
	$(MAKE) -C libsass clean


.PHONY: all shared submodule test test_all test_flags clean
.DELETE_ON_ERROR:
