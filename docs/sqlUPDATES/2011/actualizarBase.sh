#!/bin/sh
CONF=$1;
if [ $# -eq 0 ]; then
        	echo "Falta pasar por parametro el archivo de configuracion"; 
		echo "Se va a utilizar el archivo por defecto /etc/meran/meran.conf";
		CONF="/etc/meran/meran.conf";
		
	fi;
if [ ! -e $CONF ]; then
		echo "no existe el archivo $CONF. ABORTANDO!!!!";
		exit;
	fi;
REVISIONLOCAL=$(grep ^revisionLocal $CONF| awk '{split($0,a,"="); print a[2]}')
echo "REVISIONLOCAL $REVISIONLOCAL";
if [ "$REVISIONLOCAL" = "" ]; then
        	echo "Falta definir la variable en el archivo de configuracion"; 
		echo "Se utiliza por defecto /etc/meran/revisionLocal";
		REVISIONLOCAL="/etc/meran/revisionLocal";
	fi;
if [ ! -e $REVISIONLOCAL ]; then
		echo "no existe el archivo $REVISIONLOCAL. ABORTANDO!!!!";
		exit;
	fi;
BASE=$(grep ^database $CONF| awk '{split($0,a,"="); print a[2]}')
PASSWD=$(grep ^passINTRA $CONF| awk '{split($0,a,"="); print a[2]}')
USER=$(grep ^userINTRA $CONF| awk '{split($0,a,"="); print a[2]}')
#echo $BASE;
#echo $PASSWD;
#echo $USER;
#echo $REVISIONLOCAL;
pathRelativo=$(dirname $0)

if [ ! -f $REVISIONLOCAL ]; then
    echo 0 > $REVISIONLOCAL
fi
anterior=$(($(cat $REVISIONLOCAL)+1))
echo "Estamos verificando si es necesario aplicar cambios en la base";
echo "En caso de serlo es recomendable que realice un BACKUP de su base previamente";
hasta=$(cat $pathRelativo/revision)
if [ $2 ]
then
	echo "Backupeando base en el directorio home del usuario $(whoami)"
	mysqldump --default-character-set=utf8 $BASE -u$USER -p$PASSWD > ~/backup_base.sql.rev$anterior;
fi


for i in `seq $anterior $hasta`; do
        echo $pathRelativo/sql.rev$i;
        if [ -e $pathRelativo/sql.rev$i ]; then
            echo "Aplicando sql.rev$i";
            mysql --default-character-set=utf8 $BASE -u$USER -p$PASSWD < $pathRelativo/sql.rev$i;
        fi;
done;
echo $hasta > $REVISIONLOCAL
