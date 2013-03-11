#!/bin/sh
pathRelativo=$(dirname $0)
contador=$(cat $pathRelativo/revision)
touch $pathRelativo/sql.rev$(($contador+1))
echo $(($contador+1)) > $pathRelativo/revision
echo "Tenes que editar $pathRelativo/sql.rev$(($contador+1)) y agregar todos los cambios que le hiciste a la base de datos"
echo "Ahora subimos para reservar el nro de revision"
cd $pathRelativo/../../
git add $OLDPWD/$pathRelativo/sql.rev$(($contador+1))
git ci "mensaje automatico generado para el sql.rev$(($contador+1))"
git up
git push
echo "Quiere editarlo automaticamente?(s/n). Los cambios una vez q termine se enviaran al servidor"
read pregunta
if [ "$pregunta" = "s" ] || [ "$pregunta" = "S" ]; then
    vim $OLDPWD/$pathRelativo/sql.rev$(($contador+1))
    git ci "mensaje automatico generado con el sql.rev$(($contador+1)) completo"
    git up
    git push
fi
cd $OLDPWD
