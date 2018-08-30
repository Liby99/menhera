all: build_tree_sitter_menhera
	npm run build --silent
	cp script/menhera.js ./menhera
	chmod +x ./menhera

build_tree_sitter_menhera:
	make -C include/tree-sitter-menhera

install:
	npm install

clean:
	rm -rf build/
	rm -f menhera
