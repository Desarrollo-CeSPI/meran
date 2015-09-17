#!/usr/bin/perl  
#
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
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
#

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
use C4::Modelo::CatRegistroMarcN2Analitica;
use C4::AR::Nivel3;


use File::Fetch;


my $op = $ARGV[0] || 0;

my $db_driver =  "mysql";
my $db_name   = 'base_mpf';
my $db_host   = 'localhost';
my $db_user   = 'root';
my $db_passwd = 'dev';

my $uri = "http://www.mpf.gob.ar/repositoriosab/";

my $uri_indice = "ImagenesIndices/";
my $uri_tapa = "ImagenesTapas/";


my $db_mpf= DBI->connect("DBI:mysql:$db_name:$db_host",$db_user, $db_passwd);
$db_mpf->do('SET NAMES utf8');

my $dbh = C4::Context->dbh;

#Leemos los Autores
my $ejemplares=$db_mpf->prepare("SELECT ejemplar_codigo_barra,	ejemplar_tapa, ejemplar_indice FROM tb_ejemplar WHERE ejemplar_codigo_barra != '';");
$ejemplares->execute();

$no=0;
$si=0;
$tapas=0;
$indices=0;
while (my $ejemplar=$ejemplares->fetchrow_hashref) {
	my $codigo_barra = $ejemplar->{'ejemplar_codigo_barra'};
	my $n3 = C4::AR::Nivel3::getNivel3FromBarcode("MPF-LIB-".$codigo_barra);

	if($n3 && $n3->nivel1){
		$si++;

		if ($ejemplar->{'ejemplar_tapa'}){
			my $fu = $uri.$uri_tapa.$ejemplar->{'ejemplar_tapa'};
			print "Buscando Tapa... ".$fu."\n";
	  		my $ff = File::Fetch->new(uri => $fu);
	  		$ff->fetch(to => '/usr/share/meran/dev/files/mpf/tapas/');
	  		if ($ff->error()){
	  			print $ff->error()."\n";
	  		}else{
	  			$tapas++;
	  		}
	  	}

		if ($ejemplar->{'ejemplar_indice'}){
			my $fu = $uri.$uri_indice.$ejemplar->{'ejemplar_indice'};
			print "Buscando Indice... ".$fu."\n";
	  		my $ff = File::Fetch->new(uri => $fu);
	  		$ff->fetch(to => '/usr/share/meran/dev/files/mpf/indices/');
	  		if ($ff->error()){
	  			print $ff->error()."\n";
	  		}else{
	  			$indices++;
	  		}
	  	}

	}else{
		$no++;
	}
}

$ejemplares->finish();

print "Encontrados ".$si."\n";
print "NO encontrados ".$no."\n";
print "Tapas bajadas ".$tapas."\n";
print "Indices bajados ".$indices."\n";