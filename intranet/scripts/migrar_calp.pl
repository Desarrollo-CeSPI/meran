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

#use CGI::Session;
#use C4::Context;

my $db_driver =  "mysql";

my $db_name   = 'calp_paradox';
my $db_host   = 'localhost';
my $db_user   = 'root';
my $db_passwd = 'dev';

my $db_calp= DBI->connect("DBI:mysql:$db_name:$db_host",$db_user, $db_passwd);
$db_calp->do('SET NAMES utf8');



	#Leemos los Autores
	my $autores_calp=$db_calp->prepare("SELECT * FROM AUTORES;");
	$autores_calp->execute();

	while (my $autor=$autores_calp->fetchrow_hashref) {
		print "INSERT $autor->{'Nombre'};";	
		my $completo = $autor->{'Apellido'};
		if ($autor->{'Nombre'}){$completo.=", ".$autor->{'Nombre'}}

		my $nuevo_autor=$dbh->prepare("INSERT into cat_autor (nombre,apellido,completo) values (?,?,?);");
        $nuevo_autor->execute($autor->{'Nombre'},$autor->{'Apellido'},$completo);
	}
	
	$autores_calp->finish();

1;
