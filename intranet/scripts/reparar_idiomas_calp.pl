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

use C4::AR::Nivel2;
use C4::Context;
use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;
use Switch;
#Ticket #9643

my $grupos = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2();
my $hash = ();

foreach my $nivel2 (@$grupos){
    my $marc_record2 = $nivel2->getMarcRecordObject();
    my @campos = $marc_record2->field('041');
    my $update=0;
    foreach my $campo (@campos){
        my $idioma = $campo->subfield('a');

        print getIdioma($idioma)."\n";

        if (($idioma)&&(getIdioma($idioma))){
            $campo->update( 'a' => getIdioma($idioma));
            $update=1;
        }

        if($hash->{$idioma}){
            $hash->{$idioma}++;
        }else{
            $hash->{$idioma}=1;
        }
    }
    if ($update){
        $nivel2->setMarcRecord($marc_record2->as_usmarc);
        $nivel2->save();
        print $marc_record2->as_formatted." \n";
    }
}

    for $c4 ( keys %$hash ) {
                print "Idioma $c4 = ".$hash->{$c4}."\n";
    }









sub getIdioma {
    my ($idioma)=@_;

    switch (C4::AR::Utilidades::trim($idioma)) {
        case 'ref_idioma@iu'  {return 'ref_idioma@it';}
        case 'pt'  {return 'ref_idioma@pt';}
        case 'it'   {return 'ref_idioma@it';}
        case 'es'  {return 'ref_idioma@es';}
        case 'ref_idioma@as'  {return 'ref_idioma@es';}
        case 'ref_idioma@hy'  {return 'ref_idioma@en';}
        case 'ref_idioma@af'  {return 'ref_idioma@fr';}
        case 'en'  {return 'ref_idioma@en';}
        case 'fr'  {return 'ref_idioma@fr';}
        case 'ref_idioma@bi'  {return 'ref_idioma@la';}        
    }
    return "";
}


1;