#!/usr/bin/env bash

cd ../c
gcc wordcount.c -o wordcount -O3 -Wall

cd ../java
javac WordCountBaseline.java
javac -cp .:trove-3.0.3.jar WordCountOptimized.java

cd ../javascript
npm install

cd ../typescript
npm install --unsafe-perm

cd ../csharp
mcs WordCount.cs
