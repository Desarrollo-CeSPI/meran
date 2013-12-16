#!/bin/sh
#Este script recibe 3 parametros, la salida de Guarani, un 0 o un 1 que indica si se nos van a presentar preguntas de confirmacion (1) o hace todo automatico (0) y la password necesaria para agregar los datos en el mysql.
preguntar=$2;
if [ ! -d /var/log/actualizacion/ ] 
	then
	mkdir /var/log/actualizacion/;
	echo "CREADO";
	fi
echo "Comenzando UPDATE "`date +%d/%m/%Y-%H:%M` >> /var/log/actualizacion/resultado ;
#./script_ldap_UPDATE.pl $1 > ldifUPDATE.ldif;
#./script_sql_UPDATE.pl $1 > personsUPDATE.sql;
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
 if [ -f ldifUPDATE.ldif ]
 	then 
	mv ldifUPDATE.ldif ldifUPDATE`date +%d-%m-%Y_%H-%M`.ldif;
         fi
./script_ldap_UPDATE.pl $1 > ldifUPDATE.ldif 2>> /var/log/actualizacion/erroresLDAP;
 if [ -f personsUPDATE.sql ] 
 	then 
		mv personsUPDATE.sql personsUPDATE`date +%d-%m-%Y_%H-%M`.sql;
	fi
./script_sql_UPDATE.pl $1 > personsUPDATE.sql 2>> /var/log/actualizacion/erroresMYSQL;
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
			slapcat > backs/arbol`date +%d-%m-%Y_%H-%M`.ldif;
			slapadd -c -l ldifUPDATE.ldif 2>> /var/log/actualizacion/erroresLDAP;
			/etc/init.d/slapd start;
			fi
		echo "Finalizando actualizacion de LDAP del día  "`date +%d-%m-%Y_%H:%M` >> /var/log/actualizacion/resultado ;
		echo "Comenzando actualizacion de mysql del día  "`date +%d-%m-%Y_%H:%M` >> /var/log/actualizacion/resultado ;
		echo "Errores del día "`date +%d-%m-%Y-%H:%M` >> /var/log/actualizacion/erroresMYSQL ;
		mysqldump Econo -t persons -p$3 > backs/persons`date +%d-%m-%Y_%H:%M`.sql; 
		mysql Econo -f -p$3 < personsUPDATE.sql 2>> /var/log/actualizacion/erroresMYSQL;
		echo "Finalizando actualizacion de mysql del día  "`date +%d-%m-%Y_%H:%M` >> /var/log/actualizacion/resultado ;
	fi
y si!!!
echo "Finalizando UPDATE "`date +%d-%m-%Y-%H:%M` >> /var/log/actualizacion/resultado ;
