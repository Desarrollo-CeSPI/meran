#!/usr/bin/perl

use strict;
require Exporter;
use C4::Context;
use CGI;
use C4::AR::Sphinx qw(reindexar);
use Fcntl qw(:flock);

unless (!flock(DATA, LOCK_EX|LOCK_NB)) {
    C4::AR::Debug::debug("CRON => reindexar.pl!!!!!");
    if (($ENV{'REMOTE_ADDR'} eq '127.0.0.1') || (!$ENV{'REMOTE_ADDR'})) {
	    C4::AR::Sphinx::reindexar();
	} else {
	    C4::AR::Debug::debug("reindexar => se intento correr script de una dir. IP no local => ".$ENV{'REMOTE_ADDR'});
	} 

}else{
	C4::AR::Debug::debug("reindexar => se intento correr script pero otra instancia se esta ejecutando. FALLO");
}

__DATA__
This exists so flock() code above works.
DO NOT REMOVE THIS DATA SECTION.
