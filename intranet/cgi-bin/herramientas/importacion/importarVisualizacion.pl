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
use C4::AR::ImportacionXML;

my $input = new CGI;

my %params_combo;

my $obj     = $input->Vars; 

my $accion  = $obj->{'tipoAccion'} || undef;

my $context = $obj->{'context'};

my $tmpl;

if ($context eq "opac"){
    $tmpl = "catalogacion/visualizacionOPAC/visualizacionOpac.tmpl";
}else{
    $tmpl = "catalogacion/visualizacionINTRA/visualizacionIntra.tmpl";
}


my ($template, $session, $t_params) = get_template_and_user({
                                    template_name   => $tmpl,
                                    query           => $input,
                                    type            => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired   => {  ui    => 'ANY', 
                                                        accion  => 'CONSULTA', 
                                                        entorno => 'undefined'},
                                    debug => 1,
                });

if ($accion eq "IMPORT"){

    my $msg_object  = C4::AR::ImportacionXML::importarVisualizacion($obj, $input->upload('fileImported'), $context);

    my $codMsg      = C4::AR::Mensajes::getFirstCodeError($msg_object);
    
    $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');

    if (C4::AR::Mensajes::hayError($msg_object)){
        $t_params->{'mensaje_class'} = "alert-error";
    }else{
        $t_params->{'mensaje_class'} = "alert-success";
    }
}

$params_combo{'onChange'}                       = 'eleccionDeEjemplar()';
$params_combo{'default'}                        = 'SIN SELECCIONAR';
$t_params->{'combo_perfiles'}                   = C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo);
$t_params->{'combo_ejemplares'}                 = C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo);
$t_params->{'page_sub_title'}                   = C4::AR::Filtros::i18n("Catalogaci&oacute;n - Visualizaci&oacute;n del OPAC");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);