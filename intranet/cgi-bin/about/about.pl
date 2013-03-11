#!/usr/bin/perl

use strict;
require Exporter;
use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Context;
use CGI;

my $input = new CGI;
my $texto = $input->param('about');


my ($template, $session, $t_params) = get_template_and_user({
                 template_name      => "about/about.tmpl",
			     query              => $input,
			     type               => "intranet",
			     authnotrequired    => 0,
			     flagsrequired      => { ui => 'ANY', tipo_documento => 'ANY', accion => 'CONSULTA', entorno => 'undefined'},
			     debug              => 1,
			});
			
# si esta editando, se guarda en la base pref_about
if($texto){
    # evita XSS
    if($texto =~ m/script/){
        print "Se encontró la palabra: script.\n";
    }else{
        my ($temp) = C4::AR::Preferencias::updateInfoAbout($texto);	
    }
}

# obtenemos lo guardado en la base de pref_about
my $info_about_hash = C4::AR::Preferencias::getInfoAbout();  

$t_params->{'info_about'}     = $info_about_hash;
$t_params->{'page_sub_title'} = C4::AR::Filtros::i18n("Acerca De MERAN");

C4::AR::Auth::output_html_with_http_headers($template, $t_params,$session);
