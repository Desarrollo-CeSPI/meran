#!/usr/bin/perl

use strict;
use C4::Date;
use CGI;

use Fcntl qw(:flock);

unless (!flock(DATA, LOCK_EX|LOCK_NB)) {

    if(C4::AR::Preferencias::getValorPreferencia('enableMailPrestVencidos')){

		    C4::AR::Debug::debug("CRON => mail_prestamos_vencidos.pl => Se envian via CRON los mails de prestamos vencidos, el FLAG enableMailPrestVencidos esta activado!");

		    if (($ENV{'REMOTE_ADDR'} eq '127.0.0.1') || (!$ENV{'REMOTE_ADDR'})) {
			    C4::AR::Prestamos::enviarRecordacionDePrestamoVencidos();
		    } else {
			    C4::AR::Debug::debug("mail_prestamos_vencidos.pl => se intento correr script de una dir. IP no local => ".$ENV{'REMOTE_ADDR'});
		    }
		
    }

}else{
	C4::AR::Debug::debug("mail_prestamos_vencidos.pl => se intento correr script pero otra instancia se esta ejecutando. FALLO");
}

__DATA__
This exists so flock() code above works.
DO NOT REMOVE THIS DATA SECTION.

