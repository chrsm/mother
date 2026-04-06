.DEFAULT_GOAL := help

MOTHER_LUA_VERSION ?= 5.4

LUAROCKS ?= luarocks --lua-version=$(MOTHER_LUA_VERSION)

LUA_DIR=/usr
LUA_LIBDIR=$(LUA_DIR)/lib/lua/$(MOTHER_LUA_VERSION)
LUA_BINDIR=$(LUA_DIR)/bin
LUA=$(LUA_BINDIR)/$(MOTHER_LUA_VERSION)
LUA_INCDIR=$(LUA_DIR)/include
LUA_SHAREDIR=$(LUA_DIR)/share/lua/$(MOTHER_LUA_VERSION)

INST_PREFIX=/usr/local
INST_LIBDIR=$(INST_PREFIX)/lib/lua/$(MOTHER_LUA_VERSION)
INST_BINDIR=$(INST_PREFIX)/bin
INST_LUADIR=$(INST_PREFIX)/share/lua/$(MOTHER_LUA_VERSION)
INST_CONFDIR=$(INST_PREFIX)/etc

YCT_LPATH=$(shell $(LUAROCKS) path --full --lr-path)

.PHONY: all
all: test

.PHONY: clean
## delete any compiled lua files
clean:
	cd src && find . -type f -name '*.lua' -delete
	cd spec && find . -type f -name '*.lua' -delete

.PHONY: test
## run all tests
test:
	export LUA_PATH='$(YCT_LPATH)' && cd src && \
		yue -e ../spec/gen.yue -v -C . -o gtest --exclude-tags='ignore' && \
		yue -e ../spec/full.yue -v -C . -o gtest --exclude-tags='ignore'

.PHONY: lint
## run linter
lint:
	cd src && yuecheck .

.PHONY: format
## run formatter
format:
	cd src && yuefmt -w .

.PHONY: build
## luarocks only
build:

.PHONY: install
## luarocks only, install files
install:
	mkdir -p $(INST_LUADIR)/mother
	cp -R src/mother $(INST_LUADIR)/
	cp bin/mother $(INST_BINDIR)/
.PHONY: uninstall
## luarocks only, delete all installed files
uninstall:
	$(LUAROCKS) remove mother
	rm -rf $(HOME)/.luarocks/bin/mother
	rm -rf $(HOME)/.luarocks/lib/luarocks/rocks-$(MOTHER_LUA_VERSION)/mother
	rm -rf $(HOME)/.luarocks/share/lua/$(MOTHER_LUA_VERSION)/mother

.PHONY: rock
## build and install rock locally
rock:
	$(LUAROCKS) --local make
rock-actions:
	@# not documenting this, because it's only for actions that run as root
	$(LUAROCKS) make

.PHONY: help
## list available commands
help: Makefile
	# original source? https://gist.github.com/prwhite/8168133
	@echo "$$(tput bold)Available commands:$$(tput sgr0)";echo;sed -ne"/^## /{h;s/.*//;:d" -e"H;n;s/^## //;td" -e"s/:.*//;G;s/\\n## /---/;s/\\n/ /g;p;}" ${MAKEFILE_LIST}|awk -F --- -v n=$$(tput cols) -v i=19 -v a="$$(tput setaf 6)" -v z="$$(tput sgr0)" '{printf"%s%*s%s ",a,-i,$$1,z;m=split($$2,w," ");l=n-i;for(j=1;j<=m;j++){l-=length(w[j])+1;if(l<= 0){l=n-i-length(w[j])-1;printf"\n%*s ",-i," ";}printf"%s ",w[j];}printf"\n";}'|more $(shell test $(shell uname) == Darwin && echo '-Xr')
