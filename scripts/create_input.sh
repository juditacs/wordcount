#!/usr/bin/env bash

wget http://dumps.wikimedia.org/huwikisource/latest/huwikisource-latest-pages-meta-current.xml.bz2
mv huwikisource-latest-pages-meta-current.xml.bz2 data
cd data
bunzip2 huwikisource-latest-pages-meta-current.xml.bz2
