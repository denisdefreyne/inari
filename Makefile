CRYSTAL=INARI_LD_PATH=$(PWD)/tmp crystal

SP=" "
HEADER_START=\x1b[46;30m$(SP)
HEADER_END=$(SP)\x1b[0m

default: build/inari build/Inari.app run

.PHONY: run
run: build/inari
	@echo "$(HEADER_START)Running…$(HEADER_END)"
	cd build && ./inari
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
	cp mac/Inari.icns $@/Contents/Resources
	cp -r libs/glove/shaders $@/Contents/Resources/shaders
	sed -e "s/BUILD/`git rev-list HEAD --count`/" < mac/Info.plist > $@/Contents/Info.plist
	@echo

.PHONY: clean
clean:
	@echo "$(HEADER_START)Cleaning…$(HEADER_END)"
	rm -rf .crystal
	rm -rf tmp
	rm -rf build
	rm -rf .shards
	rm -rf libs
	@echo

.PHONY: deps
deps: libs

libs: shard.yml
	@echo "$(HEADER_START)Installing dependencies…$(HEADER_END)"
	crystal deps
	mkdir -p `dirname $@`
	touch $@
	@echo

.PHONY: build/inari
build/inari: deps
	@echo "$(HEADER_START)Building $@…$(HEADER_END)"
	mkdir -p `dirname $@`
	$(CRYSTAL) build -o $@ src/inari/inari.cr
	rm -rf build/shaders
	cp -r libs/glove/shaders build/shaders
	rm -rf build/assets
	cp -r assets build/assets
	@echo
