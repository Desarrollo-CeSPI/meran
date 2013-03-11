#!/bin/sh
#En este script vamos a aplicar todas las acciones necesarias para hacer la actualizacion de Meran
#Es necesario recibir dos parametros, el directorio donde esta nuestra instalacion y el tema que utilizaremos
echo "Vamos a actualizar el repositorio de codigo";
if [ $# -ne 2 ]
then
echo "FALLO  Utiliza: $(basename $0) directorio_donde_esta_la_instalacion_de_meran tema_de_la_instalacion"
exit 1
fi
DIR="$1"
TEMA="$2"
REVISION=$(cat $1/revision)
cd /tmp/
if [ -e codigo.tar.gz ]; then 
	rm codigo.tar.gz
fi
wget --user=instalacion --password=no_te_la_digo http://163.10.10.31/oculto2/codigo.tar.gz
tar xzf codigo.tar.gz
tar czf $1/../codigo`date +%mx%dx%y`.tar.gz $1
rm -fr $1
for i in $(ls codigo/opac/htdocs/opac-tmpl/temas/|grep -v $2);do
		rm  -fr codigo/opac/htdocs/opac-tmpl/temas/$i;
		done;
mv codigo $1
echo "Estan todos los archivos copiados"
echo "Configurando Permisos"
sh $1/docs/actualizarRevision/actualizarPermisos.sh $1
echo "Vamos a testear los  modulos"
perl $1/docs/actualizarRevision/chequearmodulos.pl 
REVISION_NUEVA=$(cat $1/revision)
echo "Actualizando desde $REVISION a $REVISION_NUEVA revisaremos BDD"
sh $1/docs/actualizarRevision/actualizarBase.sh $REVISION  $REVISION_NUEVA $DIR

