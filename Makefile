SEX_C ?= sexc

travma: main.sex libSDL3.so
	$(SEX_C) $^ -o $@ -- -L./ -lm -lSDL3 -I./modules/SDL/include -I./modules -Wl,-rpath='$$ORIGIN'

libSDL3.so:
	mkdir -p ./modules/SDL/_build
	cmake -B ./modules/SDL/_build ./modules/SDL/
	cmake --build ./modules/SDL/_build -j8
	cp -d ./modules/SDL/_build/libSDL3.so* ./

clean:
	rm -f travma libSDL3.so*
