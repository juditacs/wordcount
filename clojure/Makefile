build: | clojure.jar

clean:
	rm -f clojure.jar

run:
	java -cp clojure.jar clojure.main wordcount.clj

rebuild: clean build



clojure.jar:
	wget "https://oss.sonatype.org/content/repositories/snapshots/org/clojure/clojure/1.9.0-master-SNAPSHOT/clojure-1.9.0-master-20160119.195127-1.jar" -O $@
