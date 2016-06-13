#!/usr/bin/env bash

cd cpp
g++ wordcount_baseline.cpp -std=c++11 -o wordcount_baseline -O3
g++ wordcount.cpp -std=c++11 -o wordcount -O3
clang++-3.6 wordcount.cpp -std=c++11 -o wordcount_clang -O3

cd ../c
gcc wordcount.c -o wordcount -O3 -Wall
clang-3.6 -O3 -Wall -march=native -std=gnu99 wordcount_opt.c -o wordcount_opt

cd ../clojure
if [ ! -f ../clojure.jar ]; then
    wget https://oss.sonatype.org/content/repositories/snapshots/org/clojure/clojure/1.9.0-master-SNAPSHOT/clojure-1.9.0-master-20160119.195127-1.jar \
    -O ../clojure.jar
    chmod a+rx ../clojure.jar
fi

cd ../d
dmd -O -release -inline -boundscheck=off wordcount.d

cd ../elixir
MIX_ENV=prod mix escript.build > /dev/null

cd ../java
javac WordCountBaseline.java
javac -cp .:trove-3.0.3.jar WordCountOptimized.java

cd ../javascript
npm install

cd ../typescript
npm install --unsafe-perm

cd ../go
export GOPATH=$(pwd)
go install wordcount

cd ../csharp
mcs WordCount.cs

cd ../haskell
cabal install --verbose=0 --dry-run
RETURNCODE=$?
# Update if we have not already
if [ "$RETURNCODE" -ne "0" ]; then 
    cabal update 
fi
cabal install --verbose=0
cp dist/build/WordCount/WordCount .

cd ../rust/wordcount
cargo build --release
cp target/release/wordcount .
cd ..

cd ../scala
scalac Wordcount.scala