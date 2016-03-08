#!/usr/bin/perl
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2015 Grupo de desarrollo de Meran CeSPI-UNLP
# <desarrollo@cespi.unlp.edu.ar>
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.
use DBI;
use CGI::Session;
use C4::Context;
use Switch;
use C4::AR::Utilidades;
use C4::Modelo::RefPais;
use C4::Modelo::CatAutor;
use MARC::Record;
use C4::AR::ImportacionIsoMARC;
use C4::AR::Catalogacion;
use C4::AR::PortadaNivel2;
use File::Copy;
use File::Basename;
##Migramos Desaparecidos##


my $op = $ARGV[0] || 0;
my $db_driver =  "mysql";
my $db_name   = 'ddhh';
my $db_host   = 'db';
my $db_user   = 'root';
my $db_passwd = 'dev';
open (ERROR, '>/var/log/meran/errores_migracion_ddhh_'.$op.'.txt');
my $db= DBI->connect("DBI:mysql:$db_name:$db_host",$db_user, $db_passwd);
$db->do('SET NAMES utf8');
my $dbh = C4::Context->dbh;
#Migrar Desparecidos 
my $desaparecidos=$db->prepare("SELECT ddhhdesaparecidos.apellido, ddhhdesaparecidos.apellidodecasada, ddhhdesaparecidos.nombres, ddhhdesaparecidos_estado.descripcion as estado, ddhhdesaparecidos.fecha, ddhhdesaparecidos_condicion.descripcion as condicion, ddhhdesaparecidos_tipodoc.descripcion as tipodoc, ddhhdesaparecidos.documento, ddhhdesaparecidos.observaciones, ddhhdesaparecidos_dependencia.tipodependencia as tipodependencia, ddhhdesaparecidos_dependencia.descripcion as dependencia, ddhhdesaparecidos.archivofoto FROM ddhhdesaparecidos left join ddhhdesaparecidos_estado on ddhhdesaparecidos_estado.codestado = ddhhdesaparecidos.codestado left join ddhhdesaparecidos_condicion on ddhhdesaparecidos_condicion.codcondicion = ddhhdesaparecidos.codcondicion left join ddhhdesaparecidos_tipodoc on ddhhdesaparecidos_tipodoc.codtipodoc = ddhhdesaparecidos.codtipodoc left join ddhhdesaparecidos_dependencia on ddhhdesaparecidos_dependencia.coddependencia = ddhhdesaparecidos.coddependencia;");
$desaparecidos->execute();
my $cant =  $desaparecidos->rows;
my $count=0;
my $countexists=0;
while (my $desaparecido=$desaparecidos->fetchrow_hashref) {

    my $path = $desaparecido->{'archivofoto'};
    if (-e $path) {
        my $id2 = $countexists +1;
        my $uploaddir               = C4::Context->config("portadasNivel2Path");
        my $filename = basename($path);
        copy("$path","$uploaddir/$filename");
        $portadaNivel2 = C4::Modelo::CatRegistroMarcN2Cover->new();                
        $portadaNivel2->agregar($filename, $id2);  
        $countexists ++;
    } else {
           print "La foto $foto NO existe!!.\n"; 
    }

    $count ++;
    my $perc = ($count * 100) / $cant;
    my $rounded = sprintf "%.2f", $perc;
}

$desaparecidos->finish();

print "Personas : $count \n";
print "Fotos existen : $countexists \n";