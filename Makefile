CRYSTAL=crystal

SP=" "
HEADER_START=\x1b[46;30m$(SP)
HEADER_END=$(SP)\x1b[0m

default: build/inari build/Inari.app run

.PHONY: run
run: build/Inari.app
	@echo "$(HEADER_START)Running…$(HEADER_END)"
	./build/inari
	@echo

build/Inari.app: build/inari
	@echo "$(HEADER_START)Packaging $@…$(HEADER_END)"
	rm -rf $@
	mkdir $@
	mkdir $@/Contents
	mkdir $@/Contents/MacOS
	mkdir $@/Contents/Resources
	cp build/inari $@/Contents/MacOS/inari
	cp -r assets $@/Contents/Resources/assets
	cp -r shaders $@/Contents/Resources/shaders
	sed -e "s/BUILD/`git rev-list HEAD --count`/" < Info.plist > $@/Contents/Info.plist
	@echo

.PHONY: clean
clean:
	@echo "$(HEADER_START)Cleaning…$(HEADER_END)"
	rm -rf .crystal
	rm -rf tmp
	rm -rf build
	@echo

tmp/stb_image/stb_image.o: src/stb_image/stb_image.c src/stb_image/stb_image.h
	@echo "$(HEADER_START)Compiling $@…$(HEADER_END)"
	mkdir -p `dirname $@`
	clang -c $< -o $@
	@echo

tmp/libstb_image.a: tmp/stb_image/stb_image.o
	@echo "$(HEADER_START)Linking $@…$(HEADER_END)"
	libtool -static $< -o $@
	@echo

.PHONY: build/inari
build/inari: tmp/libstb_image.a
	@echo "$(HEADER_START)Building $@…$(HEADER_END)"
	mkdir -p `dirname $@`
	$(CRYSTAL) build -o $@ src/inari/inari.cr
	@echo
