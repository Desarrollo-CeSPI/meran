#!/bin/sh
#En este script a acomodar los archivos que genera meran a la nueva estructura, 
# sacándolos y separándolos del código.
ID=$1
DESTINO_MERAN="/usr/share/meran"


echo "Para acomodar Files ";

echo " FALTA: el meranconf debería quedar con las siguientes configuraciones de files: ";
echo "
picturesdir=reemplazarPATHBASE/reemplazarID/files/intranet/uploads/pictures
picturesdir_opac=reemplazarPATHBASE/reemplazarID/files/intranet/uploads/pictures-opac
reports_dir=reemplazarPATHBASE/reemplazarID/files/intranet/uploads/reports
covers=reemplazarPATHBASE/reemplazarID/files/intranet/uploads/covers
edocsdir=reemplazarPATHBASE/reemplazarID/files/intranet/private-uploads/edocs
importsdir=reemplazarPATHBASE/reemplazarID/files/intranet/private-uploads/imports
novedadesOpacPath=reemplazarPATHBASE/reemplazarID/files/opac/uploads/novedades
portadasNivel2Path=reemplazarPATHBASE/reemplazarID/files/intranet/uploads/covers-added
logosIntraPath=reemplazarPATHBASE/reemplazarID/files/intranet/private-uploads/logos
logosOpacPath=reemplazarPATHBASE/reemplazarID/files/intranet/private-uploads/logos
dtdPath=reemplazarPATHBASE/reemplazarID/files/intranet/herramientas/importacion
tipoDocumentoPath=reemplazarPATHBASE/reemplazarID/files/intranet/uploads/covers
private_images_path=reemplazarPATHBASE/reemplazarID/files/intranet/private-uploads/images
opac_path=reemplazarPATHBASE/reemplazarID/files/opac/uploads
intra_path=reemplazarPATHBASE/reemplazarID/files/intranet/uploads
private_path=reemplazarPATHBASE/reemplazarID/files/intranet/private-uploads
";

cp -a intranet/htdocs/uploads/pictures/* files/intranet/uploads/pictures/
cp -a intranet/htdocs/uploads/pictures-opac/* files/intranet/uploads/pictures-opac/
cp -a intranet/htdocs/uploads/reports/* files/intranet/uploads/reports/
cp -a intranet/htdocs/uploads/covers/* files/intranet/uploads/covers/
cp -a intranet/htdocs/private-uploads/edocs/* files/intranet/private-uploads/edocs/
cp -a intranet/htdocs/private-uploads/imports/* files/intranet/private-uploads/imports/
cp -a opac/htdocs/opac-tmpl/uploads/novedades/* files/opac/uploads/novedades/
cp -a opac/htdocs/logos/* files/intranet/private-uploads/logos/
cp -a intranet/htdocs/uploads/covers-added/* files/intranet/uploads/covers-added/
cp -a intranet/htdocs/private-uploads/logos/* files/intranet/private-uploads/logos/
cp -a intranet/cgi-bin/herramientas/importacion/* files/intranet/herramientas/importacion/
cp -a opac/htdocs/opac-tmpl/uploads/portada/* files/opac/uploads/portada/

echo " FALTA: Actualizar alias de apache!!! ";
echo " Agregar a la conf del OPAC, antes del alias a /uploads/: ";

echo 'Alias /uploads/covers/ "reemplazarPATHBASE/reemplazarID/files/intranet/uploads/covers/"
<Directory reemplazarPATHBASE/reemplazarID/files/intranet/uploads/covers/ >
  Order allow,deny
  Allow from all
</Directory>

Alias /uploads/covers-added/ "reemplazarPATHBASE/reemplazarID/files/intranet/uploads/covers-added/"
<Directory reemplazarPATHBASE/reemplazarID/files/intranet/uploads/covers-added/ >
 Order allow,deny
 Allow from all
</Directory>

Alias /uploads/ "reemplazarPATHBASE/reemplazarID/files/opac/uploads/"
<Directory reemplazarPATHBASE/reemplazarID/files/opac/uploads/ >
Order allow,deny
Allow from all
</Directory>


Alias /private-uploads/ "reemplazarPATHBASE/reemplazarID/files/intranet/private-uploads/"
<Directory reemplazarPATHBASE/reemplazarID/files/intranet/private-uploads/ >
Order allow,deny
Allow from all
</Directory>

';

echo " Agregar a la conf de la INTRA, antes del alias a /uploads/: ";

echo 'Alias /uploads/covers/ "reemplazarPATHBASE/reemplazarID/files/intranet/uploads/covers/"
<Directory reemplazarPATHBASE/reemplazarID/files/intranet/uploads/covers/ >
  Order allow,deny
  Allow from all
</Directory>

Alias /uploads/novedades-opac "reemplazarPATHBASE/reemplazarID/files/opac/uploads/novedades/"
<Directory reemplazarPATHBASE/reemplazarID/files/opac/uploads/novedades >
Order allow,deny
Allow from all
</Directory>

Alias /uploads/portada "reemplazarPATHBASE/reemplazarID/files/opac/uploads/portada/"
<Directory reemplazarPATHBASE/reemplazarID/files/opac/uploads/portada >
Order allow,deny
Allow from all
</Directory>

Alias /uploads/covers-added/ "reemplazarPATHBASE/reemplazarID/files/intranet/uploads/covers-added/"
<Directory reemplazarPATHBASE/reemplazarID/files/intranet/uploads/covers-added/ >
 Order allow,deny
 Allow from all
</Directory>

Alias /private-uploads/ "reemplazarPATHBASE/reemplazarID/files/intranet/private-uploads/"
<Directory reemplazarPATHBASE/reemplazarID/files/intranet/private-uploads/ >
Order allow,deny
Allow from all
</Directory>

';
