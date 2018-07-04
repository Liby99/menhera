all:
	ocamlbuild -use-menhir -package llvm mini_menhera.native
	mv mini_menhera.native mini_menhera

clean:
	rm -rf _build/
