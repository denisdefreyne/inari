CRYSTAL=INARI_LD_PATH=$(PWD)/tmp crystal

default: dist/release/cli dist/release/mac

.PHONY: dist/development/cli
dist/development/cli: build/development/memory
	@echo "*** Assembling $@…"
	rm -rf $@
	mkdir -p $@
	cp $< $@/memory
	cp -r lib/glove/src/shaders $@/shaders
	cp -r assets $@/assets
	@echo

.PHONY: dist/release/cli
dist/release/cli: build/release/memory
	@echo "*** Assembling $@…"
	rm -rf $@
	mkdir -p $@
	cp $< $@/memory
	cp -r lib/glove/src/shaders $@/shaders
	cp -r assets $@/assets
	@echo

.PHONY: dist/release/mac
dist/release/mac: build/release/memory
	@echo "*** Assembling $@…"
	rm -rf $@/Memory.app
	mkdir -p $@/Memory.app
	mkdir $@/Memory.app/Contents
	mkdir $@/Memory.app/Contents/MacOS
	mkdir $@/Memory.app/Contents/Resources
	cp $< $@/Memory.app/Contents/MacOS/memory
	cp -r assets $@/Memory.app/Contents/Resources/assets
	cp mac/Memory.icns $@/Memory.app/Contents/Resources
	cp -r lib/glove/src/shaders $@/Memory.app/Contents/Resources/shaders
	sed -e "s/BUILD/`git rev-list HEAD --count`/" < mac/Info.plist > $@/Memory.app/Contents/Info.plist
	@echo

.PHONY: build/development/memory
build/development/memory: deps
	@echo "*** Building $@…"
	mkdir -p `dirname $@`
	$(CRYSTAL) build -o $@ src/inari/inari.cr
	@echo

.PHONY: build/release/memory
build/release/memory: deps
	@echo "*** Building $@…"
	mkdir -p `dirname $@`
	$(CRYSTAL) build --release -o $@ src/inari/inari.cr
	upx --ultra-brute $@
	@echo

.PHONY: run
run: dist/development/cli
	@echo "*** Running…"
	./dist/development/cli/memory
	@echo

.PHONY: deps
deps: lib

lib: shard.yml
	@echo "*** Installing dependencies…"
	crystal deps
	mkdir -p `dirname $@`
	touch $@
	@echo
