all:
	ocamlbuild -use-menhir -package llvm mini_menhera.native

test:
	ocamlbuild -package llvm test.native

clean:
	rm -rf _build/
