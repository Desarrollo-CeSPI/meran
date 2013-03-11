#!/usr/bin/perl
use strict;
require Exporter;
use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use  C4::AR::Utilidades;
use JSON;
use CGI;

my $query = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                template_name   => "opac-main.tmpl",
                                query           => $query,
                                type            => "opac",
                                authnotrequired => 1,
                                flagsrequired   => {  ui            => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
            });


use C4::Modelo::Contacto;

my ($contacto)  = C4::Modelo::Contacto->new();
my $msg_object  = C4::AR::Mensajes::create();
my $obj = $query->param('obj');
my $socio_reporte = C4::AR::Auth::getSessionSocioObject();
$obj    = C4::AR::Utilidades::from_json_ISO($obj);

    #verificamos que los campos requeridos tengan valor
if( C4::AR::Utilidades::validateString($obj->{'informe'}) ){
    $contacto->reporteCatalogo($obj,$socio_reporte);
    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U609', 'params' => []} ) ;
    $msg_object->{'success'} = 1;
}

my $infoOperacionJSON=to_json $msg_object;

C4::AR::Auth::print_header($session);
print $infoOperacionJSON;
