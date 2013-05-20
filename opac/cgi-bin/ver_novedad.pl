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
use CGI;
use C4::AR::Auth;         # checkauth, getnro_socio.

use C4::AR::Novedades;

my $query = new CGI;

my $input = $query;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name   => "opac-main.tmpl",
                                    query           => $query,
                                    type            => "opac",
                                    authnotrequired => 1,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
             });


eval{
	my $id_novedad                      = $input->param('id');
	my $novedad                         = C4::AR::Novedades::getNovedad($id_novedad);
	my ($imagenes_novedad,$cant)        = C4::AR::Novedades::getImagenesNovedad($id_novedad);
	
	#solo si hay imagenes para esa novedad
	if($cant){
	
	    $t_params->{'imagenes_hash'}    = $imagenes_novedad;
	
	}
	my @linksTodos = split("\ ", $novedad->getLinks());
	
	$t_params->{'cant'}                 = $cant;
	$t_params->{'novedad'}              = $novedad;
	$t_params->{'links'}                = \@linksTodos;
	$t_params->{'cant_links'}           = @linksTodos;
	$t_params->{'partial_template'}     = "ver_novedad.inc";
	
};

if ($@){
    C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/opac-main.pl?token='.$session->param('token'));	
}

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);