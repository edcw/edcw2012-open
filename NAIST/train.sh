#!/bin/sh

# $1: 学習者コーパス（学習者の書いた文とその正解文の対でそれぞれ別ファイルで準備）　拡張子なし　（学習者の書いた文の拡張子を.incor 正解文の拡張子を.corrにしておく必要がある）
# $2: 言語モデルのファイルを絶対パスで指定

/usr/local/src/moses/scripts/training/train-model.perl -scripts-root-dir /usr/local/src/moses/scripts -corpus $1 -f incor -e corr -alignment grow-diag-final-and -reordering msd-bidirectional-fe -lm 0:3:$2:0
