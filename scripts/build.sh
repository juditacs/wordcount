#!/usr/bin/env bash

cd cpp
g++ wordcount_baseline.cpp -std=c++11 -o wordcount_baseline -O3
g++ wordcount.cpp -std=c++11 -o wordcount -O3

cd ../c
gcc wordcount.c -o wordcount -O3 -Wall

cd ../java
javac WordCount.java

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
