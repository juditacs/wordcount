build: wordcount

clean:
	rm -f wordcount

run:
	./wordcount

rebuild: clean build



wordcount: wordcount.cpp
	g++ wordcount.cpp -std=c++11 -o wordcount -O3
