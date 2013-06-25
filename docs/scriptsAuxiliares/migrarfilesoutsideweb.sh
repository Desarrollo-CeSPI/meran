#!/bin/bash
if [ $# -eq 2] then
	ORIGEN=$1
	DESTINO=$2
	cp -a $ORIGEN/opac-tmpl/uploads/portada $DESTINO/files/opac/uploads 
else
	echo "Necesito dos parametro: origen (/tmp/meran) y destino(/usr/share/meran)"
fi

