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

use C4::Modelo::CatRegistroMarcN3;
use C4::Modelo::CatRegistroMarcN3::Manager;
use MARC::Record;
use Switch;

sub getCodigoEstado{
my ($id) = @_;
# (1, 'Perdido', 'STATE005'),
# (2, 'Compartido', 'STATE001'),
# (3, 'Disponible', 'STATE002'),
# (4, 'Baja', 'STATE000'),
# (5, 'Ejemplar deteriorado', 'STATE003'),
# (6, 'En Encuadernacion', 'STATE004'),
# (7, 'En Etiquetado', 'STATE006'),
# (8, 'En Impresiones', 'STATE007'),
# (9, 'En procesos tecnicos', 'STATE008');


switch ($id) {
  case 1 { return "STATE005" }
  case 2 { return "STATE001" }
  case 3 { return "STATE002" }
  case 4 { return "STATE000" }
  case 5 { return "STATE003" }
  case 6 { return "STATE004" }
  case 7 { return "STATE006" }
  case 8 { return "STATE007" }
  case 9 { return "STATE008" }
}

return 0;
}

sub getCodigoDisponibilidad{
my ($id) = @_;

########## CODIGOS DE DISPONIBILIDAD #############
# 0 = Domiciliario      = CIRC0000
# 1 = Sala de lectura   = CIRC0001
##################################################


switch ($id) {
  case 0 { return "CIRC0000" }
  case 1 { return "CIRC0001" }

}

return 0;
}

my $nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(  ); 

foreach my $n3 (@$nivel3_array_ref){

   my $marc_record_base    = MARC::Record->new_from_usmarc($n3->getMarcRecord());
    # ACA HAY QUE OBTENER EL ESTADO (995,e), LA DISPONIBILIDAD (995,o) Y TRANFORMAR EL ID POR EL CÓDIGO

    my $estado_viejo= $marc_record_base->subfield('995',"e");
    my $id_estado = (split(/@/,$estado_viejo))[1];

    my $disp_vieja= $marc_record_base->subfield('995',"o");
    my $id_disp = (split(/@/,$disp_vieja))[1];

    if (getCodigoEstado($id_estado) ){
      $marc_record_base->field('995')->update( "e" => 'ref_estado@'.getCodigoEstado($id_estado) );
    }

    if (getCodigoDisponibilidad($id_disp) ){
    $marc_record_base->field('995')->update( "o" => 'ref_disponibilidad@'.getCodigoDisponibilidad($id_disp) );
    }

    $n3->setMarcRecord($marc_record_base->as_usmarc());
    $n3->save();
}

1;