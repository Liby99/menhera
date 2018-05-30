all:
	mkdir -p ../build/
	ocamlbuild -I compiler/ -I compiler/grammer -build-dir ../build/ -use-menhir menhera.native
	mv ../build/compiler/menhera.native ../menhera

clean:
	ocamlbuild -I src/compiler/ -build-dir build/ -clean
	rm menhera
