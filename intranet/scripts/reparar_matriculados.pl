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
use lib qw(/usr/local/share/meran/dev/intranet/modules/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl5/);

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

my $op = $ARGV[0] || 0;
my $from = $ARGV[1] || 0;
my $to = $ARGV[2] || 0;

my $db_driver =  "mysql";
my $db_name   = 'calp_matriculas';
my $db_host   = 'db';
my $db_user   = 'root';
my $db_passwd = 'dev';


my $db_calp= DBI->connect("DBI:mysql:$db_name:$db_host",$db_user, $db_passwd);
$db_calp->do('SET NAMES utf8');

my $dbh = C4::Context->dbh;


	print "SET NAMES utf8; \n"; 
	
	my $mat_calp=$db_calp->prepare("SELECT name ,lastname, document_number FROM people;");
	$mat_calp->execute();

	while (my $mat=$mat_calp->fetchrow_hashref) {

		print 'UPDATE usr_persona SET nombre ="'.$mat->{'name'}.'", apellido ="'.$mat->{'lastname'}.'" WHERE nro_documento ="'.$mat->{'document_number'}.'"'.";\n"; 
	}
	
	$mat_calp->finish();


