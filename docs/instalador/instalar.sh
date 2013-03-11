#!/bin/bash
version=0.4
if [ $(uname -a|grep amd64|wc -l) -gt 0 ];
  then 
     versionKernel=64;
  else
     versionKernel=32;
fi;
echo "Bienvenido al instalador de meran version $version para sistemas de $versionKernel bits" 

generarConfSphinx()
{
  sed s/reemplazarID/$(escaparVariable $ID)/g $sources_MERAN/sphinx.conf > /tmp/$ID.sphix.conf
  sed s/reemplazarIUSER/$(escaparVariable  $IUSER_BDD_MERAN)/g /tmp/$ID.sphix.conf > /tmp/$ID.sphix2.conf
  sed s/reemplazarIPASS/$(escaparVariable $IPASS_BDD_MERAN)/g /tmp/$ID.sphix2.conf > /tmp/$ID.sphix.conf
  sed s/reemplazarDATABASE/$(escaparVariable $BDD_MERAN)/g /tmp/$ID.sphix.conf > $DESTINO_MERAN/$ID/sphinx/etc/sphinx.conf
  rm /tmp/$ID.sphix*

}
generarLogRotate()
{
  sed s/reemplazarID/$(escaparVariable $ID)/g logrotate.d-meran > /etc/logrotate.d/logrotate.d-meran$ID
  #Logs de meran
  mkdir -p /var/log/meran/$ID
  
}

generarJaula()
{
  sed s/reemplazarPATHBASE/$(escaparVariable $DESTINO_MERAN)/g $sources_MERAN/apache-jaula-ssl > /tmp/$ID-apache-jaula-tmp2
 sed s/reemplazarCONFMERAN/$(escaparVariable $CONFIGURACION_MERAN)/g /tmp/$ID-apache-jaula-tmp2 > /tmp/$ID-apache-jaula-tmp
  sed s/reemplazarID/$(escaparVariable $ID)/g /tmp/$ID-apache-jaula-tmp > /etc/apache2/sites-available/$ID-apache-jaula-ssl
  sed s/reemplazarPATHBASE/$(escaparVariable $DESTINO_MERAN)/g $sources_MERAN/apache-jaula-opac > /tmp/$ID-apache-jaula-tmp2
 sed s/reemplazarCONFMERAN/$(escaparVariable $CONFIGURACION_MERAN)/g /tmp/$ID-apache-jaula-tmp2 > /tmp/$ID-apache-jaula-tmp
  sed s/reemplazarID/$(escaparVariable $ID)/g /tmp/$ID-apache-jaula-tmp > /etc/apache2/sites-available/$ID-apache-jaula-opac
  rm /tmp/$ID-apache-jaula-tmp
  #Generar certificado de apache
  echo "Generando el certificado de apache"
  mkdir -p /etc/apache2/ssl/$ID
  openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/apache2/ssl/$ID/apache.pem -out /etc/apache2/ssl/$ID/apache.pem
  a2ensite $ID-apache-jaula-ssl
  a2ensite $ID-apache-jaula-opac
}


actualizarBDD()
{
   echo "Tenemos que ACTUALIZAR la base de datos $DD_MERAN y para eso pediremos los permisos de root de MySQL"

   sed s/reemplazarDATABASE/$(escaparVariable $BDD_MERAN)/g $sources_MERAN/updates.sql > /tmp/UPDATES_MERAN_SANDBOX.sql
   mysql --default-character-set=utf8  -p < /tmp/UPDATES_MERAN_SANDBOX.sql
   rm /tmp/UPDATES_MERAN_SANDBOX.sql
}


generarPermisosBDD()
{
  head -n3 $sources_MERAN/permisosbdd.sql | sed s/reemplazarDATABASE/$(escaparVariable $BDD_MERAN)/g > /tmp/$ID.permisosbdd
  sed s/reemplazarUSER/$(escaparVariable $USER_BDD_MERAN)/g /tmp/$ID.permisosbdd > /tmp/$ID.permisosbdd2
  sed s/reemplazarPASS/$(escaparVariable $PASS_BDD_MERAN)/g /tmp/$ID.permisosbdd2 > /tmp/$ID.permisosbdd3
  cat $sources_MERAN/base.sql >>  /tmp/$ID.permisosbdd3
  tail -n1 $sources_MERAN/permisosbdd.sql | sed s/$(escaparVariable reemplazarDATABASE)/$BDD_MERAN/g > /tmp/$ID.permisosbdd4
  sed s/reemplazarIUSER/$(escaparVariable $IUSER_BDD_MERAN)/g /tmp/$ID.permisosbdd4 > /tmp/$ID.permisosbdd5
  sed s/reemplazarIPASS/$(escaparVariable $IPASS_BDD_MERAN)/g /tmp/$ID.permisosbdd5 >> /tmp/$ID.permisosbdd3

  echo "Creando la base de Datos..."
  echo "Tenemos que crear la base de datos $DD_MERAN y para eso pediremos los permisos de root de MySQL"
  mysql --default-character-set=utf8  -p < /tmp/$ID.permisosbdd3
  rm /tmp/$ID.permisosbdd*
}

generarConfiguracion()
{
  sed s/reemplazarID/$(escaparVariable $ID)/g $sources_MERAN/meran.conf > /tmp/$ID.meran.conf
  sed s/reemplazarUSER/$(escaparVariable $USER_BDD_MERAN)/g /tmp/$ID.meran.conf > /tmp/$ID.meran2.conf
  sed s/reemplazarPASS/$(escaparVariable $PASS_BDD_MERAN)/g /tmp/$ID.meran2.conf > /tmp/$ID.meran.conf
  sed s/reemplazarPATHBASE/$(escaparVariable $DESTINO_MERAN)/g  /tmp/$ID.meran.conf > /tmp/$ID.meran2.conf
  sed s/reemplazarCONFMERAN/$(escaparVariable $CONFIGURACION_MERAN)/g /tmp/$ID.meran2.conf > /tmp/$ID.meran3.conf
  sed s/reemplazarDATABASE/$(escaparVariable $BDD_MERAN)/g /tmp/$ID.meran3.conf > $CONFIGURACION_MERAN/meran$ID.conf
  rm /tmp/$ID.meran*
  generarScriptDeInicio
}

generarCrons()
{
 ADONDE=$DESTINO_MERAN/$ID/intranet/modules/C4
  crontab -l >/tmp/$ID.crontab
  echo "
  0 7 * * *      export PERL5LIB=$ADONDE/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10.1/:$ADONDE/Share/share/perl/5.10/:$ADONDE/C4/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10/:$ADONDE/Share/lib/perl5/; export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/recordatorio_prestamos_vto.pl 2>&1
  0 * * * *      export PERL5LIB=$ADONDE/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10.1/:$ADONDE/Share/share/perl/5.10/:$ADONDE/C4/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10/:$ADONDE/Share/lib/perl5/; export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/mail_prestamos_vencidos.pl  2>&1
  * * * * *      export PERL5LIB=$ADONDE/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10.1/:$ADONDE/Share/share/perl/5.10/:$ADONDE/C4/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10/:$ADONDE/Share/lib/perl5/; export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/procesarColaZ3950.pl  2>&1
  * * * * *      export PERL5LIB=$ADONDE/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10.1/:$ADONDE/Share/share/perl/5.10/:$ADONDE/C4/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10/:$ADONDE/Share/lib/perl5/; export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/reindexar.pl 2>&1
  0 0 * * *      export PERL5LIB=$ADONDE/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10.1/:$ADONDE/Share/share/perl/5.10/:$ADONDE/C4/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10/:$ADONDE/Share/lib/perl5/; export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/obtener_portadas_de_registros.pl  2>&1
  0 0 * * 6      export PERL5LIB=$ADONDE/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10.1/:$ADONDE/Share/share/perl/5.10/:$ADONDE/C4/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10/:$ADONDE/Share/lib/perl5/; export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/generar_indice.pl  2>&1" >>/tmp/$ID.crontab
  crontab /tmp/$ID.crontab

}

generarScriptDeInicio()
{  
 sed s/reemplazarID/$(escaparVariable $ID)/g $sources_MERAN/iniciando.pl > /tmp/iniciando$ID.pl2
 sed s/reemplazarCONFMERAN/$(escaparVariable $CONFIGURACION_MERAN)/g /tmp/iniciando$ID.pl2 > /tmp/iniciando$ID.pl
 sed s/reemplazarPATHBASE/$(escaparVariable $DESTINO_MERAN)/g  /tmp/iniciando$ID.pl > $CONFIGURACION_MERAN/iniciando$ID.pl
 rm /tmp/iniciando$ID.pl
}

descomprimirArchivos()
{
	echo "Procedemos a la instalación"
	echo "Descomprimiendo Intranet y Opac"
	tar xzf $sources_MERAN/intranetyopac.tar.gz -C $DESTINO_MERAN/$ID
	echo "Descomprimiendo las dependencias" 
	tar xzf $sources_MERAN/jaula$versionKernel.tar.gz -C $DESTINO_MERAN/$ID/intranet/modules/C4/
	echo "Descomprimiendo sphinxsearch" 
	tar xzf $sources_MERAN/sphinx$versionKernel.tar.gz -C $DESTINO_MERAN/$ID
      
}
cambiarPermisos()
{
      chown www-data:www-data -R $DESTINO_MERAN/$ID/opac/htdocs/uploads/ 
      chown www-data:www-data -R $DESTINO_MERAN/$ID/opac/htdocs/opac-tmpl/uploads/
      chown www-data:www-data -R $DESTINO_MERAN/$ID/intranet/htdocs/uploads
      chown www-data:www-data -R $DESTINO_MERAN/$ID/intranet/htdocs/private-uploads
      chown www-data:www-data -R /var/log/meran/$ID/


	
}
arrancarSphinx()
{
echo "Ahora el Sphinx"
      if [ $(netstat -natp |grep searchd |grep 9312|wc -l) -gt 0 ]
        then
          echo "Sphinx ya esta corriendo vas a tener que combinar a mano el archivo de configuracion y generar los indices"
          echo "El archivo generado que tiene que andar es el $DESTINO_MERAN/$ID/sphinx/etc/sphinx.conf "
        else
          echo "Como Sphinx no estaba ejecutándose lo vamos a hacer ahora"
          $DESTINO_MERAN/$ID/sphinx/bin/indexer -c $DESTINO_MERAN/$ID/sphinx/etc/sphinx.conf --all --rotate
          $DESTINO_MERAN/$ID/sphinx/bin/searchd -c $DESTINO_MERAN/$ID/sphinx/etc/sphinx.conf
      fi
}
usage()
{
cat << EOF
usage: $0 options

Este script necesita si o si el parametro -i que es el identificador de la instalación que se va a utilizar en todo el proceso.

OPTIONS:
   -h      Show this message
   -i      Identificador para esta instalación de meran. Este Identificador se va a utilizar en todo
   -d      Carpeta DESTINO donde se guardara meran. Por defecto /usr/share/meran
   -b      Base de datos a usar. Por Defecto va a ser meran
   -u      Usuario que se va a conectar a la base de datos. Por defecto meranadmin
   -p      Pass del usuario que se va a conectar a la base de dato. Por defecto sera un random
   -s      Usuario que se va a utilizar en el indice. Por defecto indice
   -w      Pass del usuario que se va a utilizar en el indice. Por defecto sera un random
   -c      directorio donde se guardará la configuracion de meran. Por defecto sera /etc/meran y el archivo de configuracion sera meran$ID.conf
EOF
}

escaparVariable()
{

echo $1 | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g'

}
ID=
sources_MERAN=$(dirname "${BASH_SOURCE[0]}")
DESTINO_MERAN="/usr/share/meran"
CONFIGURACION_MERAN="/etc/meran"
BDD_MERAN="meran"
USER_BDD_MERAN="kohaadmin"
PASS_BDD_MERAN=`</dev/urandom tr -dc A-Za-z0-9 | head -c8`
IUSER_BDD_MERAN="indice"
IPASS_BDD_MERAN=`</dev/urandom tr -dc A-Za-z0-9 | head -c8`

while getopts “h:i:d:b:u:p:s:w:c:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         i)
             ID=$OPTARG
             ;;
         d)
             DESTINO_MERAN=$OPTARG
             ;;
         b)
             BDD_MERAN=$OPTARG
             ;;
         u)
             USER_BDD_MERAN=$OPTARG
             ;;
         p)
             PASS_BDD_MERAN=$OPTARG
             ;;
         s)
             IUSER_BDD_MERAN=$OPTARG
             ;;
         w)
             IPASS_BDD_MERAN=$OPTARG
             ;;
         c)
             CONFIGURACION_MERAN=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $ID ]] 
then
     usage
     exit 1
fi

if [ $(whoami) = root ];
  then
    echo "Sos root asi que no hay problema, adelante!!!"
  else
    echo "Hay que ser root"
    exit 1
fi
if [ $(perl -v|grep 5.10.1|wc -l) -eq 0 ];
  then
    echo "No tenes la versión adecuada de perl instalada, se va a interrumpir el proceso, deberías tener la 5.10.1"
    exit 1
fi


echo "¿Quiere proceder a instalar todo el software de base base necesaria para Meran? (Apache/Mysql/perl/etc)"
select OPCION in Instalar No_instalar 
do
    if [ $OPCION = Instalar ]; 
        then
        echo "Procederemos a instalar todo lo necesario sobre Debian GNU/Linux"
        echo "Para hacerlo hay q ser superusuario"
        #Instalar paquetes
        #su
        apt-get update
        apt-get install apache2 mysql-server libapache2-mod-perl2 libgd2-xpm libxpm4 htmldoc libaspell15 ntpdate -y
        #Configurar apache
        echo "Procederemos a habilitar en apache los modulos necesarios"
        a2enmod rewrite
        a2enmod expires
        a2enmod ssl
        a2enmod headers
        echo "Procederemos a habilitar en apache los sites"
        a2dissite default
        break
    else
	    echo "NO se instalará nada base"
            break
    fi
done

echo "Ahora si vamos a instalar Meran en el sistema"
echo "Seleccione el tipo de Operación que quiere realizar"

select OPCION in InstalacionNueva Actualizar
  do
  if [ $OPCION = InstalacionNueva ]; 
    then
      echo "Procediendo a la Instalación como Jaula de la aplicación"
      echo "Este proceso instalará los módulos específicos para la arquitectura de su Kernel que ya vienen precompilados y se distribuyen junto con Meran"
      echo "Su sistema es de $versionKernel bits"
      echo "Este instalador automático ubicará todos los archivos en el path por defecto $DESTINO_MERAN utilizando para la configuración del sistema /etc/meran/meran.conf"
      fecha=$(date +%Y%m%d%H%M)
      echo $fecha > ./fecha_instalacion
      if [ -e $CONFIGURACION_MERAN/meran$ID.conf ]; then
                echo "El archivo de configuración ya existía"
                mv $CONFIGURACION_MERAN/meran$ID.conf $CONFIGURACION_MERAN/meran$ID.$fecha.conf
                echo "Se backupeo el archivo original a /etc/meran/meran$ID.$fecha.conf"
      fi
      if [ ! -d $CONFIGURACION_MERAN ]; then
        echo "El directorio de configuración no existía, lo creamos\n"
        mkdir $CONFIGURACION_MERAN
      fi
      generarConfiguracion
      if [ -d $DESTINO_MERAN/$ID ]; then
                echo "Ya existe el directorio de archivos, lo backupeamos"
                mv $DESTINO_MERAN/$ID $DESTINO_MERAN/$ID$fecha
                echo "Se backupeo el directorio original a $DESTINO_MERAN$fecha"
      fi
      mkdir -p $DESTINO_MERAN/$ID
      descomprimirArchivos
      echo "Generando Archivos de logs y logrotate"
      generarLogRotate
      echo "Copiando configuración de sphinx" 
      generarConfSphinx
      echo "Copiando los Virtualhosts"
      generarJaula 
      #Crear bdd
      echo "Generando la Base de datos"
      generarPermisosBDD
      actualizarBDD
      #Configurar cron
      generarCrons
      echo "La instalación esta concluida"
      echo "Reiniciaremos los servicios"
      #Reiniciar apache 
      /etc/init.d/apache2 restart
      #Iniciar sphinx
      arrancarSphinx
      cambiarPermisos
      break
    elif [ $OPCION = Actualizar ];
	then 
    	   echo "Se hará una actualización"
	   if [ -d $DESTINO_MERAN/$ID ]; 
	   then
	     descomprimirArchivos
      	     cambiarPermisos
             actualizarBDD
            /etc/init.d/apache2 restart
	     break
	   else
	     echo "No existe la instalación"
	    break
	   fi
    else
      echo "Solicitó una instalación sistemica de Meran, lo que significa que se modificará el sistema base."
      echo "Este tipo de instalación no esta disponible por el momento de manera automática, siga los pasos especificados en el Readme si quiere hacerlo de forma manual"
      break
  fi
done
