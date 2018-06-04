#!/usr/bin/perl

use C4::AR::Nivel3;
use C4::Context;
use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;
use C4::Modelo::CatRegistroMarcN3;
use C4::Modelo::CatRegistroMarcN3::Manager;

# REPORTE
# Listado con todos los materiales de la biblioteca
# Tendría que incluir: título, autores, editorial, año de edición, ejemplares disponibles, indicación de si es papel y/o electrónico.
#Campos requeridos:
#245$a Título
#245$b Resto del título
#245$h Soporte
#100$a Autor
#700$a Autor secundario 700$e Función
#250$a Edición
#260$a Lugar/edit/fecha
#505$g Volumen
#505$t Tomo
#910$a Tipo de Documento
#995$f Inventario
#995$t Signatura
#995$o Disponibilidad
#995$e Estado
#995^m - Fecha de acceso
#900$g Responsable carga
#583^a - Nota de Acción
#583^c - Fecha de la acción
#583^k - Responsable de la acción


my @head=(
    'Título',
    'Resto del título',
    'Soporte',
    'Autor',
    'Autor secundario/Función',
    'Edición',
    'Lugar/edit/fecha',
    'Volumen',
    'Descripción',
    'Tipo de Documento',
    'Inventario',
    'Disponibilidad',
    'Estado',
    'Fecha de acceso',
    'Responsable de Carga',
    'Nota de la acción',
    'Fecha de la acción',
    'Responsable de la acción',
    );

print join('~', @head);
print "\n";

my $ejemplares = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
                                                                        sort_by => 'signatura ASC'
                                                                );


foreach my $nivel3 (@$ejemplares){

    my @ejemplar=();
    #URL
    my $marc_record1 = $nivel3->nivel1->getMarcRecordObject();
    my $marc_record2 = $nivel3->nivel2->getMarcRecordObject();
    my $marc_record3 = $nivel3->getMarcRecordObject();

    $ejemplar[0] = $nivel3->getSignatura();
    $ejemplar[1] = $marc_record1->subfield('080','a');


    
    $ejemplar[0] = $marc_record1->subfield('245','a');
    $ejemplar[1] = $marc_record1->subfield('245','b');

    my $ref_soporte = $nivel3->nivel2->getSoporte();
    my $refs      = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_soporte);
    my $soporte    = C4::Modelo::RefSoporte->getByPk($refs);
    if($soporte){
        $ejemplar[2] = $soporte->getDescription();
    }

    my $ref_autor= $marc_record1->subfield("100","a");
    my $ref      = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_autor);
    my $autor    = C4::Modelo::CatAutor->getByPk($ref);
    if($autor){
        $ejemplar[3] = $autor->getCompleto();
    }


    my @as       = $nivel3->nivel1->getAutoresSecundarios();
    $ejemplar[4] = join(' - ', @as);



    $ejemplar[5] = $marc_record2->subfield('250','a');
    
    my $ciudad = $nivel3->nivel2->getCiudadObject();
    if ($ciudad){
         $ejemplar[6] = $ciudad->getNombre();
    }

    if ($nivel3->nivel2->getEditor()) {
        if ($ejemplar[6]) {
            $ejemplar[6] = $ejemplar[6]." / ";
        }


        my $ref_editor = $nivel3->nivel2->getEditor();
        my $refe      = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_editor);
        my $editorial    = C4::Modelo::CatEditorial->getByPk($refe);
        if($editorial){
            $ejemplar[6] = $ejemplar[6].$editorial->getEditorial();
        }


    }
    
    if ($marc_record2->subfield('260','c')) {
        if ($ejemplar[6]) {
            $ejemplar[6] = $ejemplar[6]." / ";
        }
        $ejemplar[6] = $ejemplar[6].$marc_record2->subfield('260','c');
    }

    $ejemplar[7] = $marc_record2->subfield('505','g');
    $ejemplar[8] = $marc_record2->subfield('505','t');

    $ejemplar[9] = $nivel3->nivel2->getTipoDocumento();

    $ejemplar[10] = $nivel3->getCodigoBarra();


    if($nivel3->getDisponibilidadObject()){
        $ejemplar[11] = $nivel3->getDisponibilidadObject()->getNombre();
    }

    $ejemplar[12] = $nivel3->getEstado();
    $ejemplar[13] = $marc_record3->subfield('995','m');
    $ejemplar[14] = $marc_record3->subfield('900','g');

    $ejemplar[15] = $marc_record1->subfield('583','a');
    $ejemplar[16] = $marc_record1->subfield('583','c');
    $ejemplar[17] = $marc_record1->subfield('583','k');

    print join('~', @ejemplar);
    print "\n";
}


1;