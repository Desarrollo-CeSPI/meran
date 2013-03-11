#!/bin/sh
if [ $# -ne 3 ]
then
echo "FALLO 1 Utiliza: $(basename $0) revision_instalada revision_actual directorio_donde_esta_la_instalacion_de_meran "
exit 1
fi
echo "Estamos verificando si es necesario aplicar cambios en la base";
echo "En caso de serlo es recomendable que realice un BACKUP de su base previamente";
BASE=$(grep ^database /etc/meran/meran.conf| awk '{split($0,a,"="); print a[2]}') 
PASSWD=$(grep ^pass /etc/meran/meran.conf| awk '{split($0,a,"="); print a[2]}') 
USER=$(grep ^user /etc/meran/meran.conf| awk '{split($0,a,"="); print a[2]}') 
#echo $BASE
#echo $PASSWD
#echo $USER
echo "Backupeando base";
mysqldump --default-character-set=utf8 $BASE -u$USER -p$PASSWD > ~/backup_base.sql.rev$2;
REVISIONES_ARRAY=$(tac $1/revisiones_array) #lo recorremos al revez
OK=0
for revision in "$REVISIONES_ARRAY"; do
        if ["$revision"== $1 ]; then OK=1; #se encuentra la revision anterior, se aplica de ahi para adelante
        if OK then
          if [ -e $3/docs/sqlUPDATES/$revision.sql ]; then
                echo "Aplicando sql.rev$revision";
                mysql --default-character-set=utf8 $BASE -u$USER -p$PASSWD < $3/docs/sqlUPDATES/$revision.sql;
          fi;
        fi;
done;
