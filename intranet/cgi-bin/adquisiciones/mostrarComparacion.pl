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
use C4::AR::Presupuestos;
use C4::AR::Recomendaciones;
use C4::AR::XLSGenerator;
use CGI;
use JSON;

# -------------------------  VA EN RecomendacionesDB ----------------------


my $input = new CGI;
my $authnotrequired= 0;

my $obj=$input->param('obj');

$obj = C4::AR::Utilidades::from_json_ISO($obj);

my $tipoAccion  = $obj->{'tipoAccion'}||"";

if($tipoAccion eq "MOSTRAR_PRESUPUESTOS_PEDIDO"){

        my $id_pedido= $obj->{'pedido_cotizacion'};

        my ($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
                              template_name   => '/adquisiciones/mostrarComparacion.tmpl',
                              query       => $input,
                              type        => "intranet",
                              authnotrequired => 0,
                              flagsrequired   => {  ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    tipo_permiso => 'general',
                                                    entorno => 'adq_intra'},
        });
      

#------------------ Se Recuperan los presupuestos para un pedido de cotizacion dado--------------------------
     
        my $presupuestos = C4::AR::PedidoCotizacion::getPresupuestosPedidoCotizacion($id_pedido);

# -----------------------------------------------------------------------------------------------------------

#------------------ Se Recuperan los datos del pedido de cotizacion------------------------------------------

        my $detalle_pedido = C4::AR::PedidoCotizacion::getAdqPedidoCotizacionDetalle($id_pedido);
        
# -----------------------------------------------------------------------------------------------------------

        
        my $detalles;
        my @resultado;

        my $renglon=1;
        my @array_mejor_pres;  
        
        

        foreach my $det (@$detalle_pedido){           
                    my %hash_mejor_pres;
                    my %hash_detalle;
                    my @array_det_pres;
                    
                    $hash_detalle{'renglon'} = $renglon;
                    
                    
#------------------- Inicializo valores para calcular el presupuesto minimo---------------------------------------------------------

                    $hash_mejor_pres{'renglon'}= $renglon;
                    $hash_mejor_pres{'precio'}= 10000;

# -----------------------------------------------------------------------------------------------------------------------------------


#-------------------- Si el detalle tiene una referencia a una recomendacionDetalle tomo los datos de ahi, sino los tomo del detalle del pedido

                    if($det->ref_adq_recomendacion_detalle){    
                              $hash_detalle{'titulo'} = $det->ref_adq_recomendacion_detalle->getTitulo;
                              $hash_detalle{'autor'} = $det->ref_adq_recomendacion_detalle->getAutor;
                              $hash_detalle{'editorial'} = $det->ref_adq_recomendacion_detalle->getEditorial;
                    } else {
                              $hash_detalle{'titulo'} = $det->getTitulo;
                              $hash_detalle{'autor'} = $det->getAutor;
                              $hash_detalle{'editorial'} = $det->getEditorial;
                    }   
 
#------------------------------------------------------------------------------------------------------------------------------------                   


                    foreach my $pres (@$presupuestos){
                                            
                                  my $detalle_presupuesto= C4::AR::Presupuestos::getAdqRenglonPresupuestoDetalle($pres->getId, $renglon);
                            
                                  my %hash_det_pres;

                                  $hash_det_pres{'proveedor'} = $pres->ref_proveedor->getNombre." ".$pres->ref_proveedor->getApellido; 
                                  $hash_det_pres{'cant'} = $detalle_presupuesto->getCantidad;
                                  $hash_det_pres{'precio_unitario'} = $detalle_presupuesto->getPrecioUnitario;
                                  $hash_det_pres{'total'} = ($detalle_presupuesto->getCantidad) * ($detalle_presupuesto->getPrecioUnitario);


                                  
#  -------------------------------- Verifico si es un minimo -----------------------------------------------------------------------------
 
                                  if (($hash_det_pres{'precio_unitario'} < $hash_mejor_pres{'precio'}) && $hash_det_pres{'precio_unitario'} != 0 ){
                                             
                                              $hash_mejor_pres{'precio'}= $hash_det_pres{'precio_unitario'};
                                              $hash_mejor_pres{'cantidad'}= $hash_det_pres{'cant'};
                                              $hash_mejor_pres{'total'}= $hash_det_pres{'total'};
                                              $hash_mejor_pres{'proveedor'}= $hash_det_pres{'proveedor'} ;
                                              $hash_mejor_pres{'titulo'}= $hash_detalle{'titulo'};
                                              $hash_mejor_pres{'autor'}= $hash_detalle{'autor'} ;
                                              $hash_mejor_pres{'editorial'}= $hash_detalle{'editorial'} ;
                                  }

                                  push(@array_det_pres, \%hash_det_pres);
                                          
                     }   
              
                     push(@array_mejor_pres, \%hash_mejor_pres);

                     $hash_detalle{'presup_renglon'}=\@array_det_pres;  
                     push(@resultado,\%hash_detalle);  
                     $renglon= $renglon + 1;
                           
        }
                   
        $t_params->{'detalle_pedido'} = $detalle_pedido;
        $t_params->{'mejor_pres'} = \@array_mejor_pres;
        $t_params->{'presupuestos'} = \@resultado;
        
        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);    

} 
if ($tipoAccion eq "EXPORTAR_MEJOR_PRESUPUESTO"){


        my $tabla_array_ref = $obj->{'table'}; 

        my ($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
                              template_name   => '/adquisiciones/mostrarComparacion.tmpl',
                              query       => $input,
                              type        => "intranet",
                              authnotrequired => 0,
                              flagsrequired   => {  ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    tipo_permiso => 'general',
                                                    entorno => 'adq_intra'}, # FIXME
        });

        my $mejor_pres_detalle;
        my $headers_tabla;
        my $message;    
  
        push(@$headers_tabla, 'Renglon');
        push(@$headers_tabla, 'Proveedor');
        push(@$headers_tabla, 'Datos Editoriales');
        push(@$headers_tabla, 'Precio Unitario');
        push(@$headers_tabla, 'Cantidad');
        push(@$headers_tabla, 'Total');

   
        foreach my $celda (@$tabla_array_ref){
              my $celda_xls; 
              
              push(@$celda_xls, $celda->{'Renglon'});
              push(@$celda_xls, $celda->{'Proveedor'});
              push(@$celda_xls, $celda->{'DatosEditoriales'});
              push(@$celda_xls, $celda->{'PrecioUnitario'});
              push(@$celda_xls, $celda->{'Cantidad'});
              push(@$celda_xls, $celda->{'Total'});

              push (@$mejor_pres_detalle, $celda_xls);
        }
 
   
        $message= C4::AR::XLSGenerator::exportarMejorPresupuesto($mejor_pres_detalle, $headers_tabla);

#         C4::AR::Debug::debug($message->{'codMsg'});


        my $infoOperacionJSON   = to_json $message;
        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;

#         C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session); 
}