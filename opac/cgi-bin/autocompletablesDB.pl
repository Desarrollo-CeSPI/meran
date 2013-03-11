#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Utilidades;
use C4::AR::Auth;
use Encode;

my $input = new CGI;
my $authnotrequired = 0;
my $flagsrequired = {   ui => 'ANY', 
                        tipo_documento => 'ANY', 
                        accion => 'CONSULTA', 
                        entorno => 'undefined'},

my $session = CGI::Session->load();

my $type = $session->param('type') || "opac";

my ($user, $session, $flags)= C4::AR::Auth::checkauth($input, $authnotrequired, $flagsrequired, $type);

my $accion= C4::AR::Utilidades::trim( $input->param('accion') );
my $string= C4::AR::Utilidades::trim( $input->param('q') );

#Variable para luego hacerle el print
my $result;

if ($accion eq 'autocomplete_ciudades'){

    $result = C4::AR::Utilidades::ciudadesAutocomplete($string);
}
elsif ($accion eq 'autocomplete_catalogo_biblioteca'){

     #$result = C4::AR::Utilidades::catalogoBibliotecaAutocomplete($string);
     $result = C4::AR::Utilidades::catalogoAutocomplete($string);
}
elsif ($accion eq 'autocomplete_catalogo'){

    $result = C4::AR::Utilidades::catalogoAutocomplete($string);
}

print $session->header;
print Encode::decode_utf8($result);

1;