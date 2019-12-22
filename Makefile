OCAMLBUILD = @ ocamlbuild
OCAMLFLAGS = -use-ocamlfind -use-menhir
OCAMLTESTFLAGS = -I src/ -package oUnit
MV = @ mv
RM = @ rm -rf
LS = @ ls

MENHERA_FILES = $(shell find src/ -type f -name '*.ml*')
TEST_FILES = $(shell find tests/ -type f -name '*.ml')

menhera: $(MENHERA_FILES)
	$(OCAMLBUILD) $(OCAMLFLAGS) src/main.native
	$(MV) main.native menhera

test: $(MENHERA_FILES) $(TEST_FILES)
	$(OCAMLBUILD) $(OCAMLFLAGS) $(OCAMLTESTFLAGS) tests/test.native
	$(MV) test.native test

format:
	$(LS) src/*.ml tests/*.ml | xargs -I '{}' ocamlformat '{}' --output '{}'

clean:
	$(OCAMLBUILD) -clean