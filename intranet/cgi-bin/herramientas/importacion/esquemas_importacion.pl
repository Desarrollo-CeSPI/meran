#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::AR::Utilidades;

my $input   = new CGI;
my $obj     = $input->param('obj');

my ($template, $session, $t_params)  = get_template_and_user({  
                    template_name => "herramientas/importacion/esquemas_importacion.tmpl",
                    query => $input,
                    type => "intranet",
                    authnotrequired => 0,
                    flagsrequired => {  ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'MODIFICACION', 
                                        entorno => 'permisos', 
                                        tipo_permiso => 'general'},
                    debug => 1,
                });

my %params_combo                            = {};
$params_combo{'onChange'}                   = 'showEsquemaImportacion()';

my $combo_esquemas_importacion              = C4::AR::Utilidades::generarComboEsquemasImportacion(\%params_combo);

$t_params->{'combo_esquemas_importacion'}   = $combo_esquemas_importacion;
$t_params->{'id_esquema'}                   = $input->param('id_esquema') || 0;
$t_params->{'page_sub_title'}               = C4::AR::Filtros::i18n("Esquemas de importaci&oacute;n");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
