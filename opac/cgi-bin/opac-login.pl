#!/usr/bin/perl
use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::AR::Novedades;
use CGI;

my $query = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                            template_name   => "opac-main.tmpl",
                                            query           => $query,
                                            type            => "opac",
                                            authnotrequired => 0,
                                            flagsrequired   => {    ui              => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'undefined'},
                                    });
                                    
C4::AR::Auth::redirectTo('/meran/opac-main.pl');
