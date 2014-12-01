CC = gcc
CFLAGS = -Wall -g3

INSTALL_PATH = $$HOME/SimGrid
INCLUDES = -Iinclude -I$(INSTALL_PATH)/include
DEFS = -L$(INSTALL_PATH)/lib
LDADD = -lm -lsimgrid

BIN = libmrsg.a
OBJ = common.o simcore.o dfs.o master.o worker.o user.o scheduling.o

all: $(BIN)

install: $(BIN)
	install $(BIN)               $(INSTALL_PATH)/lib
	install include/mrsg.h       $(INSTALL_PATH)/include
	install include/scheduling.h $(INSTALL_PATH)/include
	install include/common.h     $(INSTALL_PATH)/include

$(BIN): $(OBJ)
	ar rcs $(BIN) $(OBJ)
#	$(CC) $(INCLUDES) $(DEFS) $(CFLAGS) $(LDADD) -o $@ $^

%.o: src/%.c include/*.h
	$(CC) $(INCLUDES) $(DEFS) $(CFLAGS) -c -o $@ $<

verbose: clean
	$(eval CFLAGS += -DVERBOSE)

debug: clean
	$(eval CFLAGS += -O0)

final: clean
	$(eval CFLAGS += -O2)

check:
	@grep --color=auto -A4 -n -E "/[/*](FIXME|TODO)" include/*.h src/*.c

clean:
	rm -vf $(BIN) *.o *.log *.trace

.SUFFIXES:
.PHONY: all check clean debug final verbose install
