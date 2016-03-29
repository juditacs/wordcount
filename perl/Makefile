# For scripted languages it might be unnecessary to change anything except the line below `run:`
# Please keep in mind, that whatever you do, <TAB> characters need to stay intact!

build: wordcount

clean:
	rm -f wordcount

rebuild: clean build

run:
	./wordcount # command to start your version

wordcount: wordcount.pl
	ln $< $@
