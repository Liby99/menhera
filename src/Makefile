OCAMLBUILD = @ ocamlbuild
RM = @ rm -rf
MV = @ mv

DIRECTORIES = -Is core,ast,parser,compiler,runner,util
LLVM_FLAGS = -package llvm -package llvm.analysis -package llvm.executionengine
MENHIR_FLAGS = -use-menhir
FLAGS = $(MENHIR_FLAGS) $(LLVM_FLAGS) $(DIRECTORIES)

menhera: ast/*.ml compiler/*.ml core/*.ml parser/*.ml* runner/*.ml
	$(OCAMLBUILD) $(FLAGS) menhera.native
	$(MV) menhera.native menhera

clean:
	$(OCAMLBUILD) -clean
