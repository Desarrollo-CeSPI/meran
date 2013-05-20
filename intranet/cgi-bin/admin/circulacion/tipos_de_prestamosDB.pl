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

use Template;
use C4::AR::Prestamos;
use JSON;

my $input = new CGI;
my $obj=$input->param('obj');
$obj=C4::AR::Utilidades::from_json_ISO($obj);

my $tipoAccion = $obj->{'tipoAccion'};
my $id_tipo_prestamo = $obj->{'tipo_prestamo'};
$obj->{'id_tipo_prestamo'}=$obj->{'tipo_prestamo'};

my $authnotrequired = 0;

if ($tipoAccion eq 'MODIFICAR_TIPO_PRESTAMO') {

my ($template, $session, $t_params) = get_template_and_user({
                template_name => "admin/circulacion/agregarTipoPrestamo.tmpl",
                query => $input,
                type => "intranet",
                authnotrequired => 0,
                flagsrequired => {  ui => 'ANY', 
                                    tipo_documento => 'ANY', 
                                    accion => 'CONSULTA', 
                                    entorno => 'undefined'},
                debug => 1,
          });

	if ($id_tipo_prestamo) {
        my $tipo_prestamo=C4::AR::Prestamos::getTipoPrestamo($id_tipo_prestamo);
        $t_params->{'tipo_prestamo'}= $tipo_prestamo;
        }

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} 
elsif ($tipoAccion eq 'NUEVO_TIPO_PRESTAMO') {

my ($template, $session, $t_params) = get_template_and_user({
                template_name => "admin/circulacion/agregarTipoPrestamo.tmpl",
                query => $input,
                type => "intranet",
                authnotrequired => 0,
                flagsrequired => {  ui => 'ANY', 
                                    tipo_documento => 'ANY', 
                                    accion => 'CONSULTA',  
                                    entorno => 'undefined'},
                debug => 1,
            });

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} 
elsif ($tipoAccion eq 'GUARDAR_MODIFICACION_TIPO_PRESTAMO'){

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'undefined'},
                                            "intranet"
                                );

    my $Message_arrayref = &C4::AR::Prestamos::t_modificarTipoPrestamo($obj);
    my $infoOperacionJSON=to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif ($tipoAccion eq 'AGREGAR_TIPO_PRESTAMO') {

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'ALTA', 
                                                entorno => 'undefined'},
                                            "intranet"
                                );

    my $Message_arrayref = &C4::AR::Prestamos::t_agregarTipoPrestamo($obj);
    my $infoOperacionJSON=to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}
# TODO falta validar que el tipo de prestamo no tenga referencias antes de eliminar
# elsif ($tipoAccion eq 'BORRAR') {
# 
#     my ($userid, $session, $flags) = checkauth( $input, 
#                                             $authnotrequired,
#                                             {   ui => 'ANY', 
#                                                 tipo_documento => 'ANY', 
#                                                 accion => 'BAJA', 
#                                                 entorno => 'undefined'},
#                                             "intranet"
#                                 );
# 
#     my $Message_arrayref = &C4::AR::Prestamos::t_eliminarTipoPrestamo($id_tipo_prestamo);
#     my $infoOperacionJSON=to_json $Message_arrayref;
#     C4::AR::Auth::print_header($session);
#     print $infoOperacionJSON;
# }


if ($tipoAccion eq 'TIPOS_PRESTAMOS') {

my ($template, $session, $t_params) = get_template_and_user({
                            template_name => "admin/circulacion/tipos_de_prestamos_lista.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'undefined'},
                            debug => 1,
                });

my $tipos_de_prestamos=C4::AR::Prestamos::getTiposDePrestamos();
$t_params->{'TIPOS_PRESTAMOS_LOOP'}         = $tipos_de_prestamos;
$t_params->{'TIPOS_PRESTAMOS_LOOP_COUNT'}   = scalar(@$tipos_de_prestamos);

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}