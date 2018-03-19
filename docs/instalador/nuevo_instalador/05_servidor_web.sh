#!/bin/bash

sed s/reemplazarPATHBASE/$(escaparVariable $DESTINO_MERAN)/g ${PWD}/apache-jaula-ssl > /tmp/$ID-apache-jaula-tmp2
sed s/reemplazarCONFMERAN/$(escaparVariable $CONFIGURACION_MERAN)/g /tmp/$ID-apache-jaula-tmp2 > /tmp/$ID-apache-jaula-tmp
sed s/reemplazarID/$(escaparVariable $ID)/g /tmp/$ID-apache-jaula-tmp > /etc/apache2/sites-available/$ID-apache-jaula-ssl
sed s/reemplazarPATHBASE/$(escaparVariable $DESTINO_MERAN)/g ${PWD}/apache-jaula-opac > /tmp/$ID-apache-jaula-tmp2
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