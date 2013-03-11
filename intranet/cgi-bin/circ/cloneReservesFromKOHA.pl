#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Reservas;
use C4::Context;

my $input = new CGI;

#Loggear todo!!!!!!!!!!!!!!
my $reserva = $input->Vars;

my $id1 = $reserva->{'id1'};
my $id2 = $reserva->{'id2'};
my $nro_socio = $reserva->{'nro_socio'};
my $fecha_reserva = $reserva->{'fecha'};
my $nro_reserva = $reserva->{'nro_reserva'};


my %params;

$params{'tipo'}= 'OPAC';
$params{'id1'}= $id1;
$params{'id2'}= $id2;
$params{'nro_socio'}= $nro_socio;
$params{'responsable'}= $nro_socio;
$params{'tipo_prestamo'}= 'DO';

my ($msg_object)= C4::AR::Reservas::t_reservarOPAC(\%params);

if ($msg_object->{'error'}){
    C4::AR::Debug::debug("************** ERROR EN CLONAR RESERVA DESDE KOHA *******************");
    C4::AR::Debug::debug("    ************************************************************     ");
    C4::AR::Debug::debug("           ************************************************          ");
    C4::AR::Debug::debug("             Checkear la reserva numero ".$nro_reserva."  NO SE PUDO RESERVAR!!!");
    C4::AR::Debug::debug("             Sobre el grupo ".$id2."  DEL SOCIO ".$nro_socio);
    C4::AR::Debug::debug("           ************************************************          ");
    C4::AR::Debug::debug("    ************************************************************     ");
    C4::AR::Debug::debug("*********************************************************************");
}
