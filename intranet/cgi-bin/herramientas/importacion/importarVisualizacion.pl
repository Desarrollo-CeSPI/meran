#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::ImportacionXML;

my $input = new CGI;

my %params_combo;

my $obj     = $input->Vars; 

my $accion  = $obj->{'tipoAccion'} || undef;

my $context = $obj->{'context'};

my $tmpl;

if ($context eq "opac"){
    $tmpl = "catalogacion/visualizacionOPAC/visualizacionOpac.tmpl";
}else{
    $tmpl = "catalogacion/visualizacionINTRA/visualizacionIntra.tmpl";
}


my ($template, $session, $t_params) = get_template_and_user({
                                    template_name   => $tmpl,
                                    query           => $input,
                                    type            => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired   => {  ui    => 'ANY', 
                                                        accion  => 'CONSULTA', 
                                                        entorno => 'undefined'},
                                    debug => 1,
                });

if ($accion eq "IMPORT"){

    my $msg_object  = C4::AR::ImportacionXML::importarVisualizacion($obj, $input->upload('fileImported'), $context);

    my $codMsg      = C4::AR::Mensajes::getFirstCodeError($msg_object);
    
    $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');

    if (C4::AR::Mensajes::hayError($msg_object)){
        $t_params->{'mensaje_class'} = "alert-error";
    }else{
        $t_params->{'mensaje_class'} = "alert-success";
    }
}

$params_combo{'onChange'}                       = 'eleccionDeEjemplar()';
$params_combo{'default'}                        = 'SIN SELECCIONAR';
$t_params->{'combo_perfiles'}                   = C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo);
$t_params->{'combo_ejemplares'}                 = C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo);
$t_params->{'page_sub_title'}                   = C4::AR::Filtros::i18n("Catalogaci&oacute;n - Visualizaci&oacute;n del OPAC");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);