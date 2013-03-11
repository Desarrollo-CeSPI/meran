#!/usr/bin/perl

use strict;
use CGI;
use C4::Output;
use C4::AR::Auth;

use C4::AR::Estantes;

my $input = new CGI;

my $subestante_actual;
my $padre_actual;

 
my ($template, $session, $t_params) = get_template_and_user ({
                                        template_name   => 'estantes/estante.tmpl',
                                        query       => $input,
                                        type        => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired => {  ui => 'ANY', 
                                                            tipo_documento => 'ANY', 
                                                            accion => 'CONSULTA', 
                                                            entorno => 'undefined'},
                                        debug => 1,
                 });



if ($input->param('id_estante')){
  $subestante_actual= $input->param('id_estante');
  $padre_actual= $input->param('id_padre');
  C4::AR::Debug::debug($padre_actual);
}


my $estantes_publicos = C4::AR::Estantes::getListaEstantesPublicos();
$t_params->{'subestante_actual'}= $subestante_actual;
$t_params->{'padre_actual'}= $padre_actual;

$t_params->{'cant_estantes'}= @$estantes_publicos;
$t_params->{'ESTANTES'}= $estantes_publicos;


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
