#!/usr/bin/env bash

cd cpp
g++ wordcount_map.cpp -std=c++11 -o wc_baseline
g++ wordcount_hashtable.cpp -std=c++11 -o wc_baseline_hash
g++ wordcount_hashtable_nosync_stdio.cpp -std=c++11 -o wc_hash_nosync
g++ wordcount_vector.cpp -std=c++11 -o wc_vector

cd ../java
javac WordCount.java
javac WordCountEntries.java

cd ../javascript
npm install

echo "export PYTHONIOENCODING=\"utf-8\"" >> ~/.bashrc
