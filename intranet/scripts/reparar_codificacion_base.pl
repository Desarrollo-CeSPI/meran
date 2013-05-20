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
use C4::Context;
use CGI::Session;

my $base = C4::Context->config('database');

my $dbh = C4::Context->dbh;
my @tables = $dbh->tables;

my $sql_base = "ALTER DATABASE $base DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;";
my $sth0=$dbh->prepare($sql_base);
   $sth0->execute();

foreach my $table (@tables){
	my @t = split(/\./,$table);
	chop($t[1]);
	my $tabla=substr($t[1],1);

	my $sql_tabla = "ALTER TABLE $tabla CONVERT TO CHARACTER SET utf8;";
  	my $sth1=$dbh->prepare($sql_tabla);
  	$sth1->execute();

	my $desc = $dbh->selectall_arrayref("DESCRIBE $tabla", { Columns=>{} });
  	foreach my $row (@$desc) {
       		my $tipo = $row->{'Type'};
       		my $columna = $row->{'Field'};
		if(($tipo =~ m/char/) || ($mystring =~ m/text/)){
			my $sql_columna1="ALTER TABLE $tabla CHANGE $columna $columna BLOB;";
			my $sth2=$dbh->prepare($sql_columna1);
  			$sth2->execute();

			my $sql_columna2="ALTER TABLE $tabla CHANGE $columna $columna $tipo CHARACTER SET utf8 COLLATE utf8_general_ci ;";
			my $sth3=$dbh->prepare($sql_columna2);
  			$sth3->execute();
		}
   	}
}