#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use C4::Context;
use C4::AR::Proveedores;
use C4::AR::Recomendaciones;
use CGI;
use C4::AR::PdfGenerator;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
    template_name   => "adquisiciones/generatePedidoCotizacion.tmpl",
    query           => $input,
    type            => "intranet",
    authnotrequired => 0,
    flagsrequired   => {    ui => 'ANY', 
                            tipo_documento => 'ANY', 
                            accion => 'CONSULTA', 
                            tipo_permiso => 'general',
                            entorno => 'adq_intra'},
    debug           => 1,
});

my $recomendaciones_activas   = C4::AR::Recomendaciones::getRecomendacionesActivas();

if($recomendaciones_activas){
    my @resultsdata;
      
    for my $recomendacion (@$recomendaciones_activas){   
        my %row = ( recomendacion => $recomendacion, );
        push(@resultsdata, \%row);
    }

    $t_params->{'resultsloop'}   = \@resultsdata;       
}

$t_params->{'page_sub_title'}       = C4::AR::Filtros::i18n("Pedidos de Cotizacion");
$t_params->{'cant_recomendaciones'} = scalar(@$recomendaciones_activas);

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
