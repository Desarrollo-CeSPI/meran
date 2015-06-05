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

generarConfSphinx()
{
  sed s/reemplazarID/$(escaparVariable $ID)/g $sources_MERAN/sphinx.conf > /tmp/$ID.sphix.conf
  sed s/reemplazarIUSER/$(escaparVariable  $IUSER_BDD_MERAN)/g /tmp/$ID.sphix.conf > /tmp/$ID.sphix2.conf
  sed s/reemplazarIPASS/$(escaparVariable $IPASS_BDD_MERAN)/g /tmp/$ID.sphix2.conf > /tmp/$ID.sphix.conf
  sed s/reemplazarBDDHOST/$(escaparVariable  $HOST_BDD_MERAN)/g /tmp/$ID.sphix.conf > /tmp/$ID.sphix2.conf
  sed s/reemplazarDATABASE/$(escaparVariable $BDD_MERAN)/g /tmp/$ID.sphix2.conf > $DESTINO_MERAN/$ID/sphinx/etc/sphinx.conf
  rm /tmp/$ID.sphix*

}
instalacionNueva(){
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
      if [ -z $ROOT_PASS_BASE ]
      then
    		stty -echo
    		echo "Necesitamos un password para acceder al motor con el usuario $ROOT_USER_BASE."
    		read -p "Ingreselo:" ROOT_PASS_BASE
    		stty echo
  	  fi
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
}
actualizarInstalacion(){

   echo "Se hará una actualización"
	   if [ -d $DESTINO_MERAN/$ID ]; 
	   then
	       #Guardamos el sphinx.conf de la jaula
         cp $DESTINO_MERAN/$ID/sphinx/etc/sphinx.conf /tmp/sphinx.conf
         #Copiamos el código
         descomprimirArchivos
         #Volvemos a poner la conf de sphinx
      	 cp -a /tmp/sphinx.conf $DESTINO_MERAN/$ID/sphinx/etc/sphinx.conf
         #Cambiamos permisos
         cambiarPermisos
         if [ -z $ROOT_PASS_BASE ]
    		 then
    			stty -echo
    			echo "Necesitamos un password para acceder al motor con el usuario $ROOT_USER_BASE."
    			read -p "Ingreselo:" ROOT_PASS_BASE
    			stty echo
    		 fi
         actualizarBDD
         /etc/init.d/apache2 restart
	     break
	   else
	     echo "No existe la instalación"
	    break
	   fi

	}
generarLogRotate()
{
  sed s/reemplazarID/$(escaparVariable $ID)/g logrotate.d-meran > /etc/logrotate.d/logrotate.d-meran$ID
  #Logs de meran
  mkdir -p /var/log/meran/$ID
  
}

generarJaula()
{
  sed s/reemplazarPATHBASE/$(escaparVariable $DESTINO_MERAN)/g $sources_MERAN/debian$DEBIAN_VERSION/apache-jaula-ssl > /tmp/$ID-apache-jaula-tmp2
  sed s/reemplazarCONFMERAN/$(escaparVariable $CONFIGURACION_MERAN)/g /tmp/$ID-apache-jaula-tmp2 > /tmp/$ID-apache-jaula-tmp
  sed s/reemplazarID/$(escaparVariable $ID)/g /tmp/$ID-apache-jaula-tmp > /etc/apache2/sites-available/$ID-apache-jaula-ssl
  sed s/reemplazarPATHBASE/$(escaparVariable $DESTINO_MERAN)/g $sources_MERAN/debian$DEBIAN_VERSION/apache-jaula-opac > /tmp/$ID-apache-jaula-tmp2
  sed s/reemplazarCONFMERAN/$(escaparVariable $CONFIGURACION_MERAN)/g /tmp/$ID-apache-jaula-tmp2 > /tmp/$ID-apache-jaula-tmp
  sed s/reemplazarID/$(escaparVariable $ID)/g /tmp/$ID-apache-jaula-tmp > /etc/apache2/sites-available/$ID-apache-jaula-opac
  rm /tmp/$ID-apache-jaula-tmp
  #Generar certificado de apache
  echo "Generando el certificado de apache"
  mkdir -p /etc/apache2/ssl/$ID
  openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/apache2/ssl/$ID/apache.pem -out /etc/apache2/ssl/$ID/apache.pem
  a2enmod rewrite
  a2enmod expires
  a2enmod ssl
  a2enmod headers
  echo "Procederemos a habilitar en apache los sites"
  a2dissite default
  a2ensite $ID-apache-jaula-ssl
  a2ensite $ID-apache-jaula-opac
}


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

generarCrons()
{
	ADONDE=$DESTINO_MERAN/$ID/intranet/modules/C4
	crontab -l >/tmp/$ID.crontab
	if [ $DEBIAN_VERSION == "6" ]
		then
		PERL_LIBAUX=$ADONDE/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10.1/:$ADONDE/Share/share/perl/5.10/:$ADONDE/C4/Share/share/perl/5.10.1/:$ADONDE/Share/lib/perl/5.10/:$ADONDE/Share/lib/perl5/

	else		
	PERL_LIBAUX=$ADONDE/Share/share/perl/5.14.2/:$ADONDE/Share/lib/perl/5.14.2/:$ADONDE/Share/share/perl/5.14/:$ADONDE/C4/Share/share/perl/5.14.2/:$ADONDE/Share/lib/perl/5.14/:$ADONDE/Share/lib/perl5/
	
		fi
echo "
			0 7 * * *      export PERL5LIB=$PERL_LIBAUX; export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/recordatorio_prestamos_vto.pl 2>&1
			0 * * * *      export PERL5LIB=$PERL_LIBAUX; export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/mail_prestamos_vencidos.pl  2>&1
			* * * * *      export PERL5LIB=$PERL_LIBAUX; export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/procesarColaZ3950.pl  2>&1
			* * * * *      export PERL5LIB=$PERL_LIBAUX; export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/reindexar.pl 2>&1
			0 0 * * *      export PERL5LIB=$PERL_LIBAUX; export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/obtener_portadas_de_registros.pl  2>&1
			0 0 * * 6      export PERL5LIB=$PERL_LIBAUX; export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/generar_indice.pl  2>&1" >>/tmp/$ID.crontab

  crontab /tmp/$ID.crontab

}
instalarDependencias()
{
	    echo "Procederemos a instalar todo lo necesario sobre Debian GNU/Linux"
        echo "Para hacerlo hay q ser superusuario"
        #Instalar paquetes
        #su
        apt-get update -qq
        apt-get install apache2 apache2-mpm-prefork mysql-server libapache2-mod-perl2 libgd2-xpm libxpm4 htmldoc libaspell15 ntpdate libhttp-oai-perl libxml-sax-writer-perl libxml-libxslt-perl libyaml-perl  -yqq
        #Configurar apache
        echo "Procederemos a habilitar en apache los modulos necesarios"
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
	tar xzf $sources_MERAN/debian$DEBIAN_VERSION/jaula$versionKernel.tar.gz -C $DESTINO_MERAN/$ID/intranet/modules/C4/
	echo "Descomprimiendo sphinxsearch" 
	tar xzf $sources_MERAN/debian$DEBIAN_VERSION/sphinx$versionKernel.tar.gz -C $DESTINO_MERAN/$ID
      
}
cambiarPermisos()
{
      chown www-data:www-data -R $DESTINO_MERAN/$ID/files/
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
   -?      Show this message
   -i      Identificador para esta instalación de meran. Este Identificador se va a utilizar en todo
   -d      Carpeta DESTINO donde se guardara meran. Por defecto /usr/share/meran
   -b      Base de datos a usar. Por Defecto va a ser meran
   -h	   Host donde esta la base de datos
   -u      Usuario que se va a conectar a la base de datos. Por defecto meranadmin
   -p      Pass del usuario que se va a conectar a la base de dato. Por defecto sera un random
   -s      Usuario que se va a utilizar en el indice. Por defecto indice
   -w      Pass del usuario que se va a utilizar en el indice. Por defecto sera un random
   -c      directorio donde se guardará la configuracion de meran. Por defecto sera /etc/meran y el archivo de configuracion sera meran$ID.conf
   -P	   La pass del usuario para crear la base de datos
   -U	   El usuario para conectarse a la base de datos
   -N	   Si esta presente Determina si es una instalacion nueva. Por defecto pregunta
   -B	   Si esta presente en 1 determina que tiene que instalar las dependencias, si esta en 0 no instala y si no esta pregunta.
   -v	   Si esta presente determina la version del kernel que se va a utilizar. Por defecto la descubre de uname -a
   -C	   Si esta presente indica que hay que consevar el sql de la base de datos sin eliminar
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
HOST_BDD_MERAN="localhost"
ROOT_USER_BASE="root"
ROOT_PASS_BASE=""
DBB_USER_ORIGEN="localhost"
NEW_INSTALACION=0
BASE_INSTALACION=2
CONSERVE_SQL=0

while getopts “?:h:i:d:b:u:p:s:w:c:U:v:P:NB:C” OPTION
do
     case $OPTION in
         U)
			ROOT_USER_BASE=$OPTARG
			;;
	 N)
			NEW_INSTALACION=1
			;;
	 B)
			BASE_INSTALACION=$OPTARG
			;;
	 P)	
			ROOT_PASS_BASE=$OPTARG
            ;;
	 v)	

			versionKernel=$OPTARG
            ;;
         i)
             ID=$OPTARG
             ;;
         h)
             HOST_BDD_MERAN=$OPTARG
             DBB_USER_ORIGEN=$(hostname -I)
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
         C)
             CONSERVE_SQL=1
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
  	if [ $(perl -v|grep 5.14.2|wc -l) -eq 0 ];
	then
    		echo "No tenes la versión adecuada de perl instalada, se va a interrumpir el proceso, deberías tener la 5.10.1"
		exit 1
	else
		echo "Version de PERL 5.14.2";
	fi
   else
	echo "Version de PERL 5.10.1";
fi


if [ $BASE_INSTALACION -eq 1 ] 
then
	instalarDependencias
else
	if [ $BASE_INSTALACION -eq 2 ] 
	then
		echo "¿Quiere proceder a instalar todo el software de base base necesaria para Meran? (Apache/Mysql/perl/etc)"
		select OPCION in Instalar No_instalar 
		do
		if [ $OPCION = Instalar ]; 
			then
			instalarDependencias
			break
		else
			echo "NO se instalará nada base"
				break
		fi
		done
	fi	
fi

echo "Ahora si vamos a instalar Meran en el sistema"
echo "Seleccione el tipo de Operación que quiere realizar"

if [ $NEW_INSTALACION -eq 1 ]
then
	instalacionNueva
else
	select OPCION in InstalacionNueva Actualizar
	  do
	  if [ $OPCION = InstalacionNueva ]; 
		then
			instalacionNueva
			break
		elif [ $OPCION = Actualizar ];
		then 
			actualizarInstalacion
		else
		  echo "Solicitó una instalación sistemica de Meran, lo que significa que se modificará el sistema base."
		  echo "Este tipo de instalación no esta disponible por el momento de manera automática, siga los pasos especificados en el Readme si quiere hacerlo de forma manual"
		  break
	  fi
	done
fi
