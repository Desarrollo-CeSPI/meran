#!/bin/bash
version="$(head -n 1 VERSION)"
if [ $(uname -a|grep x86_64|wc -l) -gt 0 ];
  then 
     versionKernel=64;
  else
     versionKernel=32;
fi;

echo "Bienvenido al instalador de meran version $version para sistemas de $versionKernel bits" 
DEBIAN_VERSION=$(cat /etc/debian_version | cut -c1)  


escaparVariable()
{

echo $1 | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g'

}

ID=$1
sources_MERAN=$(dirname "${BASH_SOURCE[0]}")
DESTINO_MERAN="/usr/share/meran"
CONFIGURACION_MERAN="/etc/meran"
BDD_MERAN="meran"
USER_BDD_MERAN="meranadmin"
PASS_BDD_MERAN=`</dev/urandom tr -dc A-Za-z0-9 | head -c8`
IUSER_BDD_MERAN="indice"
IPASS_BDD_MERAN=`</dev/urandom tr -dc A-Za-z0-9 | head -c8`
HOST_BDD_MERAN="localhost"
ROOT_USER_BASE="root"
ROOT_PASS_BASE=""
DBB_USER_ORIGEN="localhost"

. ./01_dependencias.sh
. ./02_base.sh
. ./03_sphinx.sh
. ./04_configuracion.sh
. ./05_servidor_web.sh
. ./06_permisos.sh
