SRC_DIR= libsass
BIN_DIR= bin
CC=gcc
CFLAGS= -c -Wall -O2
SOURCES= sassc.c
OBJECTS = $(SOURCES:.c=.o)

sassc: $(OBJECTS) libsass.a
	gcc -O2 -o $(BIN_DIR)/sassc sassc.o $(SRC_DIR)/libsass.a -lstdc++

libsass.a: force_look
	cd $(SRC_DIR); $(MAKE)

.c.o:
	$(CC) $(CFLAGS) $<  -o $@

test: sassc
	ruby spec.rb spec/basic/

test_all: sassc
	ruby spec.rb spec/

clean:
	rm -rf *.o build/*.o *.a
	rm -rf bin/*
	cd $(SRC_DIR); $(MAKE) clean

force_look :
	true
