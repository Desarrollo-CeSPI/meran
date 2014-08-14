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
use C4::AR::PdfGenerator;
use C4::AR::XLSGenerator;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                            template_name => "usuarios/reales/users-cardsResult.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'undefined'},
                            debug => 1,
                });

my $op=$input->param('op');
my $obj;
if ($op) {#POST
    $obj->{'orden'}             = $input->param('orden')||'apellido';
    $obj->{'apellido1'}         = $input->param('surname1');
    $obj->{'apellido2'}         = $input->param('surname2');
    $obj->{'legajo1'}           = $input->param('legajo1');
    $obj->{'legajo2'}           = $input->param('legajo2');
    $obj->{'categoria_socio'}   = $input->param('categoria_socio');
    $obj->{'from_last_login'}   = $input->param('from_last_login');
    $obj->{'to_last_login'}     = $input->param('to_last_login');
    $obj->{'to_alta'}           = $input->param('to_alta');
    $obj->{'from_alta'}         = $input->param('from_alta');
    $obj->{'from_alta'}         = $input->param('from_alta');
    $obj->{'regular'}           = $input->param('regular');
    $obj->{'dni'}               = $input->param('dni');
    $obj->{'ui'}                = $input->param('ui');
    $obj->{'op'}                = $input->param('op');
    $obj->{'regularidad'}       = $input->param('regularidad');
    $obj->{'to_alta_persona'}   = $input->param('to_alta_persona');
    $obj->{'from_alta_persona'} = $input->param('from_alta_persona');
    $obj->{'export'}            = 1;

}else { #AJAX
    $obj=C4::AR::Utilidades::from_json_ISO($input->param('obj'));
}

if (($obj->{'op'} ne 'PDF_REPORT') &&($obj->{'op'} ne 'XLS_REPORT')) {

    $obj->{'ini'} = $obj->{'ini'} || 1;
    my $ini=$obj->{'ini'};
    my $inicial=$obj->{'inicial'} || 0;
    my $funcion = $obj->{'funcion'};

    $obj->{'orden'}=$obj->{'orden'}||'apellido';
    $obj->{'apellido1'}=$obj->{'surname1'};
    $obj->{'apellido2'}=$obj->{'surname2'};


    my ($ini,$pageNumber,$cantR)=C4::AR::Utilidades::InitPaginador($ini);

    $obj->{'cantR'} = $cantR;
    $obj->{'pageNumber'} = $pageNumber;
    $obj->{'ini'}=$ini;

    my ($cantidad,$results)=C4::AR::Usuarios::BornameSearchForCard($obj);


    $t_params->{'paginador'}= C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);

    #Se realiza la busqueda si al algun campo no vacio
    $t_params->{'RESULTSLOOP'}=$results;
    $t_params->{'cantidad'}=$cantidad;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} 
else{
  
    $obj->{'export'} = 1;
    $obj->{'apellido1'}=$obj->{'surname1'};
    $obj->{'apellido2'}=$obj->{'surname2'};

    my ($cantidad,$results)=C4::AR::Usuarios::BornameSearchForCard($obj);

    #Se realiza la busqueda si al algun campo no vacio
    $t_params->{'RESULTSLOOP'}=$results;
    $t_params->{'cantidad'}=$cantidad;

    if ($obj->{'op'} eq 'XLS_REPORT'){
        #XLS
        print C4::AR::XLSGenerator::xlsHeader(); 
        C4::AR::XLSGenerator::exportarReporteUsuarios($results);
    }
    elsif($obj->{'op'} eq 'PDF_REPORT'){
        #PDF
        my $out                     = C4::AR::Auth::get_html_content($template, $t_params);
        my $filename                = C4::AR::PdfGenerator::pdfFromHTML($out, $obj);

        print C4::AR::PdfGenerator::pdfHeader(); 
        C4::AR::PdfGenerator::printPDF($filename);
    }

}