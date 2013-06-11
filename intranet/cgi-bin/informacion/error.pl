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
use C4::AR::Preferencias;
use CGI;
use CGI::Session;

#eval{
	my $query = new CGI;

	my ($template, $t_params)   = C4::Output::gettemplate("informacion/error.tmpl", 'intranet');

	my $session                 = CGI::Session->load();
	my $message_error           = "404";

	if ($ENV{'REDIRECT_STATUS'}  eq "404") {
	    $message_error = C4::AR::Preferencias::getValorPreferencia('404_error_message') || $message_error;
	} elsif ($ENV{'REDIRECT_STATUS'}  eq "500") {
	    $message_error = C4::AR::Preferencias::getValorPreferencia('500_error_message') || $message_error;
	}  

	$t_params->{'message_error'}      = $message_error;

	C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
# } or do{	
# 	my $session                 = CGI::Session->load();
# 	my $message_error           = "404";
# 	my ($template, $t_params)   = C4::Output::gettemplate("informacion/error_html.tmpl", 'intranet');

# 	C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
# }	