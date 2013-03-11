#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::NovedadesIntra;
my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                                    template_name   => "admin/global/ver_novedad_intra.tmpl",
                                    query           => $input,
                                    type            => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'usuarios'},
                                    debug           => 1,
                });

my $obj                         = $input->param('obj');
$obj                            = C4::AR::Utilidades::from_json_ISO($obj);
my ($id_novedad)                = $obj->{'id'};
my ($novedad)                   = C4::AR::NovedadesIntra::getNovedad($id_novedad);
my @linksTodos                  = split("\ ", $novedad->getLinks());

$t_params->{'links'}            = \@linksTodos;
$t_params->{'cant_links'}       = @linksTodos;
$t_params->{'novedad'}          = $novedad;
$t_params->{'page_sub_title'}   = C4::AR::Filtros::i18n("Novedades - Ver novedad");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
