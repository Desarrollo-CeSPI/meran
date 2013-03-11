#!/usr/bin/perl

use strict;
require Exporter;
use C4::AR::Auth;
use CGI;

my $query = new CGI;

my ($template, $session, $t_params) = C4::AR::Auth::get_template_and_user({
                                    template_name   => "reports/circulacion.tmpl",
                                    query           => $query,
                                    type            => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined' },
});


my %hash;
$hash{'id'}                                 = 'categoriaSocioReservas'; 

$t_params->{'comboDeCategoriasReservas'}    = C4::AR::Utilidades::generarComboCategoriasDeSocio(\%hash);
$t_params->{'comboDeCategorias'}            = C4::AR::Utilidades::generarComboCategoriasDeSocio();
$t_params->{'comboDeTipoDoc'}               = C4::AR::Utilidades::generarComboTipoDeDocConValuesIds();
$t_params->{'comboDeTipoPrestamos'}         = C4::AR::Utilidades::generarComboTipoPrestamo();

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);