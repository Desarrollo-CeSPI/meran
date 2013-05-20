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
use C4::AR::Presupuestos;
use CGI;
use JSON;
use Spreadsheet::Read;
use Spreadsheet::ParseExcel;
use C4::AR::XLSGenerator;
use C4::AR::PedidoCotizacionDetalle;

my $input               = new CGI;
my $authnotrequired     = 0;
my $obj                 = $input->param('obj');
$obj                    = C4::AR::Utilidades::from_json_ISO($obj);
my $tipoAccion          = $obj->{'tipoAccion'}||"";
my $token               = $obj->{'token'}; # usado para las exportaciones a xls


if($tipoAccion eq "GUARDAR_MODIFICACION_PRESUPUESTO"){

    my ($template, $session, $t_params)  = get_template_and_user({  
                        template_name   => "/adquisiciones/mostrarPresupuesto.tmpl",
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

     my ($Message_arrayref) = C4::AR::Presupuestos::actualizarPresupuesto($obj);   
  
     my $infoOperacionJSON  = to_json $Message_arrayref;
        
     C4::AR::Auth::print_header($session);
     print $infoOperacionJSON;

}

=item
Se procesa la planilla ingresada
=cut

elsif($tipoAccion eq "MOSTRAR_PRESUPUESTO"){

        my $filepath  = $obj->{'filepath'}||"";

        my ($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
                              template_name     => '/adquisiciones/mostrarPresupuesto.tmpl',
                              query             => $input,
                              type              => "intranet",
                              authnotrequired   => 0,
                              flagsrequired     => {    ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        tipo_permiso => 'general',
                                                        entorno => 'adq_intra'},
        });

        my $presupuestos_dir    = "/usr/share/meran/intranet/htdocs/intranet-tmpl/proveedores/";
        my $write_file          = $presupuestos_dir.$filepath;

        my $parser              = Spreadsheet::ParseExcel-> new();
        my $workbook            = $parser->parse($write_file);
    
        my $workbook_ref        = read_sxc($write_file);

        foreach ( sort keys %$workbook_ref ) {
                print "Worksheet ", $_, " contains ", $#{$$workbook_ref{$_}} + 1, " row(s):\n";
                foreach ( @{$$workbook_ref{$_}} ) {
                      foreach ( map { defined $_ ? $_ : '' } @{$_} ) {
                            print utf8(" '$_'")->as_string;
                      }
                      print "\n";
                }
        }
        
        my @table;
        my @reg;

        my $worksheet               = $workbook->worksheet(0);
        my ( $row_min, $row_max )   = $worksheet->row_range();

        my $id_pres                 = $worksheet->get_cell( 1, 1 )->value();
     

        for my $row ( $row_min + 3 .. $row_max ) {
                
                my %hash; 
                
                $hash{'renglon'}            = $worksheet->get_cell( $row, 0 )->value();        
                $hash{'cantidad'}           = $worksheet->get_cell( $row, 1 )->value();
                $hash{'articulo'}           = $worksheet->get_cell( $row, 2 )->value();   
                $hash{'precio_unitario'}    = $worksheet->get_cell( $row, 3 )->value();
                $hash{'total'}              = $worksheet->get_cell( $row, 4 )->value(); 
                              
                push(@reg, \%hash);  
                    
        }
    
        my $pres= C4::AR::Presupuestos::getPresupuestoPorID($id_pres);
        

        $t_params->{'datos_presupuesto'}    = \@reg;   
        $t_params->{'pres'}                 = $pres;

        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} #end if($tipoAccion eq "MOSTRAR_PRESUPUESTO")

elsif($tipoAccion eq "MOSTRAR_PRESUPUESTO_MANUAL"){

       
        my $id_pres= $obj->{'id_presupuesto'};

        my ($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
                              template_name     => '/adquisiciones/presupuestoManual.tmpl',
                              query             => $input,
                              type              => "intranet",
                              authnotrequired   => 0,
                              flagsrequired     => {    ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        tipo_permiso => 'general',
                                                        entorno => 'adq_intra'},
        });
        
    
        my $detalle_pres    = C4::AR::Presupuestos::getAdqPresupuestoDetalle($id_pres);
        my $pres            = C4::AR::Presupuestos::getPresupuestoPorID($id_pres);
        
        $t_params->{'pres'}                 =  $pres;
        $t_params->{'detalle_presupuesto'}  = $detalle_pres;
       
        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

        
} #end if($tipoAccion eq "MOSTRAR_PRESUPUESTO_MANUAL")


elsif($tipoAccion eq "AGREGAR_PRESUPUESTO"){

    my ($template, $session, $t_params) = get_template_and_user({
        template_name   => "adquisiciones/generatePresupuesto.tmpl",
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
   
    my $message;

    # recorremos los proveedores seleccionados y les agregamos el presupuesto
    for(my $i=0;$i<scalar(@{$obj->{'proveedores_array'}});$i++){
    
        my %params = {};
        
        $params{'id_proveedor'}           = $obj->{'proveedores_array'}->[$i];
        $params{'pedido_cotizacion_id'}   = $obj->{'pedido_cotizacion_id'};
        
        $message = C4::AR::Presupuestos::addPresupuesto(\%params);   
    }

    my $infoOperacionJSON   = to_json $message;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}# end if($tipoAccion eq "AGREGAR_PRESUPUESTO")

elsif($tipoAccion eq "EXPORTAR_PRESUPUESTO"){

    # para tener $session nada mas
    my ($template, $session, $t_params) = get_template_and_user({
        template_name   => "includes/partials/proveedores/linksExportacion.tmpl",
        query           => $input,
        type            => "intranet",
        authnotrequired => 0,
        flagsrequired   => {    ui => 'ANY', 
                                tipo_documento => 'ANY', 
                                accion => 'CONSULTA', 
                                tipo_permiso => 'general',
                                entorno => 'adq_intra'}, # FIXME
        debug           => 1,
    });

    $t_params->{'pedido_cotizacion_id'} = $obj->{'pedido_cotizacion_id'};
 
    # arreglo con los path para hacer los links de descargas
    my @paths_array;
    my @id_proveedor_array;
    for(my $i = 0; $i < scalar(@{$obj->{'proveedores_array'}}); $i++){ 

        my $proveedor       = C4::AR::Proveedores::getProveedorInfoPorId($obj->{'proveedores_array'}->[$i]);  
        my $tipo_proveedor  = C4::AR::Proveedores::isPersonaFisica($obj->{'proveedores_array'}->[$i]);
        
        $id_proveedor_array[$i] = $obj->{'proveedores_array'}->[$i];
               
        my $nombre_proveedor;
        if($tipo_proveedor == 0){
            $nombre_proveedor = $proveedor->getRazonSocial();
        }else{
            $nombre_proveedor = $proveedor->getNombre();
        }
        
        $paths_array[$i] = "presupuesto".$nombre_proveedor.".xls";
    } 
   $t_params->{'nombres'}   =  \@paths_array;
   $t_params->{'ids_array'} =  \@id_proveedor_array;
   $t_params->{'token'}     = $token;
   C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}# end if($tipoAccion eq "EXPORTAR_PRESUPUESTO")