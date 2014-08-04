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
use CGI;
use C4::AR::Utilidades;
use C4::AR::Reportes;
use C4::AR::PdfGenerator;
use C4::AR::XLSGenerator;

my $input = new CGI;
my $obj=$input->param('obj');

if ($obj){
    $obj=C4::AR::Utilidades::from_json_ISO($obj);
}else{ 
    $obj = $input->Vars;
    $obj->{'ui'}= $obj->{'name_ui'};     
    $obj->{'estado'}= $obj->{'estado'};   
    $obj->{'disponibilidad'}= $obj->{'disponibilidad_name'};  
}

my ($template, $session, $t_params, $data_url);

($template, $session, $t_params) = get_template_and_user({
                                            template_name => "includes/partials/reportes/_reporte_disponibilidad_result.inc",
                                            query => $input,
                                            type => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired => {  ui => 'ANY', 
                                                                tipo_documento => 'ANY', 
                                                                accion => 'CONSULTA', 
                                                                entorno => 'undefined'},
                                            debug => 1,
                });

$obj->{'fecha_ini'} =  C4::AR::Filtros::i18n($obj->{'fecha_ini'});
$obj->{'fecha_fin'} =  C4::AR::Filtros::i18n($obj->{'fecha_fin'});

if ($obj->{'fecha_ini'} eq "Desde"){
    $obj->{'fecha_ini'} = "";
} 

if ($obj->{'fecha_fin'} eq "Hasta"){
    $obj->{'fecha_fin'} = "";
} 

my $ini                         = $obj->{'ini'};     
my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);

$t_params->{'ini'}= $obj->{'ini'}       = $ini;
$t_params->{'cantR'}= $obj->{'cantR'}   = $cantR;


my ($data, $cant)         = C4::AR::Reportes::reporteDisponibilidad($obj);

$t_params->{'data'} = $data;

if ($obj->{'exportar'}) {


    if ($obj->{'formatoReporte'} eq 'XLS'){
        #XLS
        print C4::AR::XLSGenerator::xlsHeader(); 
        C4::AR::XLSGenerator::exportarReporteDisponibilidad($data);
    }
    elsif($obj->{'formatoReporte'} eq 'PDF'){
        #PDF
        $t_params->{'cant'} = $cant;
        $t_params->{'exportar'} = 1;
        $obj->{'is_report'}="SI";
        my $out= C4::AR::Auth::get_html_content($template, $t_params);
        my $filename= C4::AR::PdfGenerator::pdfFromHTML($out,$obj);
        print C4::AR::PdfGenerator::pdfHeader(); 
        C4::AR::PdfGenerator::printPDF($filename);

    }

} else {

    $t_params->{'paginador'}= C4::AR::Utilidades::crearPaginador($cant,$cantR, $pageNumber,$obj->{'funcion'},$t_params);
    $t_params->{'cant'} = $cant;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
    