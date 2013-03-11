#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::Output;

my $input = new CGI;
my $input = new CGI;
my $adding = $input->param('form_action') || 0;

my ($template, $session, $t_params) = get_template_and_user({
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

$t_params->{'mensaje'} = '';

if ($adding) {
      my $url = $input->param('url_server');
      my $id_ui = $input->param('name_ui');
        
      my $info = C4::AR::Preferencias::addSysExternoMeran($url, $id_ui);
      $t_params->{'mensaje'} = $info->{'messages'}[0]->{'message'};
} 

my $sys_externos_meran = C4::AR::Preferencias::getSysExternosMeran();
$t_params->{'sys_externos_meran'} = $sys_externos_meran;
$t_params->{'sys_externos_meran_count'} = scalar(@$sys_externos_meran);
$t_params->{'page_sub_title'} = C4::AR::Filtros::i18n("Servidores externos de MERAN");
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);