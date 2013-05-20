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