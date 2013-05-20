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
use C4::AR::Prestamos;

my $input = new CGI;

my $obj = $input->Vars;

my ($template, $session, $t_params);
my $prestamos_array_ref;

($template, $session, $t_params) = C4::AR::Auth::get_template_and_user({
                                    template_name   => "admin/circulacion/prestamos_vencidos.tmpl",
                                    query           => $input,
                                    type            => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'ALTA', 
                                                        entorno         => 'undefined'},
});

$prestamos_array_ref   = C4::AR::Prestamos::getAllPrestamosVencidos();

$t_params->{'ini'}  = 0;


if(C4::AR::Preferencias::getValorPreferencia('enableMailPrestVencidos')){

    $t_params->{'mensaje'}  = 'Se enviar&aacute;n los mails de pr&eacute;stamos vencidos a la brevedad';

}




$t_params->{'prestamos'}  = $prestamos_array_ref;
$t_params->{'cantidad'}   = $prestamos_array_ref?scalar(@$prestamos_array_ref):0;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);