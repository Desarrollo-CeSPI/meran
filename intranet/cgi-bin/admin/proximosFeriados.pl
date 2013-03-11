#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::Date;
use C4::AR::Prestamos;
use Date::Manip;
use C4::Date;
use C4::AR::Sanciones;

my $input=new CGI;

my ($template, $session, $t_params) =  get_template_and_user ({
			template_name	=> 'admin/proximosFeriados.tmpl',
			query		=> $input,
			type		=> "intranet",
			authnotrequired	=> 0,
			flagsrequired	=> {    ui => 'ANY', 
                                    tipo_documento => 'ANY', 
                                    accion => 'CONSULTA', 
                                    entorno => 'undefined'},
});

$t_params->{'proximos_feriados'} = C4::AR::Utilidades::getProximosFeriados();

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
