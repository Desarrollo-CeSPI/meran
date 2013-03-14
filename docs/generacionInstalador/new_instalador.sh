#!/bin/bash
rm -fr aux
mkdir aux
VERSION="0.9.4"
cp -a ../../opac/ ../../intranet/ ../../includes aux/
cd aux
for i in $(find -name *.pl); do
	echo "#!/usr/bin/perl" > /tmp/auxiliar
	LANG=es_ES.iso88591 cat ../licencia.txt >> /tmp/auxiliar
	LANG=es_ES.iso88591 sed s/^#.*//g $i >> /tmp/auxiliar
	LANG=es_ES.iso88591 sed '/^$/d' /tmp/auxiliar > $i
	chmod +x $i
done;
for i in $(find -name *.pm); do
	LANG=es_ES.iso88591 cat ../licencia.txt > /tmp/auxiliar
	LANG=es_ES.iso88591 sed s/^#.*//g $i >> /tmp/auxiliar
	LANG=es_ES.iso88591 sed '/^$/d' /tmp/auxiliar > $i
done;
mkdir meranunlp
cp ../../instalador/* meranunlp
rm meranunlp/intranetyopac.tar.gz
cp ../README ../COPYING licencia.txt meranunlp/
echo $VERSION > meranunlp/VERSION
tar -czvf meranunlp/intranetyopac.tar.gz opac/ intranet/ includes/
tar -czvf meranunlp-v$VERSION.tar.gz meranunlp
rm -fr meranunlp opac intranet includes

