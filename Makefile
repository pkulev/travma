CC ?= cc
SEX_C ?= sexc

MODULES = tiled main
OBJ = $(MODULES:%=%.o)

all: travma

%.o: %.sex
	$(SEX_C) $< -c -o $@ -- -I./modules/SDL/include -I./modules

travma: $(OBJ) libSDL3.so
	$(CC) $^ -o $@ -L./ -lm -lSDL3 -I./modules/SDL/include -I./modules -Wl,-rpath='$$ORIGIN'

libSDL3.so:
	mkdir -p ./modules/SDL/_build
	cmake -B ./modules/SDL/_build ./modules/SDL/
	cmake --build ./modules/SDL/_build -j8
	cp -d ./modules/SDL/_build/libSDL3.so* ./

clean:
	rm -f travma $(OBJ) libSDL3.so*
