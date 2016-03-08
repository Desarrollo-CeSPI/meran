#!/bin/bash

rm -rf dump
mkdir dump
 
for f in *.DB; do
 NAME="${f%.*}"
 echo "PROCESANDO $NAME..."
 pxview --sql --short-insert --blobfile=$NAME.MB --blobprefix=$NAME.PX --delete-table --tablename=$NAME $NAME.DB |  iconv -f cp1250 -t utf8 | tr 'ßńÃ'  'áñABCDEFGHÑ' > dump/$NAME.sql
done

rm -rf *.blob
