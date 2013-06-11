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
use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use  C4::AR::Utilidades;
use JSON;
use CGI;

my $query = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                template_name   => "opac-main.tmpl",
                                query           => $query,
                                type            => "opac",
                                authnotrequired => 1,
                                flagsrequired   => {  ui            => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
            });


use C4::Modelo::Contacto;

my ($contacto)  = C4::Modelo::Contacto->new();
my $msg_object  = C4::AR::Mensajes::create();
my $obj = $query->param('obj');
my $socio_reporte = C4::AR::Auth::getSessionSocioObject();
$obj    = C4::AR::Utilidades::from_json_ISO($obj);

    #verificamos que los campos requeridos tengan valor
if( C4::AR::Utilidades::validateString($obj->{'informe'}) ){
    $contacto->reporteCatalogo($obj,$socio_reporte);
    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U609', 'params' => []} ) ;
    $msg_object->{'success'} = 1;
}

my $infoOperacionJSON=to_json $msg_object;

C4::AR::Auth::print_header($session);
print $infoOperacionJSON;