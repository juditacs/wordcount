MIX_ENV = prod

build: wordcount

clean:
	rm -rf wordcount
	rm -rf deps
	rm -rf _build

run:
	./wordcount

rebuild: clean build




wordcount:
	MIX_ENV=$(MIX_ENV) mix compile
	MIX_ENV=$(MIX_ENV) mix escript.build
.PHONY: wordcount
