OCAMLBUILD = @ ocamlbuild
OCAMLFLAGS = -use-menhir
MV = @ mv
RM = @ rm -rf

all:
	$(OCAMLBUILD) $(OCAMLFLAGS) src/main.native
	$(MV) main.native menhera

clean:
	$(RM) _build/
	$(RM) menhera