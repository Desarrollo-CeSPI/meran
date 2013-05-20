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
use CGI;

my $query = new CGI;
my $params = $query->Vars;

my ($template, $t_params)= C4::Output::gettemplate("opac-main.tmpl", 'opac',1);

$t_params->{'type'}='opac';

my $key = $t_params->{'key'} = $params->{"key"};

my $recaptcha_challenge_field = $t_params->{'recaptcha_challenge_field'} = $query->param("key");
my $recaptcha_response_field = $t_params->{'recaptcha_response_field'} = $query->param("key");

my ($session) = C4::AR::Auth::inicializarAuth($t_params);

my ($validLink) = C4::AR::Auth::checkRecoverLink($key);

if ($validLink){
    if ($query->param("new_password1") && $query->param("new_password2")){
    	$t_params->{'message'} = C4::AR::Auth::changePasswordFromRecover($params);
        $t_params->{'partial_template'}= "_message.inc";
    }else{
	   $t_params->{'partial_template'}     = "opac-change-password-recovery.inc";
    }
}else{
    $t_params->{'partial_template'}= "_message.inc";
    $t_params->{'message'} = C4::AR::Mensajes::getMensaje('U602','opac');;
	
}
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);