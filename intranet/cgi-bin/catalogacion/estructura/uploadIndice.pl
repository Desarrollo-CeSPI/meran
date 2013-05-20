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
use CGI;
use C4::Context;
use C4::AR::UploadFile;
use C4::AR::Auth;
use JSON;
use strict;
use CGI::Carp qw(fatalsToBrowser);

my $query       = new CGI;
my $id2         = $query->param('id2');
my $file_name   = $query->param('fileToUpload');
my $file_data   = $query->upload('fileToUpload');
my $name        = $file_name;
my $authnotrequired = 0;

C4::AR::Debug::debug("INDICE PARA GRUPO:                 ".$id2);
C4::AR::Debug::debug("INDICE FILENAME:                 ".$file_name);
C4::AR::Debug::debug("INDICE FILEDATA:                 ".$file_data);

my ($template, $session, $t_params) = get_template_and_user({
                            template_name   => ('catalogacion/estructura/detalle.tmpl'),
                            query           => $query,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {    ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'},
                        });


my ($msg) = C4::AR::UploadFile::uploadIndiceFile($file_name,$name,$id2,$file_data);

print $session->header();
print $msg;