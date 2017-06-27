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
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;
use MARC::Record;
use C4::AR::Utilidades;

my $tipoDoc = $ARGV[0];
my @filtros;
push (@filtros, (template  => {eq  => $tipoDoc}) );
my $niveles2 = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2( query => \@filtros );

open (FILE, '>./registros_'.$tipoDoc.'.csv');

    print FILE '"041^h - Código de idioma de la versión original",';
    print FILE '"100^a - Nombre personal",';
    print FILE '"245^a - Título",';
    print FILE '"245^b - Resto del título",'; 
    print FILE '"260^c - Fecha de publicación, distribución, etc.",'; 
    print FILE '"300^a - Extensión",';
    print FILE '"500^a - Nota general",'; 
    print FILE '"502^a - Nota de tesis",';
    print FILE '"505^a - Resumen",';
    print FILE '"650^a - Término preferente (R)",';
    print FILE '"653^a - Término no controlado (R)",';
    print FILE '"700^a - Nombre personal (R) (700^e - Término de relación) ",';
    print FILE '"910^a - Tipo de documento",';
    print FILE '"Link al registro",';
    print FILE '"Link al documento electrónico"
    ';

foreach my $nivel2 (@$niveles2 ){
  if ($nivel2->getId1() && $nivel2->nivel1){
    my $marc_record_n1 = MARC::Record->new_from_usmarc($nivel2->nivel1->getMarcRecord());
    my $marc_record_n2 = MARC::Record->new_from_usmarc($nivel2->getMarcRecord());

    print FILE '"'.$nivel2->getIdiomaObject()->getDescription().'",';
    print FILE '"'.$nivel2->nivel1->getAutor().'",';
    print FILE '"'.$nivel2->nivel1->getTitulo().'",';
    print FILE '"'.$nivel2->nivel1->getRestoDelTitulo().'",';
    print FILE '"'.$nivel2->getAnio_publicacion().'",';
    print FILE '"'.$nivel2->getDescripcionFisica().'",';
    print FILE '"'.$nivel2->getNotaGeneral().'",';
    print FILE '"'.$marc_record_n2->subfield("502","a").'",';
    print FILE '"'.$marc_record_n2->subfield("505","a").'",';
    print FILE '"'.join('||',  map { $_->getNombre() }  $nivel2->nivel1->getTemas("650","a")).'",';
    print FILE '"'.join('||', $marc_record_n1->subfield("653","a")).'",';
    print FILE '"'.join('||', $nivel2->nivel1->getAutoresSecundarios()).'",';
    print FILE '"'.$nivel2->nivel1->getNombreTipoDoc().'",';
    print FILE '"http://catalogo.info.unlp.edu.ar/meran/opac-detail.pl?id1='.$nivel2->nivel1->getId1().'",';
    my ($cant_docs,$e_docs) = C4::AR::Nivel3::getListaDeDocs($nivel2->getId2());  
    if ($cant_docs > 0){
      print FILE '"http://catalogo.info.unlp.edu.ar/meran/getDocument.pl?id='.$e_docs->[0]->getId().'"
      ';
    } else {
      print FILE '""
      ';
    }
}
}
close (FILE);
1;