all: build_tree_sitter_menhera
	npm run build --silent
	cp script/menhera.js ./menhera
	chmod +x ./menhera

update_submodule:
	git submodule update --recursive --remote

build_tree_sitter_menhera:
	make -C include/tree-sitter-menhera

install:
	npm install

clean:
	rm -rf build/
	rm -f menhera
