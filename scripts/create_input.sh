#!/usr/bin/env bash

wget http://avalon.aut.bme.hu/~judit/files/romanian_1M.gz
mv romanian_1M.gz data/
zcat data/romanian_1M.gz | head -100000 | gzip > data/romanian_100k.gz
