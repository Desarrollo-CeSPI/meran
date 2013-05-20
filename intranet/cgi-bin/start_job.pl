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
use strict;
require Exporter;
use C4::AR::Auth;
use CGI;
use JSON;
use C4::AR::BackgroundJob;
use Proc::Simple;
use C4::AR::Utilidades;
use C4::AR::ImportacionIsoMARC;

my $input = new CGI;
my $obj=$input->param('obj');
my $job;

$obj=C4::AR::Utilidades::from_json_ISO($obj);

my $accion = $obj->{'accion'};


if ($accion eq "START_DEMO"){
	
	 $job = C4::AR::BackgroundJob->new("DEMO","NULL",0);
     my $proc = Proc::Simple->new();
     
     $proc->start(\&C4::AR::Utilidades::demo_test,$job);
     C4::AR::Auth::printValue($job->id);
     
}elsif ($accion eq "COMENZAR_IMPORTACION"){

	 $job = C4::AR::BackgroundJob->new("IMPORTACION",C4::AR::Auth::getSessionNroSocio,10);
     my $proc = Proc::Simple->new();
     my $id = $obj->{'id'};

#http://search.cpan.org/dist/Proc-Simple/Simple.pm#METHODS

     $proc->start(\&C4::AR::ImportacionIsoMARC::procesarImportacion,$id,$job);
     C4::AR::Auth::printValue($job->id);

}