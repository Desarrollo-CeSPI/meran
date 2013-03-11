#!/usr/bin/perl
use strict;
use CGI;
use C4::AR::Auth;
use JSON;

my $input           = new CGI;
my $authnotrequired = 0;

    my ($userid, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'}, 
                                                'opac'
                                );

my $obj = $input->param('obj');
$obj    = C4::AR::Utilidades::from_json_ISO($obj);

my %infoOperacion;
my %params;

$params{'nro_socio'}    = $userid;
$params{'id_prestamo'}  = $obj->{'id_prestamo'};
$params{'responsable'}  = $userid;
$params{'tipo'}         = 'OPAC';

my ($msg_object)        = C4::AR::Prestamos::t_renovarOPAC(\%params);
my $infoOperacionJSON   = to_json $msg_object;

#print $input->header;
C4::AR::Auth::print_header($session);
print $infoOperacionJSON;
