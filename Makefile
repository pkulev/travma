CC ?= cc
SEX_C ?= sexc

MODULES = tiled main
OBJ = $(MODULES:%=%.o)

ifeq ($(shell uname),Darwin)
	LIBEXT := dylib
	CPLIB := cp -P -p
	RPATH := ./
else ifeq (($shell uname),Linux)
	LIBEXT := so
	CPLIB := cp -d
	RPATH := '$$ORIGIN'
endif

all: travma

%.o: %.sex
	$(SEX_C) $< -c -o $@ -- -I./modules/SDL/include -I./modules

travma: $(OBJ) libSDL3.$(LIBEXT)
	$(CC) $^ -o $@ -L./ -lm -lSDL3 -I./modules/SDL/include -I./modules -Wl -rpath $(RPATH)

libSDL3.$(LIBEXT):
	mkdir -p ./modules/SDL/_build
	cmake -B ./modules/SDL/_build ./modules/SDL/
	cmake --build ./modules/SDL/_build -j$(shell nproc)
	$(CPLIB) ./modules/SDL/_build/libSDL3\.$(LIBEXT)* ./

clean:
	rm -f travma $(OBJ) libSDL3.$(LIBEXT)*
