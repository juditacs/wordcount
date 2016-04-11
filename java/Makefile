# For scripted languages it might be unnecessary to change anything except the line below `run:`
# Please keep in mind, that whatever you do, <TAB> characters need to stay intact!

build: WordCount.class

clean:
	rm -f WordCount.class

rebuild: clean build

run:
	java WordCount

WordCount.class: WordCount.java
	javac $<
