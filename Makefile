.PHONY: run build test clean

default: build

run:
	dune exec app/main.exe

build:
	dune build app/main.exe

test:
	dune runtest

clean:
	dune clean
