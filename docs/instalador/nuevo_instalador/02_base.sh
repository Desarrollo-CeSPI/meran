#!/bin/bash

#Crear bdd

echo "Creando la base de Datos..."

sed s/reemplazarDATABASE/$(escaparVariable $BDD_MERAN)/g $sources_MERAN/permisosbdd.sql > /tmp/$ID.nuevabdd
sed s/reemplazarUSER/$(escaparVariable $USER_BDD_MERAN)/g /tmp/$ID.nuevabdd > /tmp/$ID.permisosbdd2
sed s/reemplazarPASS/$(escaparVariable $PASS_BDD_MERAN)/g /tmp/$ID.permisosbdd2 > /tmp/$ID.permisosbdd3
sed s/reemplazarHOST/$(escaparVariable $HOST_BDD_MERAN)/g /tmp/$ID.permisosbdd3 > /tmp/$ID.permisosbdd2
sed s/reemplazarIUSER/$(escaparVariable $IUSER_BDD_MERAN)/g /tmp/$ID.permisosbdd2 > /tmp/$ID.permisosbdd3
sed s/reemplazarIPASS/$(escaparVariable $IPASS_BDD_MERAN)/g /tmp/$ID.permisosbdd3 > /tmp/$ID.permisosbdd2

head -n3 /tmp/$ID.permisosbdd2 > /tmp/$ID.nuevabdd
cat $sources_MERAN/base.sql >>  /tmp/$ID.nuevabdd

sed s/reemplazarDATABASE/$(escaparVariable $BDD_MERAN)/g $sources_MERAN/updates.sql > /tmp/UPDATES_MERAN_SANDBOX.sql
cat /tmp/UPDATES_MERAN_SANDBOX.sql >>  /tmp/$ID.nuevabdd
tail -n2 /tmp/$ID.permisosbdd2 >> /tmp/$ID.nuevabdd

mysql -h$HOST_BDD_MERAN --default-character-set=utf8 -u$ROOT_USER_BASE --password=$ROOT_PASS_BASE < /tmp/$ID.nuevabdd

rm -rf ~/instalacion_meran
mkdir ~/instalacion_meran
mv /tmp/$ID.nuevabdd ~/instalacion_meran/