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
use C4::AR::PedidoCotizacion;
use C4::AR::Recomendaciones;
use CGI;
use JSON;

my $input           = new CGI;
my $authnotrequired = 0;
my $obj             = $input->param('obj');
$obj                = C4::AR::Utilidades::from_json_ISO($obj);
my $tipoAccion      = $obj->{'tipoAccion'}||"";

if($tipoAccion eq "AGREGAR_PEDIDO_COTIZACION"){

    my %params = {};
        
    $params{'recomendaciones_array'}       = $obj->{'recomendaciones_array'};
    $params{'cantidad_ejemplares_array'}   = $obj->{'cantidades_array'};
        
    my ($message) = C4::AR::PedidoCotizacion::addPedidoCotizacion(\%params);  


    my ($userid, $session, $flags) = checkauth( $input, $authnotrequired,
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'ALTA', 
                                                tipo_permiso => 'general',
                                                entorno => 'adq_intra'},
                                                "intranet"
                                            );                              
    my $infoOperacionJSON = to_json $message;
    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;                        
}

elsif($tipoAccion eq "APPEND_PEDIDO_COTIZACION"){

    # agregamos pedido_cotizacion_detalle (uno o varios) al pedido de cotizacion 
    # que se esta editando en el momento, se va a guardar sin recomendacion_detalle_id
    
    my %params = {};
        
    # id del pedido_cotizacion padre de los detalles
    $params{'pedido_cotizacion_id'}  = $obj->{'pedido_cotizacion_id'};
    
    # los ids de los ejemplares a agregar
    $params{'ejemplares_ids_array'}  = $obj->{'ejemplares_ids_array'};
    
    # array con las cantidades de ejemplares
    $params{'cant_ejemplares_array'} = $obj->{'cant_ejemplares_array'};
        
    my ($message) = C4::AR::PedidoCotizacion::appendPedidoCotizacion(\%params);  


    my ($userid, $session, $flags) = checkauth( $input, $authnotrequired,
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'ALTA', 
                                                tipo_permiso => 'general',
                                                entorno => 'adq_intra'},
                                                "intranet"
                                            );                              
    my $infoOperacionJSON = to_json $message;
    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;                        
}

elsif($tipoAccion eq "PRESUPUESTAR"){

    # se devuelve el combo de proveedores para poder presupuestarlos
    
    my ($template, $session, $t_params) = get_template_and_user({
                                    template_name   => "includes/partials/proveedores/generatePresupuesto.tmpl",
                                    query           => $input,
                                    type            => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired   => {    ui => 'ANY', 
                                                            tipo_documento => 'ANY', 
                                                            accion => 'CONSULTA', 
                                                            tipo_permiso => 'general',
                                                            entorno => 'adq_intra'},
                                    debug           => 1,
                            });
    
    my $combo_proveedores               = &C4::AR::Utilidades::generarComboProveedoresMultiple();
    $t_params->{'pedido_cotizacion_id'} = $obj->{'pedido_cotizacion_id'};
    $t_params->{'combo_proveedores'}    = $combo_proveedores;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}

elsif($tipoAccion eq "AGREGAR_PEDIDO_COTIZACION_DETALLE"){

    # se muestra el template de busquedas de ejemplares del OPAC

    my ($template, $session, $t_params) = get_template_and_user({
                                    template_name   => "adquisiciones/addPedidoCotizacion.tmpl",
                                    query           => $input,
                                    type            => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired   => {    ui => 'ANY', 
                                                            tipo_documento => 'ANY', 
                                                            accion => 'ALTA', 
                                                            tipo_permiso => 'general',
                                                            entorno => 'adq_intra'},
                                    debug           => 1,
                            });


    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);    
}