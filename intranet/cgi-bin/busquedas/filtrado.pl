#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
# use C4::Output;
use C4::AR::Utilidades;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user ({
                                template_name	=> 'busquedas/filtrado.tmpl',
                                query		    => $input,
                                type		    => "intranet",
                                authnotrequired	=> 0,
                                flagsrequired	=> {    ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'sistema'},
    					});

#combo itemtype
my %params_combo;
$params_combo{'default'}            = C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");
my $comboTiposNivel3                = &C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo);
$t_params->{'comboTipoDocumento'}   = $comboTiposNivel3;
$t_params->{'type'}                 = 'intranet';
$t_params->{'advanced'}             = 1;
$t_params->{'page_sub_title'}       = C4::AR::Filtros::i18n("Cat&aacute;logo - B&uacute;squeda");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
