#!/bin/sh

# $1 言語モデルに使うファイルを指定

ngram-count -order 3 -interpolate -kndiscount -text $1 -lm $1.lm
