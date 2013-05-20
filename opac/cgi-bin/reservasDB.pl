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
use CGI;
use C4::AR::Auth;
use C4::AR::Utilidades;
use JSON;

my $input           = new CGI;
my $authnotrequired = 0;
my ($nro_socio, $session, $flags) = checkauth( $input, 
                                        $authnotrequired,
                                        {   ui              => 'ANY', 
                                            tipo_documento  => 'ANY', 
                                            accion          => 'CONSULTA', 
                                            entorno         => 'usuarios'
                                        },
                                        "opac"
                            );

my $session = CGI::Session->load();
my $obj     = $input->param('obj');
$obj        = C4::AR::Utilidades::from_json_ISO($obj);

my %params;
$params{'id_reserva'}   = $obj->{'id_reserva'};
$params{'nro_socio'}    = $nro_socio;
$params{'responsable'}  = $nro_socio;
$params{'type'}         = "opac";

my $msg_object;

if ($obj->{'accion'} eq 'CANCELAR_RESERVA'){
    ($msg_object) = C4::AR::Reservas::t_cancelar_reserva(\%params);
}
elsif ($obj->{'accion'} eq 'CANCELAR_Y_RESERVAR'){
    $params{'id1'} = $obj->{'id1Nuevo'};
    $params{'id2'} = $obj->{'id2Nuevo'};
    ($msg_object)  = C4::AR::Reservas::t_cancelar_y_reservar(\%params);
}

my $infoOperacionJSON = to_json $msg_object;

C4::AR::Auth::print_header($session);
print $infoOperacionJSON;