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
require Exporter;
use C4::AR::Auth;
use C4::AR::PdfGenerator;
use C4::AR::XLSGenerator;
use C4::AR::Reportes;
use C4::AR::Busquedas;
use C4::Modelo::RepBusqueda;
use C4::Modelo::RepHistorialBusqueda;
use CGI;
use JSON;




my $input = new CGI;
my $obj;

my ($template, $session, $t_params);


($template, $session, $t_params)= C4::AR::Auth::get_template_and_user({
                                        template_name   => "includes/partials/reportes/_reporte_busquedas_result.inc",
                                        query           => $input,
                                        type            => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired   => {  ui            => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'undefined'},
});


if ($input->param('obj')){
    
    $obj = $input->param('obj');
    $obj = C4::AR::Utilidades::from_json_ISO($obj);

} else {
  
    $obj->{'tipoAccion'}= $input->param('accion');
    $obj->{'formatoReporte'}= $input->param('formatoReporte');
    $obj->{'orden'}= $input->param('orden');
    $obj->{'asc'}= $input->param('asc');
    $obj->{'usuario'}= $input->param('nro_socio');
    $obj->{'categoria'}= $input->param('categoria_socio_id');
    $obj->{'interfaz'}= $input->param('interfaz');
    $obj->{'valor'}= $input->param('valor');
    $obj->{'fecha_inicio'}= $input->param('date-from');
    $obj->{'fecha_fin'}= $input->param('date-to');
    $obj->{'is_report'}= "SI";
    $obj->{'exportar'}= $input->param('exportar');

}



$obj->{'fecha_inicio'} =  C4::AR::Filtros::i18n($obj->{'fecha_inicio'});
$obj->{'fecha_fin'} =  C4::AR::Filtros::i18n($obj->{'fecha_fin'});

if ($obj->{'fecha_inicio'} eq "Desde"){
    $obj->{'fecha_inicio'} = "";
} 

if ($obj->{'fecha_fin'} eq "Hasta"){
    $obj->{'fecha_fin'} = "";
} 


my $tipoAccion= $obj->{'tipoAccion'}||"";

$obj->{'ini'} = $obj->{'ini'} || 0;
my $ini       = $obj->{'ini'};
my $funcion   = $obj->{'funcion'};
my $inicial   = $obj->{'inicial'};


if ($obj->{'orden'} eq "valor"){
    $obj->{'orden'} = "valor";
} elsif ($obj->{'orden'} eq "campo"){
    $obj->{'orden'} = "campo";
} elsif ($obj->{'orden'} eq "nro_socio"){
    $obj->{'orden'} = "busqueda.nro_socio";
} elsif ($obj->{'orden'} eq "fecha"){
    $obj->{'orden'} = "busqueda.fecha";
} else {
    $obj->{'orden'} = $obj->{'orden'} || 'valor';
}


if ($obj->{'asc'}){
    $obj->{'orden'}.= ' ASC';
} else {
    $obj->{'orden'}.= ' DESC';
}
#     C4::AR::Validator::validateParams('U389',$obj,['socio','ini','funcion'] );


my ($results, $cantidad, $all_results);

my ($ini, $pageNumber, $cantR) = C4::AR::Utilidades::InitPaginador($ini);


if($tipoAccion eq "BUSQUEDAS"){

    ($results, $cantidad, $all_results)= C4::AR::Reportes::getBusquedasDeUsuario($obj,$ini,$cantR);

    $t_params->{'cantidad'} = $cantidad;
    $t_params->{'nro_socio'} = $obj->{'usuario'};

    if ($obj->{'exportar'}){
      if ($obj->{'formatoReporte'} eq 'XLS'){
          #XLS
          print C4::AR::XLSGenerator::xlsHeader(); 
          C4::AR::XLSGenerator::exportarReporteBusquedas($all_results);
      }
      elsif($obj->{'formatoReporte'} eq 'PDF'){
          #PDF
            $obj->{'is_report'}="SI";
            $t_params->{'results'} = $all_results;
            $t_params->{'exportar'} = 1;
            my $out= C4::AR::Auth::get_html_content($template, $t_params);
            my $filename= C4::AR::PdfGenerator::pdfFromHTML($out,$obj);
            print C4::AR::PdfGenerator::pdfHeader(); 
            C4::AR::PdfGenerator::printPDF($filename);
      }

    } else {

        $t_params->{'results'} = $results;
        $t_params->{'paginador'}= C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);

        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
    }


} elsif ($tipoAccion eq "REPORTE_GEN_ETIQUETAS") {

# DEPRECATED
      # my $tmpl = ($obj->{'tipo_reporte'} eq "sin_grupos")?"includes/partials/reportes/_reporte_gen_etiquetas_sin_grupos_result.inc":"includes/partials/reportes/_reporte_gen_etiquetas_result.inc";

      ($template, $session, $t_params)= C4::AR::Auth::get_template_and_user({
                                                template_name   => "includes/partials/reportes/_reporte_gen_etiquetas_sin_grupos_result.inc",
                                                query           => $input,
                                                type            => "intranet",
                                                authnotrequired => 0,
                                                flagsrequired   => {  ui            => 'ANY', 
                                                                    tipo_documento  => 'ANY', 
                                                                    accion          => 'CONSULTA', 
                                                                    entorno         => 'undefined'},
      });

      my ($cantidad, $array_nivel1)   = C4::AR::Reportes::reporteGenerarEtiquetas($obj, $session, $ini, $cantR);

      $obj->{'cantidad'}              = $cantidad;
      $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
      $t_params->{'SEARCH_RESULTS'}   = $array_nivel1;
      $t_params->{'cantidad'}         = $cantidad;


      C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} elsif ($tipoAccion eq "REGISTROS_NO_INDEXADOS"){

      ($template, $session, $t_params)= C4::AR::Auth::get_template_and_user({
                                                template_name   => "includes/partials/reportes/_reporte_gen_registros_no_indexados.inc",
                                                query           => $input,
                                                type            => "intranet",
                                                authnotrequired => 0,
                                                flagsrequired   => {  ui            => 'ANY', 
                                                                    tipo_documento  => 'ANY', 
                                                                    accion          => 'CONSULTA', 
                                                                    entorno         => 'undefined'},
      });

      my ($cantidad, $array_nivel1)   = C4::AR::Reportes::reporteRegistrosNoIndexados($obj, $session);  

      $t_params->{'REGISTROS'}      = $array_nivel1;
      $t_params->{'CANT_REGISTROS'} = $cantidad;

      C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
      
}
elsif ($tipoAccion eq "ADD_REGISTRO_AL_INDICE"){


    my $id1_array = $obj->{'array_id1'};

    my ($Messages_arrayref)= C4::AR::Nivel1::addRegistroAlIndice($id1_array);

     my $infoOperacionJSON=to_json $Messages_arrayref;

    C4::AR::Auth::print_header($session);
  print $infoOperacionJSON;
}