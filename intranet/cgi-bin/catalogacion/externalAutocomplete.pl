#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Utilidades;
use C4::AR::Auth;

my $input = new CGI;
my $authnotrequired = 0;
my $flagsrequired = {   ui => 'ANY', 
                        tipo_documento => 'ANY', 
                        accion => 'CONSULTA', 
                        entorno => 'sistema'};

my $session = CGI::Session->load();

my $type = $session->param('type') || "opac";


my $string      = C4::AR::Utilidades::trim( $input->param('query') );
C4::AR::Debug::debug("BUSCASTE: ".$string);


my $result = C4::AR::Utilidades::catalogoAutocomplete($string);



C4::AR::Auth::print_header($session);
print $result;

1;