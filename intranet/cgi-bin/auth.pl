#!/usr/bin/perl
#
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.
#

use strict;

use C4::AR::Auth;
use CGI;
use CGI::Session;

my $cgi = new CGI;

my ($template, $t_params)   = C4::Output::gettemplate("auth.tmpl", 'intranet');

my $session                 = CGI::Session->load() || CGI::Session->new();

if ($session->param('codMsg')){
  $t_params->{'mensaje'}    = C4::AR::Mensajes::getMensaje($session->param('codMsg'),'intranet');
}

my ($session) = C4::AR::Auth::inicializarAuth($t_params);

$t_params->{'sessionClose'} = $cgi->param('sessionClose') || 0;

if ($t_params->{'sessionClose'}){
  $t_params->{'mensaje'}    = C4::AR::Mensajes::getMensaje('U358','intranet');
}

$t_params->{'loginAttempt'} = $cgi->param('loginAttempt') || 0;

$t_params->{'mostrar_captcha'} = $cgi->param('mostrarCaptcha') || 0;

if ($t_params->{'loginAttempt'} & !($t_params->{'mostrar_captcha'}) ){
  $t_params->{'mensaje'}    = C4::AR::Mensajes::getMensaje('U357','intranet');
}

$t_params->{'re_captcha_public_key'} = C4::AR::Preferencias::getValorPreferencia('re_captcha_public_key');

if (! $t_params->{'re_captcha_public_key'}){
	#Si se encuentra la key de captcha configurada no se puede mostrar el captcha
	$t_params->{'mostrar_captcha'} = 0;
	}

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
