#!/bin/bash
for i in $(find -name *.pl); do
	echo "#!/usr/bin/perl" > /tmp/auxiliar
	LANG=es_ES.iso88591 cat docs/generacionInstalador/licencia.txt >> /tmp/auxiliar

#	Sin comentarios
#	LANG=es_ES.iso88591 sed s/^#.*//g $i >> /tmp/auxiliar

#	Con comentarios
	LANG=es_ES.iso88591 cat $i >> /tmp/auxiliar

#	Sin lineas en blanco
#	LANG=es_ES.iso88591 sed '/^$/d' /tmp/auxiliar > $i

#	Con lineas en blanco
	LANG=es_ES.iso88591 cat /tmp/auxiliar > $i
	chmod +x $i
done;
for i in $(find -name *.pm); do
	LANG=es_ES.iso88591 cat docs/generacionInstalador/licencia.txt > /tmp/auxiliar

#	Sin comentarios
#	LANG=es_ES.iso88591 sed s/^#.*//g $i >> /tmp/auxiliar

#	Con comentarios
	LANG=es_ES.iso88591 cat $i >> /tmp/auxiliar

#	Sin lineas en blanco
#	LANG=es_ES.iso88591 sed '/^$/d' /tmp/auxiliar > $i

#	Con lineas en blanco
	LANG=es_ES.iso88591 cat /tmp/auxiliar > $i

done;