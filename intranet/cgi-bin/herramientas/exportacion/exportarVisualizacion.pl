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
use C4::AR::Auth;
use CGI;
use DBI;
use DBIx::XML_RDB;
use warnings;
use C4::Context;

my $query   = new CGI;
my $context = new C4::Context;

my $tipo    = $query->param('tipo');

my $user    = $context->config('userINTRA');
my $pass    = $context->config('passINTRA');
my $db      = $context->config('database');

my $dsn     = "dbi:mysql:dbname=" . $db .";host=localhost";

my $path;
my $fileName;

eval{

    my $xmlout  = DBIx::XML_RDB->new ($dsn, "mysql", $user, $pass, $db) or die "Failed to make new xmlout";

    if($tipo eq "opac"){

        $fileName = 'MERAN-visualizacionOpac.xml';

        $xmlout->DoSql( "select campo, tipo_ejemplar, pre, post, subcampo, vista_opac, vista_campo, orden, "
                ." orden_subcampo, nivel FROM cat_visualizacion_opac");

    }else{

        $fileName = 'MERAN-visualizacionIntra.xml';

        $xmlout->DoSql( "select campo, tipo_ejemplar, pre, post, subcampo, vista_intra, vista_campo, orden, "
                ." orden_subcampo, nivel FROM cat_visualizacion_intra");
    }
    
    my $file  = $xmlout->GetData;
    $path     = '/tmp/' . $fileName;

    #escribirlo en /tmp
    open(WRITEIT, ">:encoding(UTF-8)", $path) or die "\nCant write to $path Reason: $!\n";
    print WRITEIT $file;
    close(WRITEIT);

    open INF, $path or die "\nCan't open $path for reading: $!\n";

    print $query->header(
                          -type           => 'application/xml', 
                          -attachment     => $fileName,
                          -expires        => '0',
                      );
    my $buffer;

    while (read (INF, $buffer, 65536) and print $buffer ) {};

};

if($@){
  C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/mainpage.pl');
}