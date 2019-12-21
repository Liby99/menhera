OCAMLBUILD = @ ocamlbuild
OCAMLFLAGS = -use-ocamlfind -use-menhir
MV = @ mv
RM = @ rm -rf

all:
	$(OCAMLBUILD) $(OCAMLFLAGS) src/main.native
	$(MV) main.native menhera

format:
	ls src/*.ml | xargs -I '{}' ocamlformat '{}' --output '{}'

clean:
	$(OCAMLBUILD) clean