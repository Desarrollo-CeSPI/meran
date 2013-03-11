#!/usr/bin/perl

use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Context;
use CGI::Session;
use C4::AR::Preferencias;

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

my $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio(C4::AR::Auth::getSessionNroSocio());

C4::AR::Auth::buildSocioData($session,$socio);

$t_params->{'nroRandom'}                = C4::AR::Auth::getSessionNroRandom();
$t_params->{'combo_temas'}              = C4::AR::Utilidades::generarComboTemasOPAC();
$t_params->{'nroRandom'}                = C4::AR::Auth::getSessionNroRandom();
$t_params->{'plainPassword'}            = C4::Context->config('plainPassword');
$t_params->{'partial_template'}         = "opac-modificar_datos.inc";
$t_params->{'content_title'}            = C4::AR::Filtros::i18n("Modificar datos");
$t_params->{'UploadPictureFromOPAC'}    = C4::AR::Preferencias::getValorPreferencia("UploadPictureFromOPAC");
$t_params->{'foto_name'}                = $socio->tieneFoto();

#preferencias para generar nueva password
$t_params->{'minPassLength'}            = C4::AR::Preferencias::getValorPreferencia('minPassLength');
$t_params->{'minPassSymbol'}            = C4::AR::Preferencias::getValorPreferencia('minPassSymbol');
$t_params->{'minPassAlpha'}             = C4::AR::Preferencias::getValorPreferencia('minPassAlpha');
$t_params->{'minPassNumeric'}           = C4::AR::Preferencias::getValorPreferencia('minPassNumeric');

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
