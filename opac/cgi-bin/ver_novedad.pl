#!/usr/bin/perl
use strict;
require Exporter;
use CGI;
use C4::AR::Auth;         # checkauth, getnro_socio.

use C4::AR::Novedades;

my $query = new CGI;

my $input = $query;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name   => "opac-main.tmpl",
                                    query           => $query,
                                    type            => "opac",
                                    authnotrequired => 1,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
             });


eval{
	my $id_novedad                      = $input->param('id');
	my $novedad                         = C4::AR::Novedades::getNovedad($id_novedad);
	my ($imagenes_novedad,$cant)        = C4::AR::Novedades::getImagenesNovedad($id_novedad);
	
	#solo si hay imagenes para esa novedad
	if($cant){
	
	    $t_params->{'imagenes_hash'}    = $imagenes_novedad;
	
	}
	my @linksTodos = split("\ ", $novedad->getLinks());
	
	$t_params->{'cant'}                 = $cant;
	$t_params->{'novedad'}              = $novedad;
	$t_params->{'links'}                = \@linksTodos;
	$t_params->{'cant_links'}           = @linksTodos;
	$t_params->{'partial_template'}     = "ver_novedad.inc";
	
};

if ($@){
    C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/opac-main.pl?token='.$session->param('token'));	
}

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
