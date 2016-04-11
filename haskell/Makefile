# For scripted languages it might be unnecessary to change anything except the line below `run:`
# Please keep in mind, that whatever you do, <TAB> characters need to stay intact!

build: wordcount                                                            

clean:
	rm -f wordcount
	rm -rf dist

rebuild: clean build

run:
	./wordcount # command to start your version





wordcount: dist/build/WordCount/WordCount
	ln $< $@

dist/build/WordCount/WordCount:
	cabal install --verbose=0
