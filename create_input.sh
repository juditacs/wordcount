#!/usr/bin/env bash

wget http://hlt.sztaki.hu/resources/corp/romanian.tok.gz data/
zcat data/romanian.tok.gz | grep -v ^DOC | head -1000 > data/romanian_1000.txt
zcat data/romanian.tok.gz | grep -v ^DOC | head -100000 | gzip > data/romanian_100k.gz
zcat data/romanian.tok.gz | grep -v ^DOC | head -1000000 | gzip > data/romanian_1M.gz
