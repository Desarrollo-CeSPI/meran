#!/usr/bin/perl

use strict;
use C4::AR::Auth;

use CGI;
use C4::AR::Estadisticas;

my $input = new CGI;
my$obj = $input->Vars;

my ($template, $session, $t_params) = get_template_and_user({
                            template_name => "circ/reservas_activas_edicion_result.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'undefined'},
                            debug => 1,
                });


my $id_ui       =   C4::AR::Preferencias::getValorPreferencia("defaultUI");
my $tipoReserva =   $obj->{'tipoReserva'}; # Tipo de reserva
my $id2 =   $obj->{'id2'}; # Tipo de reserva

C4::AR::Validator::validateParams('VA001',$obj,['tipoReserva']);

my $ini     =   $obj->{'ini'};
my ($ini,$pageNumber,$cantR)=C4::AR::Utilidades::InitPaginador($ini);
#FIN inicializacion

my ($cantidad,$resultsdata)= C4::AR::Estadisticas::reservasEdicion($id_ui,$ini,$cantR,$tipoReserva,$id2);

$t_params->{'reservas'}= $resultsdata;
$t_params->{'cantidad'}= $cantidad;
$t_params->{'tipoReserva'}= $tipoReserva;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
