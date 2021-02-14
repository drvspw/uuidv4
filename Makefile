BASEDIR = $(shell pwd)
REBAR = rebar3

APPNAME = $(shell basename $(BASEDIR))
ifneq ($(APPNAME), uuidv4)
  APPNAME = uuidv4
endif

LINTERS = lint xref eunit

compile: ## compile
	$(REBAR) compile

eunit: ## run eunit tests
	$(REBAR) eunit

xref: ## xref analysis
	$(REBAR) xref

dialyzer: ## dialyzer
	$(REBAR) dialyzer

lint: ## lint
	$(REBAR) lint

test: $(LINTERS) ## run test suites

console: test ## launch a shell
	$(REBAR) shell

clean: ## clean
	$(REBAR) clean
	rm -rf _build

test-coverage-report: ## generate test coverage report
	$(REBAR) cover --verbose

help: ## Display help information
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
