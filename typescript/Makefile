# For scripted languages it might be unnecessary to change anything except the line below `run:`
# Please keep in mind, that whatever you do, <TAB> characters need to stay intact!

build:
	npm install --unsafe-perm 

clean:
	rm -rf node_modules
	rm -rf typings
	rm -f wordcount.js

rebuild: clean build

run:
	nodejs wordcount.js
