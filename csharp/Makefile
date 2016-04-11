# For scripted languages it might be unnecessary to change anything except the line below `run:`
# Please keep in mind, that whatever you do, <TAB> characters need to stay intact!

build: WordCount.exe

clean:
	rm -f WordCount.exe

rebuild: clean build

run:
	mono WordCount.exe

WordCount.exe: WordCount.cs
	mcs $<
