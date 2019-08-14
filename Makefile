image: build

xerom:
	@git clone https://github.com/xero-official/go-xerom xerom

env: xerom
	$(eval DOC_GIT_REF=$(shell git rev-parse --short HEAD))
	@cd xerom; $(eval XERO_GIT_REF=$(shell git rev-parse --short HEAD))
	$(eval GIT_REF=$(shell echo ${DOC_GIT_REF})$(shell echo ${XERO_GIT_REF}))

build: env
	@echo building xerom:${GIT_REF}
	@cd xerom; docker build -f Dockerfile -t xerom:${GIT_REF} .

daemon: build
	@docker run --mount source=xerom,target=/root xerom:${GIT_REF}

node: daemon

interactive: build
	@docker run -i --mount source=xerom,target=/root xerom:${GIT_REF} attach

attach: interactive

console: interactive