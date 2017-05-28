CRYSTAL=INARI_LD_PATH=$(CURDIR)/tmp crystal

default: build/inari build/Inari.app

.PHONY: run
run: build/inari
	@echo "=== Running…"
	cd build && ./inari
	@echo

build/Inari.app: build/inari
	@echo "=== Packaging $@…"
	rm -rf $@
	mkdir $@
	mkdir $@/Contents
	mkdir $@/Contents/MacOS
	mkdir $@/Contents/Resources
	cp build/inari $@/Contents/MacOS/inari
	cp -r assets $@/Contents/Resources/assets
	cp mac/Inari.icns $@/Contents/Resources
	cp -r lib/glove/src/shaders $@/Contents/Resources/shaders
	sed -e "s/BUILD/`git rev-list HEAD --count`/" < mac/Info.plist > $@/Contents/Info.plist
	@echo

.PHONY: clean
clean:
	@echo "=== Cleaning…"
	rm -rf .crystal
	rm -rf tmp
	rm -rf build
	rm -rf .shards
	rm -rf lib
	@echo

.PHONY: deps
deps: lib

lib: shard.yml
	@echo "=== Installing dependencies…"
	crystal deps
	mkdir -p `dirname $@`
	touch $@
	@echo

.PHONY: build/inari
build/inari: deps
	@echo "=== Building $@…"
	mkdir -p `dirname $@`
	$(CRYSTAL) build --no-color -o $@ src/inari/inari.cr
	rm -rf build/shaders
	cp -r lib/glove/src/shaders build/shaders
	rm -rf build/assets
	cp -r assets build/assets
	@echo done
	@echo
