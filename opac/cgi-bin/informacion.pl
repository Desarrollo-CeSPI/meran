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
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Context;
use CGI;
use CGI::Session;

my $query = new CGI;

my ($template, $t_params)= C4::Output::gettemplate("opac-main.tmpl", 'opac');

my $session = CGI::Session->new();
##En este pl, se muestran todos los mensajes al usuario con respecto a la falta de permisos,
#sin destruir la sesion del usuario, permitiendo asi que navegue por donde tiene permisos
$t_params->{'mensaje'}= C4::AR::Mensajes::getMensaje($session->param('codMsg'),'OPAC',[]);
$t_params->{'partial_template'} = "informacion.inc";
$t_params->{'noAjaxRequests'}   = 1;
&C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);