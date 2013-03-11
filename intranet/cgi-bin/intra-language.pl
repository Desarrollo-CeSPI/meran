#!/usr/bin/perl
use strict;
require Exporter;
use CGI;
use C4::AR::Auth;       # get_template_and_user

my $input = new CGI;

C4::AR::Debug::debug("intra-language.pl \n");
my $session = CGI::Session->load();
my $referer = $ENV{'HTTP_REFERER'};

$session->param('usr_locale', $input->param('lang_server'));
my $socio = C4::AR::Auth::getSessionNroSocio();

if ($socio){
    $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($socio) || C4::Modelo::UsrSocio->new();
    $socio->setLocale($input->param('lang_server'));
    $session->param('usr_locale', $socio->getLocale());
}

#regreso a la pagina en la que estaba
C4::AR::Auth::redirectTo($referer);



