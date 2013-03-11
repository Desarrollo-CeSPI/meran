#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::AR::Utilidades;
use JSON;

my $input           = new CGI;
my $authnotrequired = 0;

my $obj             = $input->param('obj');
$obj                = C4::AR::Utilidades::from_json_ISO($obj);
my $tipoAccion      = $obj->{'tipoAccion'};

if($tipoAccion eq "MOSTRAR_AGREGAR_SERVIDOR"){    
    my ($template, $session, $t_params) = get_template_and_user({
      template_name   => "admin/global/agregar_sys_externos_meran.tmpl",
      query           => $input,
      type            => "intranet",
      authnotrequired => 0,
      flagsrequired   => { ui => 'ANY', tipo_documento => 'ANY', accion => 'CONSULTA', entorno => 'undefined'},
      debug           => 1,
  });

    $t_params->{'combo_ui'} = C4::AR::Utilidades::generarComboUI();
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} elsif ($tipoAccion eq "ELIMINAR_SERVIDOR"){
  
    my ($template, $session, $t_params)  = get_template_and_user({  
                template_name   => "admin/global/sys_externos_meran.tmpl",
                query           => $input,
                type            => "intranet",
                authnotrequired => 0,
                flagsrequired   => {    ui             => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion         => 'CONSULTA', 
                                        entorno        => 'undefined'},
                debug           => 1,
    });

    my $sys_externo_meran = C4::AR::Preferencias::deleteSysExternoMeran($obj->{'id_server'});


    my $sys_externos_meran = C4::AR::Preferencias::getSysExternosMeran();
    $t_params->{'sys_externos_meran'} = $sys_externos_meran;
    $t_params->{'sys_externos_meran_count'} = scalar(@$sys_externos_meran);
    $t_params->{'page_sub_title'} = C4::AR::Filtros::i18n("Servidores externos de MERAN");
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}