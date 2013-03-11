#!/bin/sh
if [ ! -z $1 ] && [ -f $1 ]; then
		echo "Procesando $1";
	      else 
		echo "Error, debe pasar el nombre del archivo csv a procesar como parámetro, el CSV debe ser separado por ;";
		echo "Invoque sh permisos.sh permisos.csv";
		exit;
	      fi 
echo "Recuerde que debe cambiar los permisos de los usuarios en el archivo permisos.xls y Guardar como csv separado por punto y coma. Presione Enter para continuar";
read; 
echo "Ingrese el nombre de la base de datos que va a configurar";
read basededatos;
if [ -z $basededatos ]; then  
	echo "ERROR: debe introducir el nombre de la bdd";

else
echo "Ingrese el usuario para el opac [userOPAC]";
read userOPAC;
if [ -z $userOPAC ]; then  
			userOPAC="userOPAC";
		       fi	
echo "Ingrese el usuario para el userDevelop [userDevelop]";
read userDevelop;
if [ -z $userDevelop ]; then  
			userDevelop="userDevelop";
		       fi	
echo "Ingrese el usuario para la Intranet  [userINTRA]";
read userINTRA;
if [ -z $userINTRA ]; then  
			userINTRA="userINTRA";
		       fi	
echo "Ingrese el usuario para el userAdmin [userAdmin]";
read userAdmin;
if [ -z $userAdmin ]; then  
			userAdmin="userAdmin";
		       fi	
echo "Agregar info para crear los usuarios?(S/N)";
read crear;
if [ $crear = S ] || [ $crear = s ]; then 
		echo "Ingrese el password para el usuario $userOPAC[userOPAC]";
		read passuserOPAC;
		if [ -z $passuserOPAC ]; then  
			passuserOPAC="userOPAC";
		fi	
		echo "Ingrese el password para el usuario $userDevelop [userDevelop]";
		read passuserDevelop;
		if [ -z $passuserDevelop ]; then  
			passuserDevelop="userDevelop";
		fi	
		echo "Ingrese el password usuario para el usuario $userINTRA [userINTRA]";
		read passuserINTRA;
		if [ -z $passuserINTRA ]; then  
			passuserINTRA="userINTRA";
		       fi	
		echo "Ingrese el password para el usuario $userAdmin [userAdmin]";
		read passuserAdmin;
		if [ -z $passuserAdmin ]; then  
			passuserAdmin="userAdmin";
		       fi		
		echo "use $basededatos ;" > permisos$userOPAC.sql;
		echo "use $basededatos ;" > permisos$userINTRA.sql;
		echo "use $basededatos ;" > permisos$userDevelop.sql;
		echo "use $basededatos ;" > permisos$userAdmin.sql;
    		 echo "GRANT SELECT on cat_nivel3 to $userOPAC@localhost identified by'$passuserOPAC'; "  >> permisos$userOPAC.sql
    		 echo "GRANT SELECT on cat_nivel3 to $userINTRA@localhost identified by '$passuserINTRA'; "  >> permisos$userINTRA.sql
    		 echo "GRANT SELECT on cat_nivel3 to $userDevelop@localhost identified by '$passuserDevelop'; " >> permisos$userDevelop.sql
    		 echo "GRANT SELECT on cat_nivel3 to $userAdmin@localhost identified by '$passuserAdmin'; "  >> permisos$userAdmin.sql
		 
else
	echo "use $basededatos ;" > permisos$userOPAC.sql;
		echo "use $basededatos ;" > permisos$userINTRA.sql;
		echo "use $basededatos ;" > permisos$userDevelop.sql;
		echo "use $basededatos ;" > permisos$userAdmin.sql;
fi
IFS=$'\n'
j=0
echo "Procesando el archivo ..... Aguarde";
for i in $(cat $1);
    do
    if [ $j -gt 1 ]; then 
    		  	echo $i |sed 's/"//g' | sed 's/|//g'| awk -F";" '{print "GRANT " $2 " on " $1 " to '$userOPAC@localhost'; " }' >> permisos$userOPAC.sql
    		  	echo $i |sed 's/"//g' | sed 's/|//g'| awk -F";" '{print "GRANT " $3 " on " $1 " to '$userINTRA@localhost'; " }' >> permisos$userINTRA.sql
    		  	echo $i |sed 's/"//g' | sed 's/|//g'| awk -F";" '{print "GRANT " $4 " on " $1 " to '$userDevelop@localhost'; " }' >> permisos$userDevelop.sql
    		  	echo $i |sed 's/"//g' | sed 's/|//g'| awk -F";" '{print "GRANT " $5 " on " $1 " to '$userAdmin@localhost'; " }' >> permisos$userAdmin.sql
		   else
			  let j+=1;
		   fi
    done;
echo "Ahora viene la parte de ejecutar las sentencias mysql. ¿Quiere hacerlo automaticamente (S/N)? ";
read automatico;
if [ $automatico = S ] || [ $automatico = s ] ; then 
			echo "Ejecutandose automaticamente ";
			echo "Para agregar permisos de usuario userOpac ejecutar:  mysql $basededato -p < permisos$userOPAC.sql ";
			mysql $basededato -p < permisos$userOPAC.sql;
			echo "Para agregar permisos de usuario $userINTRA ejecutar:  mysql $basededato -p < permisos$userINTRA.sql ";
			mysql $basededato -p < permisos$userINTRA.sql;
			echo "Para agregar permisos de usuario $userDevelop ejecutar:  mysql $basededato -p < permisos$userDevelop.sql ";
			mysql $basededato -p < permisos$userDevelop.sql;
			echo "Para agregar permisos de usuario $userAdmin ejecutar:  mysql $basededato -p < permisos$userAdmin.sql ";
			mysql $basededato -p < permisos$userAdmin.sql;
		       else
			echo "Ahora viene la parte a mano ";
			echo "Para agregar permisos de usuario userOpac ejecutar:  mysql $basededato -p < permisos$userOPAC.sql ";
			echo "Para agregar permisos de usuario $userINTRA ejecutar:  mysql $basededato -p < permisos$userINTRA.sql ";
			echo "Para agregar permisos de usuario $userDevelop ejecutar:  mysql $basededato -p < permisos$userDevelop.sql ";
			echo "Para agregar permisos de usuario $userAdmin ejecutar:  mysql $basededato -p < permisos$userAdmin.sql ";
		       fi;
fi;
