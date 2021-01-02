build:
	docker run --rm -ti -v $(CURDIR):/src -w /src -p 1313:1313 klakegg/hugo:latest

server:
	docker run --rm -ti -v $(CURDIR):/src -p 1313:1313 klakegg/hugo:latest server

server-all:
	docker run --rm -ti -v $(CURDIR):/src -p 1313:1313 klakegg/hugo:latest server -D

sh:
	docker run --rm -ti -v $(CURDIR):/src -p 1313:1313 --entrypoint="" -w /src klakegg/hugo:latest sh
