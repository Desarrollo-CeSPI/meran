#!/bin/bash

rm -rf dump
mkdir dump
 
for f in *.DB; do
 NAME="${f%.*}"
 echo "PROCESANDO $NAME..."
 pxsqldump -d mysql -f $NAME.DB  -b $NAME.MB -n $NAME |  iconv -f cp1250 -t utf8 | tr 'ßńÃ'  'áñABCDEFGHÑ' > dump/$NAME.sql
done
