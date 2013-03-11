#!/usr/bin/perl
use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Date;
use CGI;

my $query = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name   => "opac-main.tmpl",
                                    query           => $query,
                                    type            => "opac",
                                    authnotrequired => 0,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
            });

$t_params->{'opac'};

my $nro_socio   = C4::AR::Auth::getSessionNroSocio();
my $sanciones   = C4::AR::Sanciones::tieneSanciones($nro_socio);

#C4::AR::Debug::debug("sancionado : ".$san."-----------------------------");
#C4::AR::Utilidades::printHASH($san);
#my $dateformat  = C4::Date::get_date_format();
#if ($san){
#    if ($san->{'id3'}){
#        my $aux = C4::AR::Nivel1::getNivel1FromId3($san->{'id3'});
#        #FALTA ARMAR EL TIPO DE PRESTAMO, DE DONDE LO SACAMOS???
#        $san->{'description'}.=": ".$aux->getTitulo." (".$aux->getAutor.") ";
#    }
#    $san->{'fecha_final'}       = format_date($san->getFecha_final,$dateformat);
#    $san->{'fecha_comienzo'}    = format_date($san->getFecha_comienzo,$dateformat);
#    $t_params->{'sancion'}      = $san;
#}

if ($sanciones){
	$t_params->{'sanciones'} = $sanciones;
}

$t_params->{'content_title'}    = C4::AR::Filtros::i18n("Sanciones");

$t_params->{'partial_template'} = "opac-detalle_sanciones.inc";
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
