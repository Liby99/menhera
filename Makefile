menhera:
	@ make -C src/
	@ mv src/menhera .

clean:
	@ make -C src/ clean
	@ rm menhera
