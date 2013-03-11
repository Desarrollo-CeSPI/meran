#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::Output;

my $input = new CGI;
my $input = new CGI;
my $editing = $input->param('form_action') || 0;
my $template_name;

if (!$editing) {
      $template_name = "admin/global/editar_sys_externo_meran.tmpl";
} else {
      $template_name = "admin/global/sys_externos_meran.tmpl";
}

my ($template, $session, $t_params) = get_template_and_user({
                        template_name   => $template_name,
                        query           => $input,
                        type            => "intranet",
                        authnotrequired => 0,
                        flagsrequired   => {    ui             => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion         => 'CONSULTA', 
                                                entorno        => 'undefined'},
                        debug           => 1,
          });

$t_params->{'mensaje'} = '';

if ($editing) {
      my $id = $input->param('id');
      my $url = $input->param('url_server');
      my $id_ui = $input->param('name_ui');      
      my $info = C4::AR::Preferencias::editSysExternoMeran($id, $url, $id_ui);
      $t_params->{'mensaje'} = $info->{'messages'}[0]->{'message'};
      my $sys_externos_meran = C4::AR::Preferencias::getSysExternosMeran();
      $t_params->{'sys_externos_meran'} = $sys_externos_meran;
      $t_params->{'sys_externos_meran_count'} = scalar(@$sys_externos_meran);
} else {
      my $sys_externo_meran = C4::AR::Preferencias::getSysExternoMeran($input->param('id'));
      my %options_hash;
      $options_hash{'default'} = $sys_externo_meran->getId_ui;
      $t_params->{'combo_ui'} = C4::AR::Utilidades::generarComboUI(\%options_hash);
      $t_params->{'sys_externo_meran'} = $sys_externo_meran;
}

$t_params->{'page_sub_title'} = C4::AR::Filtros::i18n("Servidores externos de MERAN::Editar");
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);