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
use C4::Context;
use C4::AR::Debug;
use C4::AR::Auth;
use C4::AR::Usuarios;

my $db_name   = C4::Context->config("database");
my $db_host   = C4::Context->config("hostname");
my $db_user   = C4::Context->config("user");
my $db_passwd = C4::Context->config("pass");

my $db_exactas = DBI->connect("DBI:mysql:$db_name:$db_host",$db_user, $db_passwd);
$db_exactas->do('SET NAMES utf8');

C4::AR::Debug::debug("Corriendo script para reparar socios sin permisos");

my $socios = $db_exactas->prepare("SELECT nro_socio FROM usr_socio WHERE nro_socio NOT IN (SELECT nro_socio FROM `perm_circulacion` WHERE 1)");
$socios->execute();

C4::AR::Debug::debug("Asignando Permisos de Circulación");
procesar_socios_perm_circ($socios);

my $socios = $db_exactas->prepare("SELECT nro_socio FROM usr_socio WHERE nro_socio NOT IN (SELECT nro_socio FROM `perm_catalogo` WHERE 1)");
$socios->execute();

C4::AR::Debug::debug("Asignando Permisos de Catalogación");
procesar_socios_perm_cat($socios);

my $socios = $db_exactas->prepare("SELECT nro_socio FROM usr_socio WHERE nro_socio NOT IN (SELECT nro_socio FROM `perm_general` WHERE 1)");
$socios->execute();

C4::AR::Debug::debug("Asignando Permisos Generales");
procesar_socios_perm_gen($socios);


sub procesar_socios_perm_circ {
	my ($socios) 	= @_;
	my $cant 			= 0;

	while (my $socio = $socios->fetchrow_hashref) {
		$nro_socio 				= $socio->{'nro_socio'};
		C4::AR::Debug::debug("Procesando usuario $nro_socio");

		my $permiso_circ 	= C4::Modelo::PermCirculacion->new();

		my $s = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);

		$permiso_circ->convertirEnEstudiante($s);
		$cant++;
	}

	C4::AR::Debug::debug("Se repararon $cant permisos");
}

sub procesar_socios_perm_cat {
	my ($socios) 	= @_;
	my $cant 			= 0;

	while (my $socio = $socios->fetchrow_hashref) {
		$nro_socio 				= $socio->{'nro_socio'};
		C4::AR::Debug::debug("Procesando usuario $nro_socio");

		my $permiso_cat 	= C4::Modelo::PermCatalogo->new();

		my $s = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);

		$permiso_cat->convertirEnEstudiante($s);
		$cant++;
	}

	C4::AR::Debug::debug("Se repararon $cant permisos");
}

sub procesar_socios_perm_gen {
	my ($socios) 	= @_;
	my $cant 			= 0;

	while (my $socio = $socios->fetchrow_hashref) {
		$nro_socio 				= $socio->{'nro_socio'};
		C4::AR::Debug::debug("Procesando usuario $nro_socio");

		my $permiso_gen 	= C4::Modelo::PermGeneral->new();

		my $s = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);

		$permiso_gen->convertirEnEstudiante($s);
		$cant++;
	}

	C4::AR::Debug::debug("Se repararon $cant permisos");
}

1;

