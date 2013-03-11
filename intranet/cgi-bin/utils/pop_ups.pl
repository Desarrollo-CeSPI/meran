#!/usr/bin/perl

use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Context;
use CGI;

my $query = new CGI;

my $obj=$query->param('obj');
$obj=C4::AR::Utilidades::from_json_ISO($obj);

my $pop_up = $obj->{'pop_up_template'};
my $pop_up_template = '';

if($pop_up eq 'buscar_usuario'){
    $pop_up_template = "buscarUsuario.inc";
}

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name => "/includes/popups/".$pop_up_template,
                                    query => $query,
                                    type => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'undefined'},
                                    debug => 1,
            });




C4::AR::Auth::output_html_with_http_headers($template, $t_params,$session);