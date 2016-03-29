build: wordcount

clean:
	rm -f wordcount

run:
	./wordcount

rebuild: clean build



wordcount: wordcount.d
	dmd -O -release -inline -boundscheck=off wordcount.d
