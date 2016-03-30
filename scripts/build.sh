#!/usr/bin/env bash

cd cpp
g++ wordcount_baseline.cpp -std=c++11 -o wordcount_baseline -O3
g++ wordcount.cpp -std=c++11 -o wordcount -O3

cd ../elixir
# Elixir has to run the script to compile it (http://stackoverflow.com/questions/35722248/the-command-elixirc-is-compiling-and-executing-the-code)
echo "wadus" | elixir elixir/wordcount.ex > /dev/null

cd ../d
dmd -O -release -inline -boundscheck=off wordcount.d

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
mcs WordCountList.cs

cd ../haskell
cabal install --verbose=0
cp dist/build/WordCount/WordCount .

cd ../rust/wordcount
cargo build --release
cp target/release/wordcount .
cd ..

cd ../scala
scalac Wordcount.scala
