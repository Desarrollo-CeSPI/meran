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
use CGI;
use C4::AR::Auth;

use C4::AR::Utilidades;
use C4::AR::ImportacionIsoMARC;
use C4::AR::UploadFile;

my $input = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name => "/herramientas/importacion/subirNuevaImportacion.tmpl",
                                    query => $input,
                                    type => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY',
                                                        tipo_documento => 'ANY',
                                                        accion => 'ALTA',
                                                        entorno => 'undefined'},
                                    debug => 1,
            });

    my %parametros;
    $parametros{'onChange'} = 'cambiarFormato();';
    $t_params->{'combo_formatos'}          = C4::AR::Utilidades::generarComboFormatosImportacion(\%parametros);

    my %parametros;
    $t_params->{'combo_esquemas'}          = C4::AR::Utilidades::generarComboEsquemasImportacion(\%parametros);

if ($input->param('upfile')){
    #ES UNA NUEVA IMPORTACION
    my %parametros;
    $parametros{'titulo'}               = $input->param('titulo');
    $parametros{'file_name'}            = $input->param('upfile');
    $parametros{'file_data'}            = $input->upload('upfile');
    $parametros{'comentario'}           = $input->param('comentario');
    $parametros{'xls_first'}            = $input->param('xls_first');
    $parametros{'esquemaImportacion'}   = $input->param('esquemaImportacion');
    $parametros{'formatoImportacion'}   = $input->param('formatoImportacion');
    C4::AR::Debug::debug("antes de subir - Nuevo esquema?? ".$input->param('nombreEsquema')." o usamos uno existente: ". $input->param('esquemaImportacion'));
    C4::AR::Debug::debug("XLS?? FIRST ".$input->param('xls_first'));
    #Si el esquema es nuevo hay que crearlo vacio al menos!
    if($input->param('nuevo_esquema')){
       $parametros{'nombreEsquema'}     = $input->param('nombreEsquema');
       $parametros{'nuevo_esquema'}     = $input->param('nuevo_esquema');
       $parametros{'esquemaImportacion'}= -1;
        }
    if (!$input->{'nombreEsquema'}){
        #FIXME hasta que el pelado se decida a arreglarme el combo
        $parametros{'esquemaImportacion'}= $input->param('esquemaImportacion');
        }
    my ($msg_object) = C4::AR::UploadFile::uploadImport(\%parametros);

    print $session->header();
    print $msg_object->{'messages'}[0]->{'message'};
}else{
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}