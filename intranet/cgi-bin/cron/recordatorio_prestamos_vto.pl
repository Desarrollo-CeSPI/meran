#!/usr/bin/perl

use strict;
use C4::Date;
use CGI;

use Fcntl qw(:flock);

unless (!flock(DATA, LOCK_EX|LOCK_NB)) {
	if (C4::AR::Preferencias::getValorPreferencia('remindUser')){

		my $input       = new CGI;
		my $dateformat  = C4::Date::get_date_format();
		my $today       = C4::Date::format_date_in_iso(Date::Manip::ParseDate("today"),$dateformat);

	    if ( ($ENV{'REMOTE_ADDR'} eq '127.0.0.1')  || (!$ENV{'REMOTE_ADDR'}) ){
	        C4::AR::Prestamos::enviarRecordacionDePrestamo($today);
	    } else {
	        C4::AR::Debug::debug("recordatorio_prestamos => se intento correr script de una dir. IP no local => ".$ENV{'REMOTE_ADDR'});
	    }
	 
	    C4::AR::Debug::debug("REMOTE ADDRESS DE ENVIAR RECORDATORIO PRESTAMOS: ".$ENV{'REMOTE_ADDR'});

	}
}else{
	C4::AR::Debug::debug("reindexar => se intento correr script pero otra instancia se esta ejecutando. FALLO");
}

__DATA__
This exists so flock() code above works.
DO NOT REMOVE THIS DATA SECTION.

