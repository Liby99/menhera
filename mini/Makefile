OCAMLBUILD = @ ocamlbuild
RM = @ rm -rf
MV = @ mv

LLVM_FLAGS = -package llvm -package llvm.analysis -package llvm.executionengine
MENHIR_FLAGS = -use-menhir
FLAGS = $(MENHIR_FLAGS) $(LLVM_FLAGS)

menhera:
	$(OCAMLBUILD) $(FLAGS) menhera.native
	$(MV) menhera.native menhera

fn_ptr:
	$(OCAMLBUILD) $(FLAGS) laboratory/$@.native

clean:
	$(RM) _build/
