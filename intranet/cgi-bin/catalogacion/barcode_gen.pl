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
use C4::AR::Nivel3;
use C4::AR::PdfGenerator;


my $input = new CGI;

# my $obj= $input->param('obj');
# $obj= C4::AR::Utilidades::from_json_ISO($obj);


my ($template, $session, $t_params) =  get_template_and_user ({
			template_name	=> 'reports/usuariosResult.tmpl',
			query		=> $input,
			type		=> "intranet",
			authnotrequired	=> 0,
			flagsrequired	=> {    ui => 'ANY', 
                                    tipo_documento => 'ANY', 
                                    accion => 'CONSULTA', 
                                    entorno => 'undefined'},
    });


my $id = $input->param('id');
my @arreglo = ();


if ($id){

      my $nivel3          = C4::AR::Nivel3::getNivel3FromId3($id);
      push (@arreglo, $nivel3);

} else {
    
      my $hash=$input->{'param'};

      my @keys=keys %$hash;
      my $array_ref;

      if ($hash->{'etiquetas'}){
         
           $array_ref = \@keys;
      
       } else {

          my $key_string= @keys[0];       
          $array_ref= $hash->{$key_string};
       }

      foreach my $id3 (@$array_ref) {
          if ($id3 ne "etiquetas"){
                my $nivel3 = C4::AR::Nivel3::getNivel3FromId3($id3);
                push (@arreglo, $nivel3);
          }
      }

 }
 
C4::AR::PdfGenerator::batchBookLabelGenerator(scalar(@arreglo),\@arreglo);