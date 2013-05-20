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
# NOTE: This file uses standard 8-character tabs

use strict;
require Exporter;
use CGI;
use C4::AR::Auth;        
use C4::AR::Reservas;
use JSON;
use C4::AR::Mensajes;

my $input = new CGI;
my ($template, $session, $t_params)= get_template_and_user({
                                  template_name => "opac-reservar.tmpl",
                                  query => $input,
                                  type => "opac",
                                  authnotrequired => 0,
                                  flagsrequired => {    ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'circ_opac', 
                                                        tipo_permiso => 'circulacion'},
                                  debug => 1,
});

my $obj = $input->param('obj');
$obj    = C4::AR::Utilidades::from_json_ISO($obj);


my $id1                     = $obj->{'id1'};
my $id2                     = $obj->{'id2'};
my $socio                   = $session->param('userid');

my %params;
$params{'tipo'}             = 'OPAC';
$params{'id1'}              = $id1;
$params{'id2'}              = $id2;
$params{'nro_socio'}        = $socio;
$params{'responsable'}      = $socio;
$params{'tipo_prestamo'}    = 'DO';
$params{'es_reserva'}       = 1;

my ($msg_object)            = C4::AR::Reservas::t_reservarOPAC(\%params);

my $infoOperacionJSON       = to_json $msg_object;
  
C4::AR::Auth::print_header($session);
print $infoOperacionJSON; 