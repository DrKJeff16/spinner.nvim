.DEFAULT_GOAL = test

LUA_FILES := $(shell find . -name "*.lua" ! -path "./.git/*")
MD_FILES := README.md
SH_FILES := test/bin/lua.sh scripts/**
YAML_FILES := .github/workflows/test.yaml .github/workflows/stylua.yaml

.PHONY: fmt test doc

fmt:
	@stylua $(LUA_FILES)
	@prettier --write $(MD_FILES)
	@prettier --write $(YAML_FILES)
	@shfmt -w --indent 4 -bn -ci -sr $(SH_FILES)
test:
	@busted
doc:
	@scripts/doc.sh
