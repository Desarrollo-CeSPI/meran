#!/usr/bin/perl
use strict;
use CGI;
use C4::AR::Auth;
use C4::AR::Utilidades;

my $input       = new CGI;
my $post_params = $input->Vars;
my $token       = $input->param("token");
my $socio       = undef;

my ($template, $session, $t_params) = get_template_and_user ({
                                template_name   => 'settings.tmpl',
                                query           => $input,
                                type            => "opac",
                                authnotrequired => 0,
                                flagsrequired   => {    ui              => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
                        });



if ( (C4::AR::Utilidades::validateString($post_params->{'language'})) && (C4::AR::Utilidades::validateString($post_params->{'email'})) ){
    $socio = C4::AR::Usuarios::updateUserProfile($post_params);
    C4::AR::Auth::updateLoggedUserTemplateParams($session,$t_params,$socio);
    C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix()."/settings.pl?token=".$token);
}

$t_params->{'languages'} = C4::AR::Filtros::getComboLang($session);

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
