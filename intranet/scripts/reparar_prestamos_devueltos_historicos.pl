#!/usr/bin/perl
#
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.
#
use C4::AR::Prestamos;
use C4::Modelo::CircPrestamo;
use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::UsrSocio;
use C4::Modelo::CircReserva;



    my $prestamos_array_ref = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                                    query => [fecha_devolucion => { ne => undef}]
                                                                                   );
    my $reservas_encontradas=0;
    my $prestamos_pasados=0;
    my $responsable = "meranadmin";

    if(scalar(@$prestamos_array_ref) > 0){
      print "Vamos a procesar ".scalar(@$prestamos_array_ref)." préstamos con fecha de vencimiento.\n";

    # recorremos todos los prestamos, le pedimos la fecha de vencimiento
        foreach my $prestamo (@$prestamos_array_ref){
           my $perc = (($prestamos_pasados * 100) / scalar(@$prestamos_array_ref));
           print int($perc)." %\r\n";
            my $fechaVencimiento = $prestamo->getFecha_vencimiento();
            #Chequeamos si tiene reserva!  Por ahora no hago nada. La dejo para analizar.

            #Busco la reserva del prestamo
            my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(
                                query => [ id3 => { eq => $prestamo->getId3() },nro_socio => { eq => $prestamo->getNro_socio() }, estado => { eq => 'P' } ]
            );
            my $reserva = $reservas_array_ref->[0];

            if ($reserva) {
              print "Reserva encontrada id:".$reserva->getId_reserva()."\n";
              $reservas_encontradas++;
              #Deberían borrarse
              #$reserva->delete();
            }
            else{
              #**********************************Se registra el movimiento en rep_historial_circulacion***************************
                  my $tipo_operacion = "DEVOLUCION";
                  use C4::Modelo::RepHistorialCirculacion;

                  my %params = {};
                  $params{'nro_socio'}    = $prestamo->getNro_socio;

                  if(($prestamo->nivel3)&&($prestamo->nivel3->nivel2)){
                    $params{'id1'}          = $prestamo->nivel3->nivel2->nivel1->getId1;
                    $params{'id2'}          = $prestamo->nivel3->nivel2->getId2;
                  }else{
                    $params{'id1'}          = 0;
                    $params{'id2'}          = 0;
                  }

                  $params{'id3'}          = $prestamo->getId3;
                  $params{'nro_socio'}    = $prestamo->getNro_socio;
                  $params{'responsable'}  = $responsable || $prestamo->getNro_socio;
                  $params{'fecha'}        = $prestamo->getFecha_prestamo;
                  $params{'fecha_devolucion'}= $prestamo->getFecha_devolucion;
                  $params{'id_ui'}        = $prestamo->getId_ui_prestamo;
                  $params{'tipo'}         = $tipo_operacion;
                  $params{'tipo_prestamo'}= $prestamo->getTipo_prestamo;


                  my $historial_circulacion = C4::Modelo::RepHistorialCirculacion->new();
                  $historial_circulacion->agregar(\%params);

              #*******************************Fin***Se registra el movimiento en rep_historial_circulacion*************************
              #**********************************Se registra el movimiento en rep_historial_prestamo***************************
                      use C4::Modelo::RepHistorialPrestamo;
                      my $historial_prestamo =  C4::Modelo::RepHistorialPrestamo->new( );
                      $historial_prestamo->agregarPrestamo($prestamo,$fechaVencimiento);

                      #AHORA SE BORRA EL PRESTAMO DEVUELTO PASADO AL HISTORICO DE PRESTAMOS
                      $prestamo->delete();
                      $prestamos_pasados++;
              #**********************************Se registra el movimiento en rep_historial_prestamo***************************
            }
         }
       }

       print "Préstamos pasados: ".$prestamos_pasados."\n";
       print "Reservas colgadas!!: ".$reservas_encontradas."\n";
1;
