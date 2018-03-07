#!/bin/bash

actualizarBDD()
{
   echo "Tenemos que ACTUALIZAR la base de datos $DD_MERAN y para eso pediremos los permisos de root de MySQL"
   sed s/reemplazarDATABASE/$(escaparVariable $BDD_MERAN)/g $sources_MERAN/updates.sql > /tmp/UPDATES_MERAN_SANDBOX.sql
   mysql -h$HOST_BDD_MERAN --default-character-set=utf8 -u$ROOT_USER_BASE --password=$ROOT_PASS_BASE < /tmp/UPDATES_MERAN_SANDBOX.sql
   if [ $? -ne 0 ]
	then
		echo 'No fue posible conecatarse a la base de datos con los datos suministrados'
		mkdir ~/pendiente
		mv /tmp/UPDATES_MERAN_SANDBOX.sql ~/pendiente/
		echo 'Luego debe aplicar el sql que esta en ~/pendiente/UPDATES_MERAN_SANDBOX.sql para actualizar su base de datos'
	else
		echo 'Base de datos actualizada con exito'
   fi
   if [ $CONSERVE_SQL -eq 0 ]
	then
		rm /tmp/UPDATES_MERAN_SANDBOX.sql
	else
		mv /tmp/UPDATES_MERAN_SANDBOX.sql ~/pendiente/
   fi
}


generarPermisosBDD()
{
  sed s/reemplazarDATABASE/$(escaparVariable $BDD_MERAN)/g $sources_MERAN/permisosbdd.sql > /tmp/$ID.permisosbdd
  sed s/reemplazarUSER/$(escaparVariable $USER_BDD_MERAN)/g /tmp/$ID.permisosbdd > /tmp/$ID.permisosbdd2
  sed s/reemplazarPASS/$(escaparVariable $PASS_BDD_MERAN)/g /tmp/$ID.permisosbdd2 > /tmp/$ID.permisosbdd3
  sed s/reemplazarHOST/$(escaparVariable $DBB_USER_ORIGEN)/g /tmp/$ID.permisosbdd3 > /tmp/$ID.permisosbdd2
  sed s/reemplazarIUSER/$(escaparVariable $IUSER_BDD_MERAN)/g /tmp/$ID.permisosbdd2 > /tmp/$ID.permisosbdd3
  sed s/reemplazarIPASS/$(escaparVariable $IPASS_BDD_MERAN)/g /tmp/$ID.permisosbdd3 > /tmp/$ID.permisosbdd2
  head -n3 /tmp/$ID.permisosbdd2 > /tmp/$ID.permisosbdd
  cat $sources_MERAN/base.sql >>  /tmp/$ID.permisosbdd
  tail -n2 /tmp/$ID.permisosbdd2 >> /tmp/$ID.permisosbdd
  echo "Creando la base de Datos..."
  mysql -h$HOST_BDD_MERAN --default-character-set=utf8 -u$ROOT_USER_BASE --password=$ROOT_PASS_BASE < /tmp/$ID.permisosbdd
  if [ $? -ne 0 ]
	then
		echo 'No fue posible conecatarse a la base de datos con los datos suministrados'
		mkdir ~/pendiente
		mv /tmp/$ID.permisosbdd ~/pendiente/
		echo 'Luego debe aplicar el sql que esta en ~/pendiente/'$ID'.permisosbdd para crear su base de datos'
	else
		echo 'Base de datos creada con exito'
	fi
 if [ $CONSERVE_SQL -eq 1 ]
	then
		mv /tmp/$ID.permisosbdd ~/pendiente/base.sql
	fi
 rm /tmp/$ID.permisosbdd*
}

generarConfiguracion()
{
  sed s/reemplazarID/$(escaparVariable $ID)/g $sources_MERAN/meran.conf > /tmp/$ID.meran.conf
  sed s/reemplazarUSER/$(escaparVariable $USER_BDD_MERAN)/g /tmp/$ID.meran.conf > /tmp/$ID.meran2.conf
  sed s/reemplazarPASS/$(escaparVariable $PASS_BDD_MERAN)/g /tmp/$ID.meran2.conf > /tmp/$ID.meran.conf
  sed s/reemplazarPATHBASE/$(escaparVariable $DESTINO_MERAN)/g  /tmp/$ID.meran.conf > /tmp/$ID.meran2.conf
  sed s/reemplazarCONFMERAN/$(escaparVariable $CONFIGURACION_MERAN)/g /tmp/$ID.meran2.conf > /tmp/$ID.meran3.conf
  sed s/reemplazarBDDHOST/$(escaparVariable  $HOST_BDD_MERAN)/g /tmp/$ID.meran3.conf > /tmp/$ID.meran2.conf
  sed s/reemplazarDATABASE/$(escaparVariable $BDD_MERAN)/g /tmp/$ID.meran2.conf > $CONFIGURACION_MERAN/meran$ID.conf
  rm /tmp/$ID.meran*
  generarScriptDeInicio
}
