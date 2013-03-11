#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;

use Template;
use C4::AR::Prestamos;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                        template_name => "admin/circulacion/tipos_de_prestamos.tmpl",
                        query => $input,
                        type => "intranet",
                        authnotrequired => 0,
                        flagsrequired => {  ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'CONSULTA', 
                                            entorno => 'undefined'},
                        debug => 1,
			    });

my $tipos_de_prestamos=C4::AR::Prestamos::getTiposDePrestamos();
$t_params->{'TIPOS_PRESTAMOS_LOOP'}= $tipos_de_prestamos;
$t_params->{'page_sub_title'}=C4::AR::Filtros::i18n("Circulaci&oacute;n - Tipos de pr&eacute;stamos");
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
