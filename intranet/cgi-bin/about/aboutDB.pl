#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use C4::AR::Preferencias;

my $input               = new CGI;
my $authnotrequired     = 0;
my $obj                 = $input->param('obj');
$obj                    = C4::AR::Utilidades::from_json_ISO($obj);
my $tipoAccion          = $obj->{'tipoAccion'}||"";

if($tipoAccion eq "EDIT_ABOUT"){

    # se muestra el template para la edicion
    my ($template, $session, $t_params)  = get_template_and_user({  
                        template_name   => "/preferencias/edit_about.tmpl",
                        query           => $input,
                        type            => "intranet",
                        authnotrequired => 0,
                        flagsrequired   => {    ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICAR', 
                                                entorno => 'usuarios'},
                        debug           => 1,
                    });
                    
     my $info_about_hash = C4::AR::Preferencias::getInfoAbout();  
     $t_params->{'info_about'} = $info_about_hash;
                    
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
