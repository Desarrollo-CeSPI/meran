#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::AR::Utilidades;
use JSON;
use C4::AR::TipoDocumento;

my $input           = new CGI;
my $obj             = $input->param('obj');

$obj                = C4::AR::Utilidades::from_json_ISO($obj);

my $tipoAccion      = $obj->{'tipoAccion'} || "";

my $authnotrequired = 0;

if($tipoAccion eq "LISTAR"){

    my ($template, $session, $t_params) = get_template_and_user({
                  template_name       => "catalogacion/tipoDocumentoAjax.tmpl",
                  query               => $input,
                  type                => "intranet",
                  authnotrequired     => 0,
                  flagsrequired       => {    ui              => 'ANY', 
                                              tipo_documento  => 'ANY', 
                                              accion          => 'CONSULTA', 
                                              entorno         => 'usuarios'},
                  debug               => 1,
          });

    my ($tiposDocumento,$cant)     = C4::AR::TipoDocumento::getTipoDocumento();

    $t_params->{'cant'}             = $cant;    
    $t_params->{'tiposDocumento'}   = $tiposDocumento;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}elsif($tipoAccion eq "SHOW_MOD_TIPO_DOC"){

    my ($template, $session, $t_params) = get_template_and_user({
                  template_name       => "catalogacion/modTipoDocumento.tmpl",
                  query               => $input,
                  type                => "intranet",
                  authnotrequired     => 0,
                  flagsrequired       => {    ui              => 'ANY', 
                                              tipo_documento  => 'ANY', 
                                              accion          => 'CONSULTA', 
                                              entorno         => 'usuarios'},
                  debug               => 1,
          });

    my ($tipoDocumento)             = C4::AR::TipoDocumento::getTipoDocumentoByTipo($obj->{'idTipoDoc'});

    $t_params->{'tipoDocumento'}    = $tipoDocumento;
    $t_params->{'idTipoDoc'}        = $obj->{'idTipoDoc'};

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}elsif($tipoAccion eq "DEL_TIPO_DOC"){

    my ($user, $session, $flags)= checkauth(  $input, 
                                              $authnotrequired, 
                                              {   ui                => 'ANY', 
                                                  tipo_documento    => 'ANY', 
                                                  accion            => 'CONSULTA', 
                                                  entorno           => 'datos_nivel1'}, 
                                              'intranet'
                                  );

    my ($Message_arrayref) = C4::AR::TipoDocumento::deleteTipoDocumento($obj->{'idTipoDoc'});
    my $infoOperacionJSON  = to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}
# elsif($tipoAccion eq "AGREGAR_TIPO_DE_DOCUMENTO"){

#     my ($user, $session, $flags)= checkauth(  $input, 
#                                               $authnotrequired, 
#                                               {   ui                => 'ANY', 
#                                                   tipo_documento    => 'ANY', 
#                                                   accion            => 'CONSULTA', 
#                                                   entorno           => 'datos_nivel1'}, 
#                                               'intranet'
#                                   );

#     my ($Message_arrayref) = C4::AR::TipoDocumento::agregarTipoDocumento($obj);
#     my $infoOperacionJSON  = to_json $Message_arrayref;

#     C4::AR::Auth::print_header($session);
#     print $infoOperacionJSON;

# }