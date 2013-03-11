#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Novedades;
my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
									template_name       => "admin/ver_novedad.tmpl",
									query               => $input,
									type                => "intranet",
									authnotrequired     => 0,
									flagsrequired       => {    ui              => 'ANY', 
                                                                tipo_documento  => 'ANY', 
                                                                accion          => 'CONSULTA', 
                                                                entorno         => 'usuarios'},
									debug               => 1,
			    });

my $obj                         = $input->param('obj');
$obj                            = C4::AR::Utilidades::from_json_ISO($obj);
my ($id_novedad)                = $obj->{'id'};
my ($novedad)                   = C4::AR::Novedades::getNovedad($id_novedad);
my @linksTodos                  = split("\ ", $novedad->getLinks());
my ($imagenes_novedad,$cant)    = C4::AR::Novedades::getImagenesNovedad($id_novedad);

$t_params->{'cant_novedades'}   = $cant;    
$t_params->{'imagenes_hash'}    = $imagenes_novedad;
$t_params->{'links'}            = \@linksTodos;
$t_params->{'cant_links'}       = @linksTodos;
$t_params->{'novedad'}          = $novedad;
$t_params->{'page_sub_title'}   = C4::AR::Filtros::i18n("Novedades - Ver novedad");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
