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
use C4::AR::Proveedores;
use CGI;
use JSON;

my $input           = new CGI;
my $authnotrequired = 0;
my $obj             = $input->param('obj');
$obj                = C4::AR::Utilidades::from_json_ISO($obj);
my $tipoAccion      = $obj->{'tipoAccion'}||"";

=item
    Se elimina el Proveedor
=cut

if($tipoAccion eq "ELIMINAR"){

        my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'BAJA', 
                                                tipo_permiso => 'general',
                                                entorno => 'adq_intra'},
                                                "intranet"
                                    );
                                    
        my $id_proveedor        = $obj->{'id_proveedor'};

        my ($Message_arrayref)  = C4::AR::Proveedores::eliminarProveedor($id_proveedor);
        my $infoOperacionJSON   = to_json $Message_arrayref;

        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;

    } #end if($tipoAccion eq "ELIMINAR_USUARIO")

=item
Se guarda la modificacion los datos del Proveedor
=cut
elsif($tipoAccion eq "GUARDAR_MODIFICACION_PROVEEDOR"){

      my ($nro_socio, $session, $flags) = checkauth( 
                                               $input, 
                                               $authnotrequired,
                                               {   ui               => 'ANY', 
                                                   tipo_documento   => 'ANY', 
                                                   accion           => 'MODIFICACION', 
                                                   tipo_permiso => 'general',
                                                   entorno => 'adq_intra'},   
                                                   "intranet"
                                );    

        my ($Message_arrayref)  = C4::AR::Proveedores::editarProveedor($obj);
        my $infoOperacionJSON   = to_json $Message_arrayref;
        
        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;

 } #end if($tipoAccion eq "GUARDAR_MODIFICACION_USUARIO")

=item
Se guarda una nueva moneda del proveedor
=cut
elsif($tipoAccion eq "GUARDAR_MONEDA_PROVEEDOR"){

    my ($template, $session, $t_params)  = get_template_and_user({  
                        template_name   => "includes/partials/proveedores/mostrar_monedas.tmpl",
                        query           => $input,
                        type            => "intranet",
                        authnotrequired => 0,
                        flagsrequired   => {    ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICAR', 
                                                tipo_permiso => 'general',
                                                entorno => 'adq_intra'},
                        debug           => 1,
                    });


    my ($Message_arrayref) = C4::AR::Proveedores::agregarMoneda($obj);   

    my $monedas;

    if($Message_arrayref->{'error'} == 0){
#   la moneda fue agregada con exito, recargamos el div de las monedas en el tmpl

        $monedas                = C4::AR::Proveedores::getMonedasProveedor($obj->{'id_proveedor'});
        $t_params->{'monedas'}  = $monedas;
        
    }

  C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} #end if($tipoAccion eq "GUARDAR_MONEDA_PROVEEDOR")

elsif($tipoAccion eq "ELIMINAR_MONEDA_PROVEEDOR"){

    my ($template, $session, $t_params)  = get_template_and_user({  
                        template_name   => "includes/partials/proveedores/mostrar_monedas.tmpl",
                        query           => $input,
                        type            => "intranet",
                        authnotrequired => 0,
                        flagsrequired   => {    ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                tipo_permiso => 'general',
                                                entorno => 'adq_intra'},
                        debug           => 1,
    });

#   le mandamos un arreglo con ids de las monedas a eliminar
    my ($Message_arrayref) = C4::AR::Proveedores::eliminarMoneda($obj);
          

    my $monedas;
 
    if($Message_arrayref->{'error'} == 0){
#   la moneda fue agregada con exito, recargamos el div de las monedas en el tmpl

         $monedas = C4::AR::Proveedores::getMonedasProveedor($obj->{'id_proveedor'});
         $t_params->{'monedas'} = $monedas;
    }
    
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} #end if($tipoAccion eq "ELIMINAR_MONEDA_PROVEEDOR")