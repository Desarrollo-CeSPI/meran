#/bin/bash
echo "Primero tenes que configurar el cpan para que instale donde es requerido"
echo "Ejecuta cpan"
echo "Configura la variable makepl_arg con el valor del directorio donde instalaras los modulos" 
echo "Ejemplo  o conf makepl_arg PREFIX=/usr/share/meran/intranet/modules/C4/Share"
echo "Eso devuelve  makepl_arg         [PREFIX=/usr/share/meran/intranet/modules/C4/Share] /n
Please use 'o conf commit' to make the config permanent!"
echo "Luego para setear la variable ejecuta  o conf commit"
echo "Presiona cualquier tecla para continuar cuando termines"
read pepe
echo "listo, ahora instalaremos las dependencias "
apt-get update -y
apt-get install apache2 mysql-server libapache2-mod-perl2 
apt-get install libssl-dev
apt-get install libaspell-dev
apt-get install aspell-en 
apt-get install libyaz4-dev
apt-get install libexpat1-dev
apt-get install libgd2-xpm-dev
echo "Ni MARC.pm ni el motor de Sphinx ni el Sphinx/Search.pm (depende de tu motor de sphinx)  esta en cpan hay que instalarlos a mano"
echo "Para todo lo demas exite CPAN"
echo "previo a cualquier instalacion tenemos que hacer un export de las variables para que cpan sepa donde estan los modulos de los que depende la nueva instalacion"
export PERL5LIB=/usr/share/meran/intranet/modules/C4/Share/share/perl/5.10.1/:/usr/share/meran/intranet/modules/C4/Share/lib/perl/5.10.1/:/usr/share/meran/intranet/modules/C4/Share/share/perl/5.10/:/usr/share/meran/intranet/modules/C4/Share/share/perl/5.10.1/
echo "listo a instalar"
cat dependencias.txt| xargs cpan -i;
