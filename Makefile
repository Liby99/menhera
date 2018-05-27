all:
	mkdir -p build/
	ocamlbuild -I src/compiler/ -build-dir build/ -use-menhir menhera.native
	mv build/src/compiler/menhera.native menhera

clean:
	ocamlbuild -I src/compiler/ -build-dir build/ -clean
	rm menhera
