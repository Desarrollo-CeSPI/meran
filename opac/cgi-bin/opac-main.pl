#!/usr/bin/perl

use strict;
require Exporter;
use C4::Output;  
use C4::AR::Auth;
use C4::AR::Novedades;
use CGI;


# my $t = $C4::AR::CacheMeran::CACHE_MERAN2;

my $query =  CGI->new;

my ($template, $session, $t_params)= get_template_and_user({
                                            template_name   => "opac-main.tmpl",
                                            query           => $query,
                                            type            => "opac",
                                            authnotrequired => 1,
                                            flagsrequired   => {ui          => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'undefined'},
                                    });



my $nro_socio                       = $session->param('nro_socio');        

#solo si hay socio logueado se hace todo esto
if($nro_socio){

    my $orden                       = 'date_due desc';
    my $ini                         = 1;
    my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);
    my ($cant,$prestamos_array_ref) = C4::AR::Prestamos::getHistorialPrestamosVigentesParaTemplate($nro_socio,$ini,$cantR, $orden);
    my $reservas                    = C4::AR::Reservas::obtenerReservasDeSocio($nro_socio);
    my $sanciones                   = C4::AR::Sanciones::tieneSanciones($nro_socio);
    my $racount                     = 0;
    my $recount                     = 0;

    if ($reservas){
        my @reservas_asignadas;
        my @reservas_espera;

        foreach my $reserva (@$reservas) {
            if ($reserva->getId3) {
                #Reservas para retirar
                push @reservas_asignadas, $reserva;
                $racount++;
            }else{
                #Reservas en espera
                push @reservas_espera, $reserva;
                $recount++;
            }
        }
        $t_params->{'RESERVAS_ASIGNADAS'}   = \@reservas_asignadas;
        $t_params->{'RESERVAS_ESPERA'}      = \@reservas_espera;
    }

    if ($sanciones){
        $t_params->{'sanciones'}            = $sanciones;
        $t_params->{'cant_sanciones'}       = scalar(@$sanciones) ;
    } else {
        $t_params->{'cant_sanciones'}       = 0;
    }
    
    $t_params->{'reservas_asignadas_count'} = $racount;
    $t_params->{'reservas_espera_count'}    = $recount;
    $t_params->{'prestamos'}                = $prestamos_array_ref;
    $t_params->{'cantidad_prestamos'}       = $cant;
    $t_params->{'nro_socio'}                = $nro_socio;

}
#endif nro_socio

my $apertura                        = C4::AR::Preferencias::getValorPreferencia("open");
my $cierre                          = C4::AR::Preferencias::getValorPreferencia("close");
my ($cantidad_novedades,$novedades) = C4::AR::Novedades::getUltimasNovedades(1);

$t_params->{'novedad'}              = $novedades;
$t_params->{'apertura_ui'}          = $apertura;
$t_params->{'cierre_ui'}            = $cierre;
$t_params->{'apertura_ui'}          = $apertura;
$t_params->{'title_search_bar'}     = C4::AR::Preferencias::getValorPreferencia("title_search_bar"),
$t_params->{'partial_template'}     = "opac-content_data.inc";
$t_params->{'noAjaxRequests'}       = 0;
$t_params->{'portada'}              = C4::AR::Novedades::getPortadaOpac();
$t_params->{'cant_portada'}         = C4::AR::Novedades::getCantPortadaOpac();

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
