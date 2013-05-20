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

use CGI::Session;
use C4::Context;

my $dbh = C4::Context->dbh;

print "INICIO \n";
my $tt1 = time();
print "Modificando tablas necesarias \n";
    aplicarCambiosCirculacion();

print "Referencias de usuarios en circulacion \n";
  repararReferenciasDeUsuarios();
print "FIN!!! \n";
my $tt2 = time();
print "\n GRACIAS DICO!!! \n";

my $tardo2=($tt2 - $tt1);
my $min= $tardo2/60;
my $hour= $min/60;
print "AL FIN TERMINO TODO!!! Tardo $tardo2 segundos !!! que son $min minutos !!! o mejor $hour horas !!!\n";

#-----------------------------------------------------------------------------------------------------------------------------------#-----------------------------------------------------------------------------------------------------------------------------------#-----------------------------------------------------------------------------------------------------------------------------------#-----------------------------------------------------------------FUNCIONES---------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------#-----------------------------------------------------------------------------------------------------------------------------------#-----------------------------------------------------------------------------------------------------------------------------------

  sub aplicarCambiosCirculacion {

        aplicarSQL("updatesDeCirculacion.sql");

    }

    ###########################################################################################################
    #                                    REPARARAR REFERENCIAS SOCIO                                          #
    #           En todos lados se utiliza nro_socio pero en koha hay tablas que tienen id_socio               #
    #                                           circ_reserva                                                  #
    #                                           circ_prestamo                                                 #
    #                                           circ_sancion                                                  #
    ###########################################################################################################

  sub repararReferenciasDeUsuarios {


    my $cant_usr=$dbh->prepare("SELECT count(*) as cantidad FROM usr_socio ;");
    $cant_usr->execute();
    my $cantidad=$cant_usr->fetchrow;
    my $usuario=1;
    print "Se van a procesar $cantidad usuarios \n";


    my @refusrs = ('circ_reserva','circ_prestamo','circ_sancion');
    

    my $usuarios=$dbh->prepare("SELECT * FROM usr_socio;");
    $usuarios->execute();

    my $cant_usr=1;
    while (my $usuario=$usuarios->fetchrow_hashref) {

    my $porcentaje= int (($cant_usr * 100) / $cantidad );
    print "Procesando usuario: $cant_usr de $cantidad ($porcentaje%) \r";

        foreach $tabla (@refusrs)
      {
            my $refusuario=$dbh->prepare("UPDATE $tabla  SET nro_socio='".$usuario->{'nro_socio'}."' WHERE borrowernumber='". $usuario->{'id_socio'} ."' ;");
            $refusuario->execute();
      }

    $cant_usr++;
    }


    foreach $tabla (@refusrs)
    {
      my $refusr=$dbh->prepare("ALTER TABLE $tabla DROP borrowernumber;");
      $refusr->execute();

      #Borro referencias insatisfechas
      my $refusrnull=$dbh->prepare("DELETE FROM $tabla WHERE nro_socio ='0';");
      $refusrnull->execute();

    }

    }

    #########################################################################
    #           GRACIAS!!!!!!!!!!               #
    #########################################################################

  sub aplicarSQL {
    my ($sql)=@_;

    my $PASSWD = C4::Context->config("pass");
    my $USER = C4::Context->config("user");
    my $BASE = C4::Context->config("database");

    system("mysql -f --default-character-set=utf8 $BASE -u$USER -p$PASSWD < $sql ") == 0 or print "Fallo el sql ".$sql." \n";

    }