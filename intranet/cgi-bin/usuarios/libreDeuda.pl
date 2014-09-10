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

require Exporter;

use strict;
use JSON;
use CGI;
use C4::AR::Auth;
use C4::AR::PdfGenerator;


my $input = new CGI;
my ($template, $session, $t_params);

($template, $session, $t_params)        = get_template_and_user({
                        template_name   => "usuarios/reales/libre_deuda.tmpl",
                        query           => $input,
                        type            => "intranet",
                        authnotrequired => 0,
                        flagsrequired   => {  ui            => 'ANY', 
                                            tipo_documento  => 'ANY', 
                                            accion          => 'CONSULTA', 
                                            entorno         => 'undefined'},
                        debug           => 1,
 });

my $nro_socio   = $input->param('nro_socio');
my $msg_object  = C4::AR::Usuarios::_verificarLibreDeuda($nro_socio);

if (!($msg_object->{'error'})){

    # aca armamos toda la data para pasarla a un html
    my $socio                       = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
    
    #si levanta un socio valido
    if($socio){

        my ($cuerpo_mensaje, $escudo, $escudoUI, $fecha, $titulo, $biblio) = C4::AR::PdfGenerator::libreDeuda($socio);
        $t_params->{'cuerpo_mensaje'}  = @$cuerpo_mensaje[0];

	    $t_params->{'escudo'}  = $escudo;
	    $t_params->{'escudoUI'}  = $escudoUI;
	    $t_params->{'fecha'}  = $fecha;
        $t_params->{'titulo'} = $titulo; 
        $t_params->{'biblio'} = $biblio;
                   
        $t_params->{'print_format'}     = C4::AR::Preferencias::getValorPreferencia('libre_deuda_fill_a4');

        my $out         = C4::AR::Auth::get_html_content($template, $t_params, $session);
        
        C4::AR::Debug::debug($out);

        my $filename    = C4::AR::PdfGenerator::pdfFromHTML($out);
        print C4::AR::PdfGenerator::pdfHeader();
# 
        C4::AR::PdfGenerator::printPDF($filename);

	}else{
	    #redirigimos 
	    C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/mainpage.pl?token='.$session->param('token'));
	}
	
} else {
    my $infoOperacionJSON = to_json $msg_object;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}