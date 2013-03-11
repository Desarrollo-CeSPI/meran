#!/usr/bin/perl

use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Context;
use CGI::Session;

my $input = new CGI;

my ($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
            template_name   => 'opac-main.tmpl',
            query           => $input,
            type            => "opac",
            authnotrequired => 0,
            flagsrequired   => {    ui              => 'ANY', 
                                    tipo_documento  => 'ANY', 
                                    accion          => 'CONSULTA', 
                                    entorno         => 'undefined'},
    });

my $socio 					= C4::AR::Usuarios::getSocioInfoPorNroSocio(C4::AR::Auth::getSessionNroSocio());
my $uploadPictureFromOpac 	= C4::AR::Preferencias::getValorPreferencia('UploadPictureFromOPAC');

C4::AR::Auth::buildSocioData($session,$socio);

$t_params->{'socio'}                    = $socio;
$t_params->{'partial_template'}         = "opac-mis_datos.inc";
$t_params->{'uploadPictureFromOpac'}    = $uploadPictureFromOpac;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
