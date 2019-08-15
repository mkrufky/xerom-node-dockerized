image: build

env:
	$(eval DOC_GIT_REF=$(shell git rev-parse --short HEAD))
	$(eval GIT_REF=$(shell echo ${DOC_GIT_REF}))

build: env
	@echo building xerom:${GIT_REF}
	docker build -t xerom:${GIT_REF} .

daemon: build
	@docker run --mount source=xerom,target=/root xerom:${GIT_REF}

node: daemon

interactive: build
	@docker run -i --mount source=xerom,target=/root xerom:${GIT_REF} attach

attach: interactive

console: interactive
