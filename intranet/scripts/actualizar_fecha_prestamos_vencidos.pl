#!/usr/bin/perl

#actualiza la fecha de vencimiento del prestamo en la base

use strict;
use CGI;
use C4::Modelo::CircPrestamo::Manager;

my $prestamos_array_ref = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo();
my $cant_total          = scalar(@$prestamos_array_ref);
my $i                   = 1;

foreach my $prestamo (@$prestamos_array_ref){
    $prestamo->setFecha_vencimiento_reporte($prestamo->getFecha_vencimiento());    
    print "Actualizando prestamo $i de $cant_total \n";   
    $i++;
    $prestamo->save();
}  