#!/bin/bash
if [ $# -eq 2] then
	ORIGEN=$1
	DESTINO=$2
	cp -a $ORIGEN/opac-tmpl/uploads/portada $DESTINO/files/opac/uploads 
	cp -a $ORIGEN/opac-tmpl/temas/DEO/imagenes $DESTINO/files/intranet/private-uploads/logos
else
	echo "Necesito dos parametro: origen (/tmp/meran) y destino(/usr/share/meran)"
fi

