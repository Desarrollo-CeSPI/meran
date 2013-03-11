#!/usr/bin/perl

use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Context;
use CGI::Session;

my $input=new CGI;


my ($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
            template_name   => 'opac-main.tmpl',
            query       => $input,
            type        => "opac",
            authnotrequired => 0,
            flagsrequired   => {    ui => 'ANY', 
                                    tipo_documento => 'ANY', 
                                    accion => 'CONSULTA', 
                                    entorno => 'undefined'},
            loging_out      => 1,
    });

$t_params->{'type'} = "opac";

C4::AR::Auth::cerrarSesion($t_params);