#!/usr/bin/env bash

wget http://dumps.wikimedia.org/huwiki/latest/huwiki-latest-pages-meta-current.xml.bz2
mv huwiki-latest-pages-meta-current.xml.bz2 data
cd data
bunzip2 huwiki-latest-pages-meta-current.xml.bz2
