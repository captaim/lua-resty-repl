all: lint test

lint:
	docker-compose run --rm app luacheck .

build:
	docker build -t saksmlz/openresty-testsuite:latest -f Dockerfile .
	docker build -t saksmlz/lua51-testsuite:latest -f Dockerfile-lua51 .

push_images:
	docker push saksmlz/openresty-testsuite:latest
	docker push saksmlz/lua51-testsuite:latest

test: test_openresty test_luajit test_lua51 test_with_expect

test_openresty:
	@echo OPENRESTY:
	@docker-compose run --rm app resty-busted spec

test_luajit:
	@echo LUAJIT:
	@docker-compose run --rm app busted spec

test_lua51:
	@echo LUA5.1:
	@docker-compose run --rm lua51 bin/lua51test

test_with_expect:
	@docker-compose run --rm expect

shell:
	docker-compose run --rm app

repl:
	@docker-compose run --rm app \
		resty        \
			-I lib/    \
			-I vendor/ \
			-e 'require("resty.repl").start()'

.PHONY: lint test shell repl build push_images test_openresty test_luajit test_lua51 test_with_expect
