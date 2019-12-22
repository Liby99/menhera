OCAMLBUILD = @ ocamlbuild
OCAMLFLAGS = -use-ocamlfind -use-menhir
OCAMLTESTFLAGS = -I src/ -package oUnit
MV = @ mv
RM = @ rm -rf

all:
	$(OCAMLBUILD) $(OCAMLFLAGS) src/main.native
	$(MV) main.native menhera

test:
	$(OCAMLBUILD) $(OCAMLFLAGS) $(OCAMLTESTFLAGS) tests/test.native
	$(MV) test.native test

format:
	ls src/*.ml | xargs -I '{}' ocamlformat '{}' --output '{}'

clean:
	$(RM) _build
	$(RM) test
	$(RM) menhera