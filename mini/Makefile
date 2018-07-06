all:
	ocamlbuild -use-menhir -package llvm -package llvm.analysis -package llvm.executionengine menhera.native
	mv menhera.native menhera

clean:
	rm -rf _build/
