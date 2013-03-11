#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Proveedores;

my $input = new CGI;

my $id_proveedor    = $input->param('id_proveedor');
my $tipoAccion      = $input->param('action');

my ($template, $session, $t_params);

if ($tipoAccion eq "EDITAR") {
# se edita la informacion del proveedor   
 
    ($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
            template_name   => '/adquisiciones/datosProveedor.tmpl',
            query           => $input,
            type            => "intranet",
            authnotrequired => 0,
            flagsrequired   => {    ui => 'ANY',   
                                    tipo_documento => 'ANY', 
                                    accion => 'MODIFICACION', 
                                    tipo_permiso => 'general',
                                    entorno => 'adq_intra'},
    });
    
    my $comboDeTipoDeDoc = &C4::AR::Utilidades::generarComboTipoDeDoc();
    $t_params->{'combo_tipo_documento'} = $comboDeTipoDeDoc;

}else{
# se muestran los detalles del proveedor

          ($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
                      template_name     => '/adquisiciones/detalleProveedor.tmpl',
                      query             => $input,
                      type              => "intranet",
                      authnotrequired   => 0,
                      flagsrequired     => {    ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                tipo_permiso => 'general',
                                                entorno => 'adq_intra'},
          });    
}

$t_params->{'formas_envio'}             = C4::AR::Proveedores::getFormasEnvioProveedor($id_proveedor);
$t_params->{'proveedor'}                = C4::AR::Proveedores::getProveedorInfoPorId($id_proveedor);
$t_params->{'monedas'}                  = C4::AR::Proveedores::getMonedasProveedor($id_proveedor);
$t_params->{'tipo_materiales'}          = &C4::AR::Utilidades::generarComboTipoDeMaterial();
$t_params->{'materiales_proveedor'}     = C4::AR::Proveedores::getMaterialesProveedor($id_proveedor);
$t_params->{'formas_envio'}             = &C4::AR::Utilidades::generarComboFormasDeEnvio();
$t_params->{'formas_envio_proveedor'}   = C4::AR::Proveedores::getFormasEnvioProveedor($id_proveedor);
$t_params->{'persona_fisica'}           = C4::AR::Proveedores::isPersonaFisica($id_proveedor);

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
