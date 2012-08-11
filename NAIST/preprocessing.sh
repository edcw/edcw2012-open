#!/bin/sh

/usr/local/src/moses/scripts/tokenizer/tokenizer.perl < $1 > $1.tok
/usr/local/src/moses/scripts/tokenizer/lowercase.perl < $1.tok > $1.tok.low
