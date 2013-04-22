#!/usr/bin/perl

require Exporter;
use strict;
use C4::AR::Auth;
use C4::AR::Utilidades;
use CGI;
use JSON;
use C4::AR::Reportes;
use C4::Modelo::RepBusqueda;
use C4::Modelo::RepHistorialBusqueda;
use C4::AR::PdfGenerator;

my $input       = new CGI;
my $obj         = $input->param('obj') || 0;

if (!$obj) {
    $obj         = $input->Vars;    
} else {
    $obj = C4::AR::Utilidades::from_json_ISO($obj);
}

my $tipoAccion  = $obj->{'tipoAccion'} || "";

my ($template, $session, $t_params);

if($tipoAccion eq "EXPORT_CIRC"){
    ($template, $session, $t_params)= C4::AR::Auth::get_template_and_user({
                                        template_name   => "includes/partials/reportes/_reporte_circulacion_result.inc",
                                        query           => $input,
                                        type            => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired   => {  ui            => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'undefined'},
                                        
    });

    $obj->{'categoriaSocio'}    =  $obj->{'categoria_socio_id'};
    $obj->{'fecha_inicio'}      =  $obj->{'date-from'};
    $obj->{'fecha_fin'}         =  $obj->{'date-to'};
    
    my ($results, $cantidad)    = C4::AR::Reportes::getReservasCirculacionToExport($obj);

    $t_params->{'cantidad'}     = $cantidad;
    $t_params->{'results'}      = $results;
    $t_params->{'exportar'}     = 1;

    $obj->{'is_report'}         = "SI";

    my $out                     = C4::AR::Auth::get_html_content($template, $t_params);
    my $filename                = C4::AR::PdfGenerator::pdfFromHTML($out, $obj);

    print C4::AR::PdfGenerator::pdfHeader(); 
    C4::AR::PdfGenerator::printPDF($filename);
}
elsif($tipoAccion eq "EXPORT_CIRC_GENERAL"){
    ($template, $session, $t_params)= C4::AR::Auth::get_template_and_user({
                                        template_name   => "includes/partials/reportes/_reporte_circulacion_general_result.inc",
                                        query           => $input,
                                        type            => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired   => {  ui            => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'undefined'},
    });

    $obj->{'tipoPrestamo'}      =  $obj->{'tipo_prestamo_name'};
    $obj->{'responsable'}       =  $obj->{'nro_socio_hidden'};
    $obj->{'categoriaSocio'}    =  $obj->{'categoria_socio_id'};
    $obj->{'fecha_inicio'}      =  $obj->{'date-from-gen'};
    $obj->{'fecha_fin'}         =  $obj->{'date-to-gen'};
    
    my ($results, $cantidad, $totales)    = C4::AR::Reportes::getReporteCirculacionGeneralToExport($obj);

    $t_params->{'cantidad'}     = $cantidad;
    $t_params->{'results'}      = $results;
    $t_params->{'exportar'}     = 1;
    $t_params->{'totales'}      = $totales;


    $obj->{'is_report'}         = "SI";

    my $out                     = C4::AR::Auth::get_html_content($template, $t_params);
    my $filename                = C4::AR::PdfGenerator::pdfFromHTML($out, $obj);

    print C4::AR::PdfGenerator::pdfHeader(); 
    C4::AR::PdfGenerator::printPDF($filename);
} 
elsif ($tipoAccion eq "BUSQUEDAS") {
    ($template, $session, $t_params)= C4::AR::Auth::get_template_and_user({
                                        template_name   => "includes/partials/reportes/_reporte_circulacion_result.inc",
                                        query           => $input,
                                        type            => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired   => {  ui            => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'undefined'},
    });

    $obj->{'ini'}   = $obj->{'ini'} || 1;
    my $ini         = $obj->{'ini'};
    my $funcion     = $obj->{'funcion'};
    $obj->{'orden'} = $obj->{'orden'} || 'titulo';
   
    if ($obj->{'asc'}){
       $obj->{'orden'}.= ' ASC';
    } else {
       $obj->{'orden'}.= ' DESC';
    }
                           
    my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);

    my ($results, $cantidad)        = C4::AR::Reportes::getReservasCirculacion($obj,$ini,$cantR);

    $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
    $t_params->{'cantidad'}         = $cantidad;
    $t_params->{'results'}          = $results;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif ($tipoAccion eq "CIRC_GENERAL") {

    ($template, $session, $t_params) = C4::AR::Auth::get_template_and_user({
                                        template_name   => "includes/partials/reportes/_reporte_circulacion_general_result.inc",
                                        query           => $input,
                                        type            => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired   => {  ui            => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'undefined'},
    });

    $obj->{'ini'}   = $obj->{'ini'} || 1;
    my $ini         = $obj->{'ini'};
    my $funcion     = $obj->{'funcion'};
    $obj->{'orden'} = $obj->{'orden'} || 'titulo';
   
    if ($obj->{'asc'}){
       $obj->{'orden'}.= ' ASC';
    } else {
       $obj->{'orden'}.= ' DESC';
    }
                           
    my ($ini,$pageNumber,$cantR)        = C4::AR::Utilidades::InitPaginador($ini);
    my ($cantidad, $totales)  = C4::AR::Reportes::getReporteCirculacionGeneral($obj,$ini,$cantR);
   
    $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad,$cantR,$pageNumber,$funcion,$t_params);
    $t_params->{'cantidad'}         = $cantidad;
    $t_params->{'totales'}          = $totales;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}