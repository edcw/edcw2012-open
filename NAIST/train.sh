#!/bin/sh

# $1: $B3X=,<T%3!<%Q%9!J3X=,<T$N=q$$$?J8$H$=$N@52rJ8$NBP$G$=$l$>$lJL%U%!%$%k$G=`Hw!K!!3HD%;R$J$7!!!J3X=,<T$N=q$$$?J8$N3HD%;R$r(B.incor $B@52rJ8$N3HD%;R$r(B.corr$B$K$7$F$*$/I,MW$,$"$k!K(B
# $2: $B8@8l%b%G%k$N%U%!%$%k$r@dBP%Q%9$G;XDj(B

/usr/local/src/moses/scripts/training/train-model.perl -scripts-root-dir /usr/local/src/moses/scripts -corpus $1 -f incor -e corr -alignment grow-diag-final-and -reordering msd-bidirectional-fe -lm 0:3:$2:0
