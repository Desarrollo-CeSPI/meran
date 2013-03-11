#!/usr/bin/perl

use strict;
require Exporter;
use C4::Context;
use CGI;
use C4::AR::Sphinx qw(sphinx_start);
use Fcntl qw(:flock);

C4::AR::Debug::debug("Levantando los servicios necesarios => Sphinx!");
    if (($ENV{'REMOTE_ADDR'} eq '127.0.0.1') || (!$ENV{'REMOTE_ADDR'})) {
	    C4::AR::Sphinx::sphinx_start();
	} else {
	    C4::AR::Debug::debug("Levantando el Sphinx => se intento correr script de una dir. IP no local => ".$ENV{'REMOTE_ADDR'});
	} 

}else{
	C4::AR::Debug::debug("Levantando el Sphinx => se intento correr script pero otra instancia se esta ejecutando. FALLO");
}

__DATA__
This exists so flock() code above works.
DO NOT REMOVE THIS DATA SECTION.
