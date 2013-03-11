#!/usr/bin/perl
use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Prestamos;

my $input = new CGI;

my ($template, $session, $t_params) = C4::AR::Auth::get_template_and_user({
									template_name   => "admin/ver_revision.tmpl",
									query           => $input,
									type            => "intranet",
									authnotrequired => 0,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'ALTA', 
                                                        entorno         => 'undefined'},
});

my $obj=$input->param('obj');

$obj=C4::AR::Utilidades::from_json_ISO($obj);


my $revision   = C4::AR::Nivel2::getReview($obj->{'id_revision'});
$t_params->{'revision'}  = $revision;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
