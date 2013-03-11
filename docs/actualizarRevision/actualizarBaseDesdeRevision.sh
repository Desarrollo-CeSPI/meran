#!/bin/sh
if [ $# -lt 1 ]
then
echo "FALLO 1 Utiliza: $(basename $0) REV_ANTERIOR BACKUP ARCHIVO_CONF DIRECTORIO_REPO_GIT "
echo "DEFAULT: ARCHIVO_CONF ==> /etc/meran/meran.conf "
echo "DEFAULT: DIRECTORIO_REPO_GIT ==> /usr/share/meran "
exit 1
fi
#Tomamos los defaults

if [ $2 ] 
then
    BACKUP=$2
else
    BACKUP=0
fi

echo "BACKUP= $BACKUP"
if [ $3 ] 
then
    ARCHIVO_CONF=$3
else
    ARCHIVO_CONF=/etc/meran/meran.conf
fi
echo "ARCHIVO_CONF= $ARCHIVO_CONF"
if [ $4 ] 
then
    DIRECTORIO_REPO_GIT=$4
else
    DIRECTORIO_REPO_GIT=/usr/share/meran
fi
echo "DIRECTORIO_REPO_GIT= $DIRECTORIO_REPO_GIT"

echo "Estamos verificando si es necesario aplicar cambios en la base";
echo "En caso de serlo es recomendable que realice un BACKUP de su base previamente";

BASE=$(grep ^database= $ARCHIVO_CONF| awk '{split($0,a,"="); print a[2]}') 
PASSWD=$(grep ^pass= $ARCHIVO_CONF| awk '{split($0,a,"="); print a[2]}') 
USER=$(grep ^user= $ARCHIVO_CONF| awk '{split($0,a,"="); print a[2]}') 

if [ $BACKUP -eq 1 ]; then
    echo "Backupeando base";
    mysqldump --default-character-set=utf8 $BASE -u$USER -p$PASSWD > ~/backup_base_`date +%mx%dx%y`.sql;
else
    echo "NO SE HACE BACKUP!! (Inconsciente!!!)";
fi;


for revision in $(git --git-dir=$DIRECTORIO_REPO_GIT/.git/ rev-list $1..master | tac); do
          if [ -e $DIRECTORIO_REPO_GIT/docs/sqlUPDATES/$revision.sql ]; then
                echo "---------------------------------------------------------------------------------------------------------------"
                echo "Aplicando actualización ==>  $revision.sql";
                    mysql --default-character-set=utf8 $BASE -u$USER -p$PASSWD < $DIRECTORIO_REPO_GIT/docs/sqlUPDATES/$revision.sql
                echo "---------------------------------------------------------------------------------------------------------------"
          else
                 echo "NO HAY SQL PARA LA REVISION: $revision";
          fi;
done;
