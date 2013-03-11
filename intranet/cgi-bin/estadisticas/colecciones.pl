#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Utilidades;
use C4::AR::Reportes;
use C4::AR::PdfGenerator;



my $input = new CGI;
my $obj=$input->param('obj') || 0;

my ($template, $session, $t_params, $data_url);

($template, $session, $t_params) = get_template_and_user({
                            template_name => "includes/partials/reportes/_reporte_colecciones_result.inc",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'undefined'},
                            debug => 1,
                    });

if (!$obj) {
        $obj = $input->Vars;
        $obj->{'ui'}=  $obj->{'name_ui'};
        $obj->{'item_type'}=  $obj->{'tipo_nivel3_name'};
        $obj->{'nivel_biblio'}=  $obj->{'name_nivel_bibliografico'};
    
} else {
        $obj=C4::AR::Utilidades::from_json_ISO($obj);
}
       
$obj->{'fecha_ini'} =  C4::AR::Filtros::i18n($obj->{'fecha_ini'});
$obj->{'fecha_fin'} =  C4::AR::Filtros::i18n($obj->{'fecha_fin'});

if ($obj->{'fecha_ini'} eq "Desde"){
    $obj->{'fecha_ini'} = "";
} 

if ($obj->{'fecha_fin'} eq "Hasta"){
    $obj->{'fecha_fin'} = "";
} 

# $data_url = C4::AR::Utilidades::getUrlPrefix()."/estadisticas/colecciones_data.pl?item_type=".$obj->{'item_type'}."%26ui=".$obj->{'ui'};
# $t_params->{'data'} = C4::AR::Reportes::getArrayHash('getItemTypes',$obj);

# my ($data,$is_array_of_hash) = C4::AR::Reportes::getItemTypes($obj,1);
# my ($path,$filename) = C4::AR::Reportes::toXLS($data,$is_array_of_hash,'Pagina 1','Colecciones');

# $t_params->{'filename'} = '/reports/'.$filename;

my $ini             = $obj->{'ini'};     

my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);

$t_params->{'ini'}= $obj->{'ini'} = $ini;
$t_params->{'cantR'}= $obj->{'cantR'} = $cantR;

my ($data, $data_report, $cant_n3, $cant_n1, $cant_n2) = C4::AR::Reportes::reporteColecciones($obj);

$t_params->{'cant_n3'} = $cant_n3;
$t_params->{'cant_n2'} = $cant_n2;
$t_params->{'cant_n1'} = $cant_n1;

if ($obj->{'exportar'}) {

    $t_params->{'data'} = $data_report;
    $t_params->{'exportar'} = 1;

    $obj->{'is_report'}="SI";

    my $out= C4::AR::Auth::get_html_content($template, $t_params);
    my $filename= C4::AR::PdfGenerator::pdfFromHTML($out,$obj);
    print C4::AR::PdfGenerator::pdfHeader(); 
    C4::AR::PdfGenerator::printPDF($filename);

} else {
    
    $t_params->{'paginador'}= C4::AR::Utilidades::crearPaginador($cant_n3,$cantR, $pageNumber,$obj->{'funcion'},$t_params);
    $t_params->{'data'} = $data;

    # my %params_for_combo = {};
    # $params_for_combo{'default'} = 'ALL';
    # $t_params->{'data_url'} = $data_url;
    # $t_params->{'item_type_combo'} = C4::AR::Utilidades::generarComboTipoNivel3(\%params_for_combo);
    # $t_params->{'ui_combo'} = C4::AR::Utilidades::generarComboUI();

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}

