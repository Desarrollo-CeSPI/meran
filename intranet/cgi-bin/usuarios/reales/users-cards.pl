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
use C4::AR::Busquedas;
 
my $input = new CGI;
 
my $op=$input->param('op');

if ($op eq 'pdf') {

    my $obj;
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
    $obj->{'regularidad'}       = $input->param('regularidad');
    $obj->{'to_alta_persona'}   = $input->param('to_alta_persona');
    $obj->{'from_alta_persona'} = $input->param('from_alta_persona');
    $obj->{'export'}            = 1;

    my ($cantidad,$results)=C4::AR::Usuarios::BornameSearchForCard($obj);

    C4::AR::Utilidades::printARRAY($results);
     #HAY QUE GENERAR EL PDF CON LOS CARNETS
    C4::AR::PdfGenerator::batchCardsGenerator($cantidad,$results);

}