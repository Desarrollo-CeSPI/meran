#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::AR::Utilidades;
use JSON;
use C4::AR::AyudaMarc;

my $input           = new CGI;
my $obj             = $input->param('obj');

$obj                = C4::AR::Utilidades::from_json_ISO($obj);

my $tipoAccion      = $obj->{'tipoAccion'} || "";

my $authnotrequired = 0;

if($tipoAccion eq "LISTAR"){

    my ($template, $session, $t_params) = get_template_and_user({
                  template_name       => "admin/ayudaMarcAjax.tmpl",
                  query               => $input,
                  type                => "intranet",
                  authnotrequired     => 0,
                  flagsrequired       => {    ui              => 'ANY', 
                                              tipo_documento  => 'ANY', 
                                              accion          => 'CONSULTA', 
                                              entorno         => 'usuarios'},
                  debug               => 1,
          });

    my ($ayudasMarc,$cant)    = C4::AR::AyudaMarc::getAyudaMarc();

    $t_params->{'cant'}       = $cant;    
    $t_params->{'ayudasMarc'}   = $ayudasMarc;
    $t_params->{'selectCampoX'} = C4::AR::Utilidades::generarComboCampoX('eleccionCampoX()');

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}elsif($tipoAccion eq "AGREGAR_VISUALIZACION"){

    my ($user, $session, $flags)= checkauth(  $input, 
                                              $authnotrequired, 
                                              {   ui                => 'ANY', 
                                                  tipo_documento    => 'ANY', 
                                                  accion            => 'CONSULTA', 
                                                  entorno           => 'datos_nivel1'}, 
                                              'intranet'
                                  );

    my ($Message_arrayref)  = C4::AR::AyudaMarc::agregarAyudaMarc($obj);
    my $infoOperacionJSON   = to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}elsif ($tipoAccion eq "SHOW_MOD_AYUDA"){

    my $ayuda = C4::AR::AyudaMarc::getAyudaMarcById($obj->{'idAyuda'});

    my ($template, $session, $t_params) = get_template_and_user({
                                        template_name   => "admin/ayudaMarcMod.tmpl",
                                        query           => $input,
                                        type            => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired   => {  ui => 'ANY', 
                                                            accion => 'TODOS', 
                                                            entorno => 'usuarios'},
                                        debug => 1,
                    });
    
    $t_params->{'ayuda'}    = $ayuda;
    $t_params->{'idAyuda'}  = $obj->{'idAyuda'};

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}elsif ($tipoAccion eq "MOD_VISUALIZACION"){

    my ($user, $session, $flags)= checkauth(  $input, 
                                              $authnotrequired, 
                                              {   ui                => 'ANY', 
                                                  tipo_documento    => 'ANY', 
                                                  accion            => 'CONSULTA', 
                                                  entorno           => 'datos_nivel1'}, 
                                              'intranet'
                                  );

    my ($Message_arrayref)  = C4::AR::AyudaMarc::modificarAyudaMarc($obj);

    my $infoOperacionJSON   = to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}elsif ($tipoAccion eq "ELIMINAR"){

    my ($user, $session, $flags)= checkauth(  $input, 
                                              $authnotrequired, 
                                              {   ui                => 'ANY', 
                                                  tipo_documento    => 'ANY', 
                                                  accion            => 'CONSULTA', 
                                                  entorno           => 'datos_nivel1'}, 
                                              'intranet'
                                  );

    my ($Message_arrayref)  = C4::AR::AyudaMarc::eliminarAyudaMarc($obj->{'idAyuda'});

    my $infoOperacionJSON   = to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}    