# For scripted languages it might be unnecessary to change anything except the line below `run:`
# Please keep in mind, that whatever you do, <TAB> characters need to stay intact!

build:
	GOPATH=$(realpath .) go install wordcount

clean:
	rm -rf bin

rebuild: clean build

run:
	./go/bin/wordcount
