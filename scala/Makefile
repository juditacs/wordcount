# For scripted languages it might be unnecessary to change anything except the line below `run:`
# Please keep in mind, that whatever you do, <TAB> characters need to stay intact!

build: Wordcount.class

clean:
	rm -f Wordcount*.class

rebuild: clean build

run:
	scala -J-Xmx2g Wordcount

Wordcount%.class: Wordcount.class

Wordcount.class: Wordcount.scala
	scalac $<
