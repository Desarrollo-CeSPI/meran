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
use C4::AR::XLSGenerator;
use C4::AR::Prestamos;

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

    $obj->{'tipoPrestamo'}      =  $obj->{'tipo_prestamo_name'};
    $obj->{'nroSocio'}          =  $obj->{'nro_socio_hidden'};
    $obj->{'categoriaSocio'}    =  $obj->{'categoria_socio_id'};
    $obj->{'tipoDoc'}           =  $obj->{'tipo_nivel3_name'};
    $obj->{'fecha_inicio'}      =  $obj->{'date-from'};
    $obj->{'fecha_fin'}         =  $obj->{'date-to'};
    $obj->{'orden'}             =  'fecha';
   
    if ($obj->{'asc'}){
       $obj->{'orden'}.= ' ASC';
    } else {
       $obj->{'orden'}.= ' DESC';
    }
        

    my ($results, $cantidad)    = C4::AR::Reportes::getReservasCirculacion($obj,1);

    $t_params->{'cantidad'}     = $cantidad;
    $t_params->{'results'}      = $results;
    $t_params->{'exportar'}     = 1;

    $obj->{'is_report'}         = "SI";
 
    if ($obj->{'formatoReporte'} eq 'XLS'){
        #XLS
        print C4::AR::XLSGenerator::xlsHeader(); 
        C4::AR::XLSGenerator::exportarReporteReservasCirculacion($results);
    }
    elsif($obj->{'formatoReporte'} eq 'PDF'){
        #PDF
        my $out                     = C4::AR::Auth::get_html_content($template, $t_params);
        my $filename                = C4::AR::PdfGenerator::pdfFromHTML($out, $obj);

        print C4::AR::PdfGenerator::pdfHeader(); 
        C4::AR::PdfGenerator::printPDF($filename);
    }
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
    $obj->{'nroSocio'}          =  $obj->{'nro_socio_hidden'};
    $obj->{'categoriaSocio'}    =  $obj->{'categoria_socio_id'};
    $obj->{'fecha_inicio'}      =  $obj->{'date-from-gen'};
    $obj->{'fecha_fin'}         =  $obj->{'date-to-gen'};
    $obj->{'tipo_documento'}    =  $obj->{'tipo_nivel3_name'};
    
    
    my ($cantidad, $totales)    = C4::AR::Reportes::getReporteCirculacionGeneral($obj);

    $t_params->{'cantidad'}     = $cantidad;
    $t_params->{'exportar'}     = 1;
    $t_params->{'totales'}      = $totales;


    $obj->{'is_report'}         = "SI";


    if ($obj->{'formatoReporte'} eq 'XLS'){
        #XLS
        print C4::AR::XLSGenerator::xlsHeader(); 
        C4::AR::XLSGenerator::exportarReporteCirculacionGeneral($totales);
    }
    elsif($obj->{'formatoReporte'} eq 'PDF'){
        #PDF
        my $out                     = C4::AR::Auth::get_html_content($template, $t_params);
        my $filename                = C4::AR::PdfGenerator::pdfFromHTML($out, $obj);

        print C4::AR::PdfGenerator::pdfHeader(); 
        C4::AR::PdfGenerator::printPDF($filename);
    }

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
    $obj->{'orden'} = 'fecha';
   
    if ($obj->{'asc'}){
       $obj->{'orden'}.= ' ASC';
    } else {
       $obj->{'orden'}.= ' DESC';
    }
                           
    my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);
    my ($results, $cantidad)        = C4::AR::Reportes::getReservasCirculacion($obj,0,$ini,$cantR);

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
                           
    my ($cantidad, $totales)        = C4::AR::Reportes::getReporteCirculacionGeneral($obj);
   
    $t_params->{'cantidad'}         = $cantidad;
    $t_params->{'totales'}          = $totales;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif ($tipoAccion eq "REPORTE_PRESTAMOS_VENCIDOS") {

    ($template, $session, $t_params) = C4::AR::Auth::get_template_and_user({
                                        template_name   => "admin/circulacion/prestamos_vencidos.tmpl",
                                        query           => $input,
                                        type            => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired   => {  ui            => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'ALTA', 
                                                            entorno         => 'undefined'},
    });

    my $prestamos_array_ref   = C4::AR::Prestamos::getAllPrestamosVencidos($obj);
    $t_params->{'ini'}  = 0;

    if(C4::AR::Preferencias::getValorPreferencia('enableMailPrestVencidos'))
    {
        $t_params->{'mensaje'}  = 'Se enviar&aacute;n los mails de pr&eacute;stamos vencidos a la brevedad';
    }

    $t_params->{'orden'}      = $obj->{'orden'};
    $t_params->{'prestamos'}  = $prestamos_array_ref;
    $t_params->{'cantidad'}   = $prestamos_array_ref?scalar(@$prestamos_array_ref):0;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}elsif($tipoAccion eq "EXPORT_REPORTE_PRESTAMOS_VENCIDOS"){


    ($template, $session, $t_params) = C4::AR::Auth::get_template_and_user({
                                        template_name   => "includes/partials/reportes/_reporte_circulacion_prestamos_vencidos_result.inc",
                                        query           => $input,
                                        type            => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired   => {  ui            => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'ALTA', 
                                                            entorno         => 'undefined'},
    });

    my $prestamos_array_ref   = C4::AR::Prestamos::getAllPrestamosVencidos($obj);

    if ($obj->{'formatoReporte'} eq 'XLS'){
        #XLS
        print C4::AR::XLSGenerator::xlsHeader(); 
        C4::AR::XLSGenerator::exportarReporteCirculacionPrestamosVencidos($prestamos_array_ref);
    }
    elsif($obj->{'formatoReporte'} eq 'PDF'){
        #PDF
        $t_params->{'prestamos'}  = $prestamos_array_ref;
        $t_params->{'cantidad'}   = $prestamos_array_ref?scalar(@$prestamos_array_ref):0;

        my $out                     = C4::AR::Auth::get_html_content($template, $t_params);
        my $filename                = C4::AR::PdfGenerator::pdfFromHTML($out, $obj);

        print C4::AR::PdfGenerator::pdfHeader(); 
        C4::AR::PdfGenerator::printPDF($filename);
    }

} 