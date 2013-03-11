#!/usr/bin/perl
use strict;
require Exporter;
use CGI;
use C4::AR::Auth;


my $input=new CGI;

my ($template, $session, $t_params)= get_template_and_user({
								template_name => "opac-main.tmpl",
								query => $input,
								type => "opac",
								authnotrequired => 1,
								flagsrequired => {  ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'undefined'},
			     });


$t_params->{'combo_tipo_documento'} = C4::AR::Utilidades::generarComboTipoNivel3();
$t_params->{'partial_template'}     = "opac-advanced_search.inc";

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
