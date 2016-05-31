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

use lib qw(/usr/local/share/meran/dev/intranet/modules/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl5/);

use C4::Context;
use C4::Modelo::CatRegistroMarcN3;
use C4::Modelo::CatRegistroMarcN3::Manager;

my @filtros;
my $nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( query => \@filtros ); 

foreach my $nivel3 (@$nivel3_array_ref){

    my $marc_record = MARC::Record->new_from_usmarc($nivel3->getMarcRecord());
    my $ref1         = $marc_record->subfield("995","c");
    $ref1 			=~ s/GL/BG/g;
    my $ref2         = $marc_record->subfield("995","d");
    $ref2 			=~ s/GL/BG/g;
    my $bar         = $marc_record->subfield("995","f");
    $bar 			=~ s/GL/BG/g;


    $marc_record->field('995')->update( "c" => $ref1);
    $marc_record->field('995')->update( "d" => $ref2);
    $marc_record->field('995')->update( "f" => $bar);
    $nivel3->setCodigoBarra($bar);
    $nivel3->setMarcRecord($marc_record->as_usmarc());
    $nivel3->save();
    #print $marc_record->as_usmarc()."\n";

}

1;