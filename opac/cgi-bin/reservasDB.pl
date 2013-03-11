#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::AR::Utilidades;
use JSON;

my $input           = new CGI;
my $authnotrequired = 0;
my ($nro_socio, $session, $flags) = checkauth( $input, 
                                        $authnotrequired,
                                        {   ui              => 'ANY', 
                                            tipo_documento  => 'ANY', 
                                            accion          => 'CONSULTA', 
                                            entorno         => 'usuarios'
                                        },
                                        "opac"
                            );

my $session = CGI::Session->load();
my $obj     = $input->param('obj');
$obj        = C4::AR::Utilidades::from_json_ISO($obj);

my %params;
$params{'id_reserva'}   = $obj->{'id_reserva'};
$params{'nro_socio'}    = $nro_socio;
$params{'responsable'}  = $nro_socio;
$params{'type'}         = "opac";

my $msg_object;

if ($obj->{'accion'} eq 'CANCELAR_RESERVA'){
    ($msg_object) = C4::AR::Reservas::t_cancelar_reserva(\%params);
}
elsif ($obj->{'accion'} eq 'CANCELAR_Y_RESERVAR'){
    $params{'id1'} = $obj->{'id1Nuevo'};
    $params{'id2'} = $obj->{'id2Nuevo'};
    ($msg_object)  = C4::AR::Reservas::t_cancelar_y_reservar(\%params);
}

my $infoOperacionJSON = to_json $msg_object;

C4::AR::Auth::print_header($session);
print $infoOperacionJSON;
