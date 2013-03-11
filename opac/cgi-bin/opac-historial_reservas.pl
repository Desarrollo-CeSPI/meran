#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use C4::AR::Estadisticas;

use CGI;

my $input=new CGI;

my ($template, $session, $t_params)= get_template_and_user({
									template_name => "opac-main.tmpl",
									query => $input,
									type => "opac",
									authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'undefined'},
									debug => 1,
			});

my $nro_socio                       = C4::AR::Auth::getSessionNroSocio($session);
my $ini                             = $input->param('page') || 0;
my $url                             = C4::AR::Utilidades::getUrlPrefix()."/opac-historial_reservas.pl?token=".$input->param('token');
my $orden                           = 'id DESC';
my ($ini,$pageNumber,$cantR)        = C4::AR::Utilidades::InitPaginador($ini);
my ($cantidad,$reservas_hashref)    = C4::AR::Reservas::getHistorialReservasParaTemplate($nro_socio,$ini,$cantR,$orden);

$t_params->{'paginador'}            = &C4::AR::Utilidades::crearPaginadorOPAC($cantidad,$cantR, $pageNumber,$url,$t_params);
$t_params->{'cantidad'}             = $cantidad;
$t_params->{'reservas'}             = $reservas_hashref;
$t_params->{'content_title'}        = C4::AR::Filtros::i18n("Historial de reservas");
$t_params->{'partial_template'}     = "opac-historial_reservas.inc";

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
