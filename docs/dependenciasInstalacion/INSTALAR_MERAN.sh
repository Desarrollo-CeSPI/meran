#!/bin/bash

#obtener el código fuente
#apt-get install git-core -y
#cd /usr/share/
#git clone ssh://root@proyectos.linti.unlp.edu.ar/var/meran
#cd /usr/share/meran/docs/dependenciasInstalacion/
#cp ../configuracion/git/config ../../.git/

#Instalar dependencias
sh dependenciasMERAN.sh

#Configurar apache
cp ../configuracion/apache/* /etc/apache2/sites-available/
a2ensite opac
a2ensite ssl
a2enmod rewrite
a2enmod expires
a2enmod ssl
a2enmod headers
#Generar certificado
mkdir /etc/apache2/ssl
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.pem -out /etc/apache2/ssl/apache.pem

#Configurar Meran
mkdir /etc/meran
cp ../configuracion/meran/meran.conf /etc/meran
chmod -R +r /etc/meran/meran.conf

#Logs de meran
mkdir /var/log/meran
cp ../configuracion/logrotate.d/meran /etc/logrotate.d/

#Configurar Sphinx
cp ../configuracion/sphinx/default-sphinxsearch /etc/default/sphinxsearch
cp ../configuracion/sphinx/init.d-sphinxsearch /etc/init.d/sphinxsearch
cp ../configuracion/sphinx/sphinx.conf /etc/sphinxsearch/sphinx.conf

#Crear bdd
mysql -p < ../configuracion/mysql/meran.sql
#Dar permisos a los usuarios en la bdd (userAdmin,userOPAC,userINTRA,userDevelop,indice)
mysql -p < ../configuracion/mysql/users.sql

#Configurar cron

#Reiniciar apache 
/etc/init.d/apache2 restart

#Iniciar sphinx
/etc/init.d/sphinxsearch restart

#Reindexar
indexer --all --rotate

