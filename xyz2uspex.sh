#!/usr/bin/env bash

#Requirements: Openbabel
#Usage: ./xyz2uspex.sh filename.xyz
#Author: Ankur Gupta, Lawrence Berkeley National Laboratory, 2022

filename="${1%.*}"
obabel $1 -O ${filename}_centered.xyz -c
obabel ${filename}_centered.xyz -O ${filename}.fh

tail -n+6 ${filename}.fh | awk '{printf "%3d %3d %3d %s\n", $2,$4,$6,"  0"}' > ${filename}_zmat.txt

sed -i -e "1s/^/  0   0   0   1\n  1   0   0   1\n  2   1   0   1\n/g" ${filename}_zmat.txt

tail -n+3 ${filename}_centered.xyz > ${filename}_temp.xyz

paste ${filename}_temp.xyz ${filename}_zmat.txt > ${filename}_uspex.txt

nl=$(cat ${filename}_uspex.txt | wc -l)

sed -i -r -e "1s/^/MOL: ${filename}\nNumber of atoms: ${nl}\n/g" ${filename}_uspex.txt 

rm ${filename}_centered.xyz
rm ${filename}.fh
rm ${filename}_zmat.txt
rm ${filename}_temp.xyz
