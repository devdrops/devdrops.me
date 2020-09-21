build:
	docker run --rm -ti -v $(CURDIR):/src -w /src -p 1313:1313 klakegg/hugo:latest -D

server:
	docker run --rm -ti -v $(CURDIR):/src -p 1313:1313 klakegg/hugo:latest server

sh:
	docker run --rm -ti -v $(CURDIR):/src -p 1313:1313 --entrypoint="" -w /src klakegg/hugo:latest sh
