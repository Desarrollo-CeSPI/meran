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
use C4::Context;
use C4::AR::Proveedores;
use C4::AR::Recomendaciones;
use CGI;
use C4::AR::PdfGenerator;
use C4::AR::XLSGenerator;
use C4::AR::Utilidades;
use C4::AR::Preferencias;
use C4::AR::Referencias;
use utf8;

my $input           = new CGI;
my $to_pdf          = $input->param('exportPDF') || 0;
my $to_doc          = $input->param('exportDOC') || 0;
my $to_xls          = $input->param('exportXLS') || 0;
my $operationDOC    = $input->param('operationDOC') || 0;
my $template_name   = "";

if($to_pdf){
	$template_name = "adquisiciones/listado_ejemplares_export.tmpl";
}elsif($to_doc){
    if($operationDOC){
        $template_name = "adquisiciones/ordenDeCompra.tmpl";
    }else{
        $template_name = "adquisiciones/listado_ejemplares_export_doc.tmpl";
    }
}

my ($template, $session, $t_params) = get_template_and_user({
    template_name   => $template_name,
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

 
if($to_pdf){
#   se exporta a PDF las recomendaciones

    my $recomendaciones_activas                 = C4::AR::Recomendaciones::getRecomendacionesActivas();   
    my $cant_recomendaciones                    = (scalar(@$recomendaciones_activas));    
    my $i;
    my @resultsdata;
    
    for($i = 1; $i <= $cant_recomendaciones; $i++){
     
        if($input->param('activo'.$i) ne ''){
        
            my %hash = (    titulo      => $input->param('libro'.$i),
                            cantidad    => $input->param('cantidad'.$i),
                            fecha       => $input->param('fecha'.$i), ); 
                      
            my %row = ( recomendacion => \%hash,);
            
            push(@resultsdata, \%row);
        }
    }
    
    if(@resultsdata > 0){
        $t_params->{'resultsloop'}= \@resultsdata; 
    }

	my $out = C4::AR::Auth::get_html_content( $template, $t_params, $session );
	my $filename = C4::AR::PdfGenerator::pdfFromHTML($out);
	print C4::AR::PdfGenerator::pdfHeader();
	C4::AR::PdfGenerator::printPDF($filename);

}elsif($to_doc){

    # variables compartidas por los dos ifs de abajo
    my @resultsdata;
    my %hash;
    
    if($operationDOC){
        #   exporta a DOC la orden de compra

        for(my $i = 1; $i <= $input->param('cantidad'); $i++){
          
            my %hash = (    cantidad    => $input->param('cantidad'.$i),
                            articulo    => $input->param('datosEdit'.$i),
                            unitario    => $input->param('precio'.$i), 
                            total       => $input->param('total'.$i),); 
                          
            my %row = ( orden_compra => \%hash,);
                
            push(@resultsdata, \%row);
        }
        
        $hash{'aplicacion'}   = "application/msword";
        $hash{'file_name'}    = "orden_de_compra.doc";
        
        my $ui_id = C4::AR::Preferencias::getValorPreferencia('defaultUI');
        
        my $ui    = C4::AR::Referencias::obtenerUIByIdUi($ui_id); 

        $t_params->{'facultad'}     = $ui->{'nombre'};
        $t_params->{'direccion'}    = $ui->{'direccion'};
        
        # generamos la fecha actual
        my @dias   = ('Domingo','Lunes','Martes','Miércoles',
               'Jueves','Viernes','Sábado');
               
        my @meses = ('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio',
                 'Agosto','Septiembre','Octubre','Noviembre','Diciembre');

        my ($segundo,$minuto,$hora,$dia,$mes,$anio,$diaSemana) = (localtime(time))[0,1,2,3,4,5,6];

        $anio += 1900;

        $t_params->{'fecha'}        = "La Plata, $dias[$diaSemana] $dia de $meses[$mes]  del $anio";
        
        $t_params->{'proveedor'}    = $input->param('nombreProveedor');
           
    }else{
    #   exporta a DOC las recomendaciones

        my $recomendaciones_activas                 = C4::AR::Recomendaciones::getRecomendacionesActivas();   
        my $cant_recomendaciones                    = (scalar(@$recomendaciones_activas));    
        my $i;
             
        for($i = 1; $i <= $cant_recomendaciones; $i++){
        
            if($input->param('activo'.$i) ne ''){
            
                my %hash = (    titulo      => $input->param('libro'.$i),
                                cantidad    => $input->param('cantidad'.$i),
                                fecha       => $input->param('fecha'.$i), ); 
                          
                my %row = ( recomendacion => \%hash,);
                
                push(@resultsdata, \%row);
            }
        }
        
        $hash{'aplicacion'}   = "application/msword";
        $hash{'file_name'}    = "recomendaciones.doc";   
    }
      
    # generico para los dos casos de exportacion a DOC:    
    if(@resultsdata > 0){
        $t_params->{'resultsloop'}= \@resultsdata; 
    } 
            
    $t_params->{'headers'}  = C4::AR::Utilidades::setHeaders(\%hash);    
        
    print C4::AR::Auth::get_html_content( $template, $t_params, $session );
    
}elsif($to_xls){
# se exporta a XLS 

    my $pedido_cotizacion_id    = $input->param('pedido_cotizacion');
    my $proveedor_id            = $input->param('proveedor');
 
    my $presupuesto;
    my $headers_tabla;
    my $headers_planilla;
    my $campos_hidden;

    my $proveedor       = C4::AR::Proveedores::getProveedorInfoPorId($proveedor_id);  
    my $tipo_proveedor  = C4::AR::Proveedores::isPersonaFisica($proveedor_id);
        
    push(@$headers_planilla, 'Proveedor');
        
    my $nombre_proveedor;
    if($tipo_proveedor == 0){
        push (@$headers_planilla, $proveedor->getRazonSocial());
        $nombre_proveedor = $proveedor->getRazonSocial();
    }else{
        push (@$headers_planilla, $proveedor->getNombre());
        $nombre_proveedor = $proveedor->getNombre();
    }
    
    push(@$campos_hidden, $proveedor_id);
        
    push(@$headers_tabla, 'Renglon');
    push(@$headers_tabla, 'Cantidad');
    push(@$headers_tabla, 'Articulo');
    push(@$headers_tabla, 'Precio Unitario');
    push(@$headers_tabla, 'Precio Total');
    
    my $pedidos_cotizacion_detalle = C4::AR::PedidoCotizacionDetalle::getPedidosCotizacionPorPadre($pedido_cotizacion_id);
        
    foreach my $celda (@$pedidos_cotizacion_detalle){
        my $celda_xls; 
           
        push(@$celda_xls, $celda->{'nro_renglon'});
        push(@$celda_xls, $celda->{'cantidad_ejemplares'});
        push(@$celda_xls, $celda->{'titulo'});
        push (@$presupuesto, $celda_xls);
    }
               
    my $data = C4::AR::XLSGenerator::getXLS($presupuesto, $headers_tabla, $headers_planilla, $campos_hidden, $nombre_proveedor); 
        
    my %hash;
        
    $hash{'aplicacion'}   = "application/vnd.ms-excel";
    $hash{'file_name'}    = "presupuesto".$nombre_proveedor.".xls";
        
    print C4::AR::Utilidades::setHeaders(\%hash);
        
    print $data;
    
}else{
#   se muestra el template normal

    my $recomendaciones_activas   = C4::AR::Recomendaciones::getRecomendacionesActivas();

    if($recomendaciones_activas){
        my @resultsdata;

        for my $recomendacion (@$recomendaciones_activas){   
            my %row = ( recomendacion => $recomendacion, );
            push(@resultsdata, \%row);
        }

       $t_params->{'resultsloop'}   = \@resultsdata; 
       
    }
    
    my $combo_proveedores               = C4::AR::Utilidades::generarComboProveedoresMultiple();

    $t_params->{'combo_proveedores'}    = $combo_proveedores;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}