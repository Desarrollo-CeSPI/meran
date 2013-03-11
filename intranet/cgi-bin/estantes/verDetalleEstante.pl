#!/usr/bin/perl

use strict;
use CGI;
use C4::Output;
use C4::AR::Auth;
use C4::AR::Estantes;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user ({
                                        template_name   => 'estantes/verDetalleEstante.tmpl',
                                        query       => $input,
                                        type        => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired => {  ui => 'ANY', 
                                                            tipo_documento => 'ANY', 
                                                            accion => 'CONSULTA', 
                                                            entorno => 'undefined'},
                                        debug => 1,
                 });

my $estantes_publicos = C4::AR::Estantes::getListaEstantesPublicos();
$t_params->{'cant_estantes'}= @$estantes_publicos;
$t_params->{'ESTANTES'}= $estantes_publicos;

my $id_estantes=$input->param('id_estante');
my $estante = C4::AR::Estantes::getEstante($id_estantes);
if($estante){
  my $aux_estante = $estante;
  my @lista_estantes;
  while ($aux_estante){
    unshift(@lista_estantes,$aux_estante);
    if($aux_estante->getPadre){
      $aux_estante= $aux_estante->estante_padre;
    }else{
      $aux_estante=0;
    }
  }
  $t_params->{'LISTA_ESTANTES'}= \@lista_estantes;
}
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
