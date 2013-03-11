#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;

use C4::AR::Utilidades;

my $input = new CGI;

my ($template, $session, $t_params)  = get_template_and_user({  
                    template_name => "admin/referencias/referencias_home.tmpl",
                    query => $input,
                    type => "intranet",
                    authnotrequired => 0,
                    flagsrequired => {  ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'CONSULTA', 
                                        entorno => 'permisos', 
                                        tipo_permiso => 'general'},
                    debug => 1,
                });

my %combo_params = {};
$combo_params{'onChange'} = "obtenerTabla();";

my $combo_tablas = C4::AR::Utilidades::generarComboTablasDeReferencia(\%combo_params);

$t_params->{'combo_tablas'}= $combo_tablas;
$t_params->{'page_sub_title'}=C4::AR::Filtros::i18n("Administraci&oacute;n de tablas de referencia");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
