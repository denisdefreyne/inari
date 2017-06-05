default: dist/release/cli dist/release/mac

.PHONY: dist/development/cli
dist/development/cli: build/development/$(CLI_NAME)
	@echo "*** Assembling $@…"
	rm -rf $@
	mkdir -p $@
	cp $< $@/$(CLI_NAME)
	cp -r lib/glove/src/shaders $@/shaders
	cp -r assets $@/assets
	@echo

.PHONY: dist/release/cli
dist/release/cli: build/release/$(CLI_NAME)
	@echo "*** Assembling $@…"
	rm -rf $@
	mkdir -p $@
	cp $< $@/$(CLI_NAME)
	cp -r lib/glove/src/shaders $@/shaders
	cp -r assets $@/assets
	@echo

.PHONY: dist/release/mac
dist/release/mac: build/release/$(CLI_NAME)
	@echo "*** Assembling $@…"
	rm -rf $@/$(MAC_APP_NAME)
	mkdir -p $@/$(MAC_APP_NAME)
	mkdir $@/$(MAC_APP_NAME)/Contents
	mkdir $@/$(MAC_APP_NAME)/Contents/MacOS
	mkdir $@/$(MAC_APP_NAME)/Contents/Resources
	cp $< $@/$(MAC_APP_NAME)/Contents/MacOS/$(CLI_NAME)
	cp -r assets $@/$(MAC_APP_NAME)/Contents/Resources/assets
	test $(MAC_ICON_PATH) && cp $(MAC_ICON_PATH) $@/$(MAC_APP_NAME)/Contents/Resources || true
	cp -r lib/glove/src/shaders $@/$(MAC_APP_NAME)/Contents/Resources/shaders
	sed -e "s/BUILD/`git rev-list HEAD --count`/" < mac/Info.plist > $@/$(MAC_APP_NAME)/Contents/Info.plist
	@echo

.PHONY: build/development/$(CLI_NAME)
build/development/$(CLI_NAME): deps
	@echo "*** Building $@…"
	mkdir -p `dirname $@`
	crystal build -o $@ src/inari/inari.cr
	@echo

.PHONY: build/release/$(CLI_NAME)
build/release/$(CLI_NAME): deps
	@echo "*** Building $@…"
	mkdir -p `dirname $@`
	crystal build --release -o $@ src/inari/inari.cr
	upx --ultra-brute $@
	@echo

.PHONY: run
run: dist/development/cli
	@echo "*** Running…"
	./dist/development/cli/$(CLI_NAME)
	@echo

.PHONY: deps
deps: lib

lib: shard.yml
	@echo "*** Installing dependencies…"
	crystal deps
	mkdir -p `dirname $@`
	touch $@
	@echo
