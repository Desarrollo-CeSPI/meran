#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::Output;
use C4::Context;
use C4::AR::Utilidades;
use Date::Manip;
use C4::Date;
my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                        template_name => "admin/global/feriados.tmpl",
                        query => $input,
                        type => "intranet",
                        authnotrequired => 0,
                        flagsrequired => {  ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'CONSULTA', 
                                            entorno => 'undefined'},
                        debug => 1,
			    });


my $feriadosh =$input->param('feriadosh');
&saveholidays($feriadosh);

my ($cant,@feriados)=getholidays();
my @loop_data;

for (my $i=0; $i < $cant; $i++){
	my %row_data;
	my @fecha = split('-',@feriados[$i]);
	$row_data{anio} = $fecha[0];
	$row_data{mes} = $fecha[1] - 1; # Porque en la inicializacion javascript los meses van del 0 al 11
	$row_data{dia} = $fecha[2];
	push(@loop_data, \%row_data);
}

$t_params->{'loop'}= \@loop_data;
$t_params->{'cant'}= $cant;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
