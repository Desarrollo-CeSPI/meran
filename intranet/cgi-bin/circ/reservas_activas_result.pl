#!/usr/bin/perl

use strict;
use C4::AR::Auth;

use CGI;
use C4::AR::Estadisticas;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                            template_name => "circ/reservas_activas_result.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'undefined'},
                            debug => 1,
                });

my $obj         =   C4::AR::Utilidades::from_json_ISO($input->param('obj'));
my $id_ui       =   C4::AR::Preferencias::getValorPreferencia("defaultUI");

if (!$obj){
	$obj = $input->Vars;
}

my $orden       =   $obj->{'orden'} || 0;
my $tipoReserva =   $obj->{'tipoReserva'}; # Tipo de reserva

C4::AR::Validator::validateParams('VA001',$obj,['tipoReserva']);

my $funcion =   $obj->{'funcion'};

my $ini     =   $obj->{'ini'};
my ($ini,$pageNumber,$cantR)=C4::AR::Utilidades::InitPaginador($ini);
#FIN inicializacion

my ($cantidad,$resultsdata)= C4::AR::Estadisticas::reservas($id_ui,$orden,$ini,$cantR,$tipoReserva);

$t_params->{'paginador'}= C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);

$t_params->{'reservas'}= $resultsdata;
$t_params->{'cantidad'}= $cantidad;
$t_params->{'tipoReserva'}= $tipoReserva;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
