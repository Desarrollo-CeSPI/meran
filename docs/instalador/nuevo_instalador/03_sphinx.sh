#!/bin/bash

# Setear que arranque con la máquina
echo "START=yes" > /etc/default/sphinxsearch

# Copiar configuración y setear variables

sed s/reemplazarID/$(escaparVariable $ID)/g ${PWD}/sphinx.conf > /tmp/$ID.sphix.conf
sed s/reemplazarIUSER/$(escaparVariable  $IUSER_BDD_MERAN)/g /tmp/$ID.sphix.conf > /tmp/$ID.sphix2.conf
sed s/reemplazarIPASS/$(escaparVariable $IPASS_BDD_MERAN)/g /tmp/$ID.sphix2.conf > /tmp/$ID.sphix.conf
sed s/reemplazarBDDHOST/$(escaparVariable  $HOST_BDD_MERAN)/g /tmp/$ID.sphix.conf > /tmp/$ID.sphix2.conf
sed s/reemplazarDATABASE/$(escaparVariable $BDD_MERAN)/g /tmp/$ID.sphix2.conf > /etc/sphinxsearch/sphinx.conf
rm /tmp/$ID.sphix*

service sphinxsearch restart


echo "Ahora el Sphinx"
if [ $(netstat -natp |grep searchd |grep 9312|wc -l) -gt 0 ]
then
  echo "Sphinx ya esta corriendo vas a tener que combinar a mano el archivo de configuracion y generar los indices"
  echo "El archivo generado que tiene que andar es el /etc/sphinxsearch/sphinx.conf "
else
  echo "Como Sphinx no estaba ejecutándose lo vamos a hacer ahora"
  indexer --all --rotate
  searchd
fi