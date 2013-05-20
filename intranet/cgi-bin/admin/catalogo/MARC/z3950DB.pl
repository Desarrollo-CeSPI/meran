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
use JSON;
use C4::AR::Z3950;

my $input           = new CGI;
my $obj             = $input->param('obj');
$obj                = C4::AR::Utilidades::from_json_ISO($obj);
my $accion          = $obj->{'tipoAccion'};
my $authnotrequired = 0;


if($accion eq "ACTUALIZAR_TABLA_SERVERS"){

    my ($template, $session, $t_params)  = get_template_and_user({
                        	template_name   => "z3950/z3950Result.tmpl",
							query           => $input,
							type            => "intranet",
							authnotrequired => 0,
							flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
							debug           => 1,
			     });
			     
	my $servers_array_ref           = C4::AR::Z3950::getAllServidoresZ3950();

	$t_params->{'servers'}          = $servers_array_ref;
	
	C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
	
}#end if($accion eq "ACTUALIZAR_TABLA_SERVERS")

elsif($accion eq "AGREGAR_SERVIDOR"){

    my ($template, $session, $t_params)  = get_template_and_user({
                        	template_name   => "z3950/addServer.tmpl",
							query           => $input,
							type            => "intranet",
							authnotrequired => 0,
							flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
							debug           => 1,
			     });
			     
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);			     

}#end if($accion eq "AGREGAR_SERVIDOR")

elsif($accion eq "GUARDAR_NUEVO_SERVIDOR"){

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'BAJA', 
                                                entorno         => 'undefined'},
                                            "intranet"
                                );
                                



    my $Message_arrayref    = C4::AR::Z3950::agregarServidorZ3950($obj);
    my $infoOperacionJSON   = to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}#end if($accion eq "GUARDAR_NUEVO_SERVIDOR")

elsif($accion eq "EDITAR_SERVIDOR"){

    my ($template, $session, $t_params)  = get_template_and_user({
                        	template_name   => "z3950/addServer.tmpl",
							query           => $input,
							type            => "intranet",
							authnotrequired => 0,
							flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
							debug           => 1,
			     });
			     
	$t_params->{'editing'}          = 1;
	$t_params->{'servidor'}         = C4::AR::Z3950::getServidorPorId($obj->{'id_servidor'});
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);	

}#end if($accion eq "EDITAR_SERVIDOR")

elsif($accion eq "ELIMINAR_SERVIDOR"){

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'BAJA', 
                                                entorno         => 'undefined'},
                                            "intranet"
                                );
                                



    my $Message_arrayref    = C4::AR::Z3950::eliminarServidorZ3950($obj->{'id_servidor'});
    my $infoOperacionJSON   = to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}#end if($accion eq "ELIMINAR_SERVIDOR")

elsif($accion eq "GUARDAR_MODIFICACION_SERVIDOR"){

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'BAJA', 
                                                entorno         => 'undefined'},
                                            "intranet"
                                );
                                



    my $Message_arrayref    = C4::AR::Z3950::editarServidorZ3950($obj->{'id_servidor'},$obj);
    my $infoOperacionJSON   = to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;


}#end if($accion eq "GUARDAR_MODIFICACION_SERVIDOR")

elsif ($accion eq "DESHABILITAR_SERVIDOR"){

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'BAJA', 
                                                entorno         => 'undefined'},
                                            "intranet"
                                );
                                



    my $Message_arrayref    = C4::AR::Z3950::deshabilitarServerZ3950($obj->{'id_servidor'});
    my $infoOperacionJSON   = to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;


}#end if($accion eq "DESHABILITAR_SERVIDOR")