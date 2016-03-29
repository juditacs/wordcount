build: wordcount

clean:
	@rm -f wordcount

rebuild: clean build

run:
	./wordcount # command to start your version


wordcount: wordcount.c
	gcc $< -o $@ -O3 -Wall
