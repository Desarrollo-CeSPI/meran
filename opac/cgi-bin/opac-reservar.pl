#!/usr/bin/perl
# NOTE: This file uses standard 8-character tabs

use strict;
require Exporter;
use CGI;
use C4::AR::Auth;        
use C4::AR::Reservas;
use JSON;
use C4::AR::Mensajes;

my $input = new CGI;
my ($template, $session, $t_params)= get_template_and_user({
                                  template_name => "opac-reservar.tmpl",
                                  query => $input,
                                  type => "opac",
                                  authnotrequired => 0,
                                  flagsrequired => {    ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'circ_opac', 
                                                        tipo_permiso => 'circulacion'},
                                  debug => 1,
});

my $obj = $input->param('obj');
$obj    = C4::AR::Utilidades::from_json_ISO($obj);


my $id1                     = $obj->{'id1'};
my $id2                     = $obj->{'id2'};
my $socio                   = $session->param('userid');

my %params;
$params{'tipo'}             = 'OPAC';
$params{'id1'}              = $id1;
$params{'id2'}              = $id2;
$params{'nro_socio'}        = $socio;
$params{'responsable'}      = $socio;
$params{'tipo_prestamo'}    = 'DO';
$params{'es_reserva'}       = 1;

my ($msg_object)            = C4::AR::Reservas::t_reservarOPAC(\%params);

my $infoOperacionJSON       = to_json $msg_object;
  
C4::AR::Auth::print_header($session);
print $infoOperacionJSON; 

