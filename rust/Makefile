# For scripted languages it might be unnecessary to change anything except the line below `run:`
# Please keep in mind, that whatever you do, <TAB> characters need to stay intact!

build: wordcount/wordcount

clean:
	rm -f wordcount/wordcount
	rm -rf wordcount/target

rebuild: clean build

run:
	./wordcount/wordcount # command to start your version


wordcount/wordcount: wordcount/target/release/wordcount
	ln $< $@

wordcount/target/release/wordcount:
	cd wordcount && cargo build --release
