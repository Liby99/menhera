all:
	@npm run build --silent
	@cp script/menhera.js ./menhera
	@chmod +x ./menhera

install:
	@npm install

clean:
	@rm -rf build/
	@rm -f menhera