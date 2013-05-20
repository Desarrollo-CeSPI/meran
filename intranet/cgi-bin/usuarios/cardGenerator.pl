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

require Exporter;

use strict;
use CGI;
use C4::Context;
use C4::AR::Auth;
use PDF::Report;
use C4::AR::PdfGenerator;

my $input= new CGI;
my $authnotrequired= 0;

my ($userid, $session, $flags) = C4::AR::Auth::checkauth(   $input, 
                                                        $authnotrequired,
                                                        {   ui => 'ANY', 
                                                            tipo_documento => 'ANY', 
                                                            accion => 'MODIFICACION', 
                                                            entorno => 'usuarios'
                                                        },
                                                        "intranet"
                            );

my $nro_socio = $input->param('nro_socio');

my $tmpFileName= $nro_socio.".pdf";
my $pdf = C4::AR::PdfGenerator::cardGenerator($nro_socio);
print "Content-type: application/pdf\n";
print "Content-Disposition: attachment; filename=\"$tmpFileName\"\n\n";
print $pdf->Finish();