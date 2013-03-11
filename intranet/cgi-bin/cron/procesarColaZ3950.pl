#!/usr/bin/perl

use strict;
use C4::AR::Z3950;

my $session = CGI::Session->new();
$session->param("type","intranet");


#Eliminar entradas viejas de la cola y los resultaods
#C4::AR::Z3950::limpiarBusquedas();
C4::AR::Debug::debug( "Chequeo cola de busqueda z3950 (".C4::Date::getCurrentTimestamp.")");

my $cola =C4::AR::Z3950::busquedasEncoladas();

if  ($cola) {
#si hay algo que buscar agarro el primero
        C4::AR::Debug::debug( "Buscando por ".$cola->[0]->getBusqueda);
        C4::AR::Z3950::efectuarBusquedaZ3950($cola->[0]);
        C4::AR::Debug::debug( "Busqueda ".$cola->[0]->getBusqueda." Finalizada");
}