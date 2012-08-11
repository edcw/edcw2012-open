#!/bin/sh

# $1: test data

rm -rf fil
/usr/local/src/moses/scripts/training/filter-model-given-input.pl ./fil ./model/moses.ini $1
/usr/local/bin/moses -config ./fil/moses.ini -input-file $res > $1.res
