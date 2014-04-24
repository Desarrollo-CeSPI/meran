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
use C4::AR::Utilidades;
use C4::Modelo::RefPais;
use C4::Modelo::CatAutor;

my $db_driver =  "mysql";
my $db_name   = 'calp_paradox';
my $db_host   = 'localhost';
my $db_user   = 'root';
my $db_passwd = 'dev';

my $db_calp= DBI->connect("DBI:mysql:$db_name:$db_host",$db_user, $db_passwd);
$db_calp->do('SET NAMES utf8');

my $dbh = C4::Context->dbh;

sub migrarAutores {
	#Leemos los Autores
	my $autores_calp=$db_calp->prepare("SELECT AUTORES.Nombre as nombre ,AUTORES.Apellido as apellido,TC_PAIS.Descripcion as pais FROM AUTORES left join TC_PAIS on AUTORES.CodPais=TC_PAIS.CodPais;");
	$autores_calp->execute();

	while (my $autor=$autores_calp->fetchrow_hashref) {
		my $completo = $autor->{'apellido'};
		if ($autor->{'nombre'}){
			$completo.=", ".$autor->{'nombre'}
		}
		
		#YA EXISTE EL AUTOR?
		my @filtros=();
        push(@filtros, (completo => {eq => $completo}) );
        my $existe = C4::Modelo::CatAutor::Manager->get_cat_autor_count(query => \@filtros,);

        if (!$existe){
			my $nacionalidad = '';
			if ($autor->{'pais'}){
				$nacionalidad= $autor->{'pais'};
	            my ($cantidad, $objetos) = (C4::Modelo::RefPais->new())->getPaisByName($autor->{'pais'});
	            if($cantidad){
	                C4::AR::Debug::debug("encontro pais =>".$objetos->[0]->getNombre());
	                $nacionalidad= $objetos->[0]->getIso3();
	            }
	    	}

			my $nuevo_autor=$dbh->prepare("INSERT into cat_autor (nombre,apellido,completo,nacionalidad) values (?,?,?,?);");
	        $nuevo_autor->execute($autor->{'nombre'},$autor->{'apellido'},$completo, $nacionalidad);
		}
	}
	
	$autores_calp->finish();
}

1;
