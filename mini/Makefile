menhera:
	ocamlbuild -use-menhir -package llvm -package llvm.analysis -package llvm.executionengine menhera.native
	mv menhera.native menhera

fn_ptr:
	ocamlbuild -use-menhir -package llvm -package llvm.analysis -package llvm.executionengine laboratory/fn_ptr.native

unique:
	ocamlbuild -use-menhir -package llvm -package llvm.analysis -package llvm.executionengine laboratory/unique.native

clean:
	rm -rf _build/
