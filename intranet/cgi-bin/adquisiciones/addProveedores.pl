#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use C4::Context;
use C4::AR::Proveedores;
use CGI;
use JSON;

my $input   = new CGI;
my $obj     = $input->param('obj');

my ($template, $session, $t_params) = get_template_and_user({
    template_name   => "adquisiciones/addProveedores.tmpl",
    query           => $input,
    type            => "intranet",
    authnotrequired => 0,
    flagsrequired   => {    ui => 'ANY', 
                            tipo_documento => 'ANY',   
                            accion => 'ALTA', 
                            tipo_permiso => 'general',
                            entorno => 'adq_intra'}, # FIXME
                            
    debug           => 1,
});

# preguntamos si existe el objeto JSON, si es asi, estamos guardando en la base
if($obj){
    $obj                    = C4::AR::Utilidades::from_json_ISO($obj);
    my ($message)           = C4::AR::Proveedores::agregarProveedor($obj);
    my $infoOperacionJSON   = to_json $message;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}else{
# mostramos el template porque esta agregando normalmente

    my $comboDeTipoDeDoc       = &C4::AR::Utilidades::generarComboTipoDeDocConValuesIds();
    my $combo_tipo_materiales  = &C4::AR::Utilidades::generarComboTipoDeMaterial();
    my $combo_formas_envio     = &C4::AR::Utilidades::generarComboFormasDeEnvio();

    $t_params->{'combo_tipo_documento'}    = $comboDeTipoDeDoc; 
    $t_params->{'combo_tipo_materiales'}   = $combo_tipo_materiales; 
    $t_params->{'combo_formas_envio'}      = $combo_formas_envio;
    $t_params->{'page_sub_title'}          = C4::AR::Filtros::i18n("Agregar Proveedor");

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
