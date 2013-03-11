#!/usr/bin/perl
use strict;
require Exporter;
use CGI;
use C4::AR::Auth;       # get_template_and_user

my $input = new CGI;

##Aca se controlo el cambio de idioma
my $session =   CGI::Session->load();
my $locale  =   $input->param('lang_server');

$session->param('usr_locale', $locale );


C4::AR::Auth::_init_i18n({ type => 'opac' });

my $referer = $ENV{'HTTP_REFERER'};
my %params = {};

my $nro_socio_logged = C4::AR::Auth::getSessionNroSocio();
my $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio_logged) || C4::Modelo::UsrSocio->new();

if ($nro_socio_logged){
    $socio->setLocale($locale);
    C4::AR::Debug::debug("USR_LOCALE DE SOCIO => ".$socio->getLocale);
}


#regreso a la pagina en la que estaba
C4::AR::Auth::redirectTo($referer);
