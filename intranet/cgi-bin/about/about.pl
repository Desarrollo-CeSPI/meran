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

my $input = new CGI;
my $texto = $input->param('about');


my ($template, $session, $t_params) = get_template_and_user({
                 template_name      => "about/about.tmpl",
			     query              => $input,
			     type               => "intranet",
			     authnotrequired    => 0,
			     flagsrequired      => { ui => 'ANY', tipo_documento => 'ANY', accion => 'CONSULTA', entorno => 'undefined'},
			     debug              => 1,
			});
			
# si esta editando, se guarda en la base pref_about
if($texto){
    # evita XSS
    if($texto =~ m/script/){
        print "Se encontró la palabra: script.\n";
    }else{
        my ($temp) = C4::AR::Preferencias::updateInfoAbout($texto);	
    }
}

# obtenemos lo guardado en la base de pref_about
my $info_about_hash = C4::AR::Preferencias::getInfoAbout();  

$t_params->{'info_about'}     = $info_about_hash;
$t_params->{'page_sub_title'} = C4::AR::Filtros::i18n("Acerca De MERAN");

C4::AR::Auth::output_html_with_http_headers($template, $t_params,$session);