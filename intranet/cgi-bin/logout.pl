#!/usr/bin/perl

use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Context;
use CGI::Session;

my $input=new CGI;

my ($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
            template_name   => 'auth.tmpl',
            query       => $input,
            type        => "intranet",
            authnotrequired => 1,
            flagsrequired   => {    ui => 'ANY', 
                                    tipo_documento => 'ANY', 
                                    accion => 'CONSULTA', 
                                    entorno => 'undefined'},
    });


my ($session) = C4::AR::Auth::cerrarSesion();

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
