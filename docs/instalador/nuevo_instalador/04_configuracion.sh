#!/bin/bash

#Generamos configuracion
sed s/reemplazarID/$(escaparVariable $ID)/g $sources_MERAN/meran.conf > /tmp/$ID.meran.conf
sed s/reemplazarUSER/$(escaparVariable $USER_BDD_MERAN)/g /tmp/$ID.meran.conf > /tmp/$ID.meran2.conf
sed s/reemplazarPASS/$(escaparVariable $PASS_BDD_MERAN)/g /tmp/$ID.meran2.conf > /tmp/$ID.meran.conf
sed s/reemplazarPATHBASE/$(escaparVariable $DESTINO_MERAN)/g  /tmp/$ID.meran.conf > /tmp/$ID.meran2.conf
sed s/reemplazarCONFMERAN/$(escaparVariable $CONFIGURACION_MERAN)/g /tmp/$ID.meran2.conf > /tmp/$ID.meran3.conf
sed s/reemplazarBDDHOST/$(escaparVariable  $HOST_BDD_MERAN)/g /tmp/$ID.meran3.conf > /tmp/$ID.meran2.conf
sed s/reemplazarDATABASE/$(escaparVariable $BDD_MERAN)/g /tmp/$ID.meran2.conf > $CONFIGURACION_MERAN/meran$ID.conf
rm /tmp/$ID.meran*

#Scripts de inicio
sed s/reemplazarID/$(escaparVariable $ID)/g $sources_MERAN/iniciando.pl > /tmp/iniciando$ID.pl2
sed s/reemplazarCONFMERAN/$(escaparVariable $CONFIGURACION_MERAN)/g /tmp/iniciando$ID.pl2 > /tmp/iniciando$ID.pl
sed s/reemplazarPATHBASE/$(escaparVariable $DESTINO_MERAN)/g  /tmp/iniciando$ID.pl > $CONFIGURACION_MERAN/iniciando$ID.pl
rm /tmp/iniciando$ID.pl