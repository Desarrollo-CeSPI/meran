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

use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;
use MARC::Record;
use MARC::File::JSON;
use JSON;

#use MongoDB;
use Data::Dumper;

my $filename = 'meran_json.txt';
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";


#my $connection = MongoDB::Connection->new;

#my $db = $connection->meran;
#$db->drop;

#my $col = $db->get_collection('n1');

my $n1s = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1(); 

foreach my $n1 (@$n1s){

    my $marc_record = $n1->getMarcRecord();
    $marc_record = MARC::Record->new_from_usmarc($marc_record);
    my $rj = $marc_record->as_json;
    my $json = JSON->new->allow_nonref;
    my  $record_json = $json->decode( $rj );
    my @ediciones=();
    my $grupos = $n1->getGrupos();
    foreach my $n2 (@$grupos){
      my @items=();
      my $ejemplares = $n2->getEjemplares();
      foreach my $n3 (@$ejemplares){
        push @items, $json->decode(MARC::Record->new_from_usmarc($n3->getMarcRecord())->as_json);
      }
      my  $edition_json = $json->decode(MARC::Record->new_from_usmarc($n2->getMarcRecord())->as_json);
      $edition_json->{'items'} = \@items;
      push @ediciones, $edition_json;
    }
    $record_json->{'editions'} = \@ediciones;
    print  $fh $json->encode($record_json)."\n";
}
close $fh;
1;