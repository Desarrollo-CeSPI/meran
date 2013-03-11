#!/bin/sh
#Este script recibe 4 parametros, la salida de Guarani, un 0 o un 1 que indica si se nos van a presentar preguntas de confirmacion (1) o hace todo automatico (0), el branchcode (por ejemplo DEO)  y la rama del ldap donde van a estar los usuarios. 
base=$(cat /etc/meran/meran.conf |grep database| awk -F"=" '{print $2}')
usuarioBase=$(cat /etc/meran/meran.conf |egrep ^user=| awk -F"=" '{print $2}')
passBase=$(cat /etc/meran/meran.conf |egrep ^pass=| awk -F"=" '{print $2}')
debug=0
preguntar=$2;
if [ ! -d /var/log/actualizacion/ ] 
	then
	mkdir /var/log/actualizacion/;
	echo "CREADO";
	fi
echo "Comenzando UPDATE "`date +%d/%m/%Y-%H:%M` >> /var/log/actualizacion/resultado ;
#ACA HABRIA QUE PREGUNTAR
if [ $preguntar = 1 ] 
	then
	echo "Actualizar los datos a actualizar desde el archivo de Guarani?(S/N)";
	read pregunta;
	echo "Actualizar las Bases de Datos LDAP y MYSQL?(S/N)";
	read pregunta2;
	else 
	 pregunta=S;
	 pregunta2=S;
fi
if [ $pregunta = S ] 
 then
 if [ ! -d backs/ ] 
	then
	mkdir backs;
	echo "CREADO";
	fi

 if [ -f ldifUPDATE.ldif ]
 	then 
	mv ldifUPDATE.ldif backs/ldifUPDATE`date +%d-%m-%Y_%H-%M`.ldif;
         fi
echo "Arrancando con el ldap_UPDATE $1 $2 $3";
./script_ldap_UPDATE.pl $1 $4 > ldifUPDATE.ldif 2>> /var/log/actualizacion/erroresLDAP;
 if [ -f personsUPDATE.sql ] 
	then 
	mv personsUPDATE.sql backs/personsUPDATE`date +%d-%m-%Y_%H-%M`.sql;
fi
./script_sql_UPDATE.pl $1 "dbi:mysql:$base" $usuarioBase $passBase $3 $debug > personsUPDATE.sql 2>> /var/log/actualizacion/erroresMYSQL;
fi
if [ $pregunta2 = S ] 
	then
		echo "Comenzando actualizacion de LDAP del día  "`date +%d-%m-%Y_%H:%M` >> /var/log/actualizacion/resultado ;
		echo "Errores del día "`date +%d/%m/%Y-%H:%M` >> /var/log/actualizacion/erroresLDAP ;
		if [ ! -d backs ]
			then
			mkdir backs ;
			fi
		if [ -f ldifUPDATE.ldif ] 
			then
			/etc/init.d/slapd stop;
			/usr/sbin/slapcat > backs/arbol`date +%d-%m-%Y_%H-%M`.ldif;
		/usr/sbin/slapadd -c -l /home/soportelinti/ldifUPDATE.ldif 2>> /var/log/actualizacion/erroresLDAP;
		chown openldap:openldap -R /var/lib/ldap
			/etc/init.d/slapd start;
			fi
		echo "Finalizando actualizacion de LDAP del día  "`date +%d-%m-%Y_%H:%M` >> /var/log/actualizacion/resultado ;
		echo "Comenzando actualizacion de mysql del día  "`date +%d-%m-%Y_%H:%M` >> /var/log/actualizacion/resultado ;
		echo "Errores del día "`date +%d-%m-%Y-%H:%M` >> /var/log/actualizacion/erroresMYSQL ;
		mysqldump $base -u$usuarioBase -t usr_persona -p$passBase > backs/persons`date +%d-%m-%Y_%H:%M`.sql; 
		mysqldump $base -u$usuarioBase -t usr_socio -p$passBase >> backs/persons`date +%d-%m-%Y_%H:%M`.sql; 
		mysql $base -u$usuarioBase -f -p$passBase < personsUPDATE.sql 2>> /var/log/actualizacion/erroresMYSQL;
		echo "Finalizando actualizacion de mysql del día  "`date +%d-%m-%Y_%H:%M` >> /var/log/actualizacion/resultado ;
	fi
echo "Finalizando UPDATE "`date +%d-%m-%Y-%H:%M` >> /var/log/actualizacion/resultado ;
