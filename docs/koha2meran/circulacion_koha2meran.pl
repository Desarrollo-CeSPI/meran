#!/usr/bin/perl

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

