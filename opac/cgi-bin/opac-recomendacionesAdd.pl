#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use C4::Context;
use C4::AR::Recomendaciones;
use JSON;
use CGI;

my $input = new CGI;

my $obj   = $input->param('obj');
$obj = C4::AR::Utilidades::from_json_ISO($obj);

my ($template, $session, $t_params) = get_template_and_user({
    template_name => "opac-main.tmpl",
    query => $input,
    type => "opac",
    authnotrequired => 0,
    flagsrequired => {  ui => 'ANY', 
                        tipo_documento => 'ANY', 
                        accion => 'ALTA', 
                        tipo_permiso => 'general',
                        entorno => 'adq_opac'},
    debug => 1,
});

# my $input_params = $input->Vars;

my $usr_socio_id= C4::AR::Usuarios::getSocioInfoPorNroSocio(C4::AR::Auth::getSessionUserID($session))->getId_socio();

my $status = C4::AR::Recomendaciones::agregarRecomendacion($obj,$usr_socio_id);

# FIXME  iterar por cada detalle agregado al a recomendacion (por ahora agrega solo un detalle)




#


# TODO MOSTRAR MENSAJE

$t_params->{'message'}= $status->{'messages'}[0]->{'message'};

# if ($status){
#     C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/opac-recomendaciones.pl?token'.$input->param('token'));
# }