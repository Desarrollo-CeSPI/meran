#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Utilidades;
use C4::AR::Reportes;
use C4::AR::Estantes;
use C4::AR::PdfGenerator;


my $input = new CGI;
my $obj=$input->param('obj');
my $estante;
my $msg_object = C4::AR::Mensajes::create();

if ($obj){
    $obj=C4::AR::Utilidades::from_json_ISO($obj);
    
}else{ 
    $obj = $input->Vars;
    $obj->{'estante'} = $obj->{"estante_name"};     
}

$estante= C4::AR::Estantes::getEstante($obj->{'estante'}); 

my ($template, $session, $t_params, $data_url);

($template, $session, $t_params) = get_template_and_user({
                                            template_name => "includes/partials/reportes/_reporte_estantes_virtuales_result.inc",
                                            query => $input,
                                            type => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired => {  ui => 'ANY', 
                                                                tipo_documento => 'ANY', 
                                                                accion => 'CONSULTA', 
                                                                entorno => 'undefined'},
                                            debug => 1,
                });


my $ini                         = $obj->{'ini'};     
my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);

$t_params->{'ini'}= $obj->{'ini'}       = $ini;
$t_params->{'cantR'}= $obj->{'cantR'}   = $cantR;


my ($data, $cant)         = C4::AR::Reportes::reporteEstantesVirtuales($obj);

$t_params->{'data'} = $data;
$t_params->{'cant'} = $cant;
$t_params->{'estante'}= $estante;
$t_params->{'nombre_estante'}=$estante->{"estante"};

$t_params->{'mensajes'} = $msg_object;


if ($obj->{'exportar'}) {

    $t_params->{'exportar'} = 1;

    $obj->{'is_report'}="SI";

    my $out= C4::AR::Auth::get_html_content($template, $t_params);
    my $filename= C4::AR::PdfGenerator::pdfFromHTML($out,$obj);
    print C4::AR::PdfGenerator::pdfHeader(); 
    C4::AR::PdfGenerator::printPDF($filename);

} else {

    $t_params->{'paginador'}= C4::AR::Utilidades::crearPaginador($cant,$cantR, $pageNumber,$obj->{'funcion'},$t_params);

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
    

