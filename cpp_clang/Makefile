build: wordcount

clean:
	rm -f wordcount

run:
	./wordcount

rebuild: clean build



wordcount: ../cpp/wordcount.cpp
	clang++-3.6 $< -std=c++11 -o $@ -O3
