#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Reservas;
use C4::Context;

my $input = new CGI;

#Loggear todo!!!!!!!!!!!!!!
my $reserva = $input->Vars;

my $id2 = $reserva->{'id2'};
my $nro_socio = $reserva->{'nro_socio'};

my %params;

$params{'tipo'}= 'OPAC';
$params{'id2'}= $id2;
$params{'nro_socio'}= $nro_socio;

my ($msg_object)= C4::AR::Reservas::cancelarReservaDesdeGrupoYSocio(\%params);

if ($msg_object->{'error'}){
    C4::AR::Debug::debug("************** ERROR EN CANCELAR RESERVA DESDE KOHA *******************");
    C4::AR::Debug::debug("    ************************************************************      ");
    C4::AR::Debug::debug("           ************************************************           ");
    C4::AR::Debug::debug("             NO SE PUDO CANCELAR LA RESERVA!!!                        ");
    C4::AR::Debug::debug("             Sobre el grupo ".$id2."  DEL SOCIO ".$nro_socio."        ");
    C4::AR::Debug::debug("           ************************************************           ");
    C4::AR::Debug::debug("    ************************************************************      ");
    C4::AR::Debug::debug("********************************************************************* ");
}
