package C4::AR::Busquedas;

#Copyright (C) 2003-2008  Linti, Facultad de Informática, UNLP
#This file is part of Koha-UNLP
#
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

use strict;
require Exporter;
use C4::Context;
use Date::Manip;
use C4::Date;
use C4::AR::Catalogacion;
use C4::AR::Utilidades;
use C4::AR::Reservas;
use C4::AR::Nivel1;
use C4::AR::Nivel2;
use C4::AR::Nivel3;
use C4::AR::PortadasRegistros;
use C4::AR::Estantes;
use Text::Aspell;
use C4::Modelo::RepHistorialBusqueda;
use C4::Modelo::SysExternosMeran::Manager;
use Sphinx::Search  qw(SPH_MATCH_ANY SPH_MATCH_PHRASE SPH_MATCH_BOOLEAN SPH_MATCH_EXTENDED SPH_MATCH_ALL SPH_SORT_RELEVANCE);
use Sphinx::Manager qw(new);
use URI::Escape;
use Text::Unaccent;

use vars qw(@EXPORT_OK @ISA);
@ISA=qw(Exporter);
@EXPORT_OK=qw(
    busquedaAvanzada
    busquedaCombinada
    armarBuscoPor
    obtenerEdiciones
    obtenerGrupos
    busquedaCombinada_newTemp
    obtenerDisponibilidadTotal
    busquedaPorBarcode
    buscarMapeo
    buscarMapeoTotal
    buscarMapeoCampoSubcampo
    buscarCamposMARC
    buscarSubCamposMARC
    buscarDatoDeCampoRepetible
    busquedaSignaturaBetween
    busquedaPorEstante
    busquedaEstanteDeGrupo
    busquedaPorId
    filtrarPorAutor
    MARCRecordById3
    MARCDetail
    getLibrarian
    getautor
    getLevel
    getLevels
    getCountry
    getCountryTypes
    getSupport
    getSupportTypes
    getLanguage
    getLanguages
    getItemType
    getItemTypes
    getborrowercategory
    getAvail
    getAvails
    getTema
    getNombreLocalidad
    getBranches
    getBranch
    t_loguearBusqueda
    toOAI
    cantServidoresExternos
    getServidoresExternos
);


=head2
    sub buscarTodosLosDatosFromNivel2ByCampoSubcampo

    speedy gonzalezzzz
=cut
sub buscarTodosLosDatosFromNivel2ByCampoSubcampo {
    my ($campo, $subcampo) = @_;

    my @filtros;
    my @datos_array;

    my $cat_registro_marc_n2_array_ref = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2( query => \@filtros);

    foreach my $n2 (@$cat_registro_marc_n2_array_ref){
        my $marc_record = MARC::Record->new_from_usmarc($n2->getMarcRecord);

        foreach my $field ($marc_record->field($campo)) {
#             C4::AR::Debug::debug("field => ".$field->tag);
        
            foreach my $subfield ($field->subfields()) {
                if ($subfield->[0] eq $subcampo){
#                     C4::AR::Debug::debug("subfield => ".$subfield->[0]);
#                     C4::AR::Debug::debug("dato => ".$subfield->[1]);
                    push (@datos_array, $subfield->[1]);
                }
            }# END foreach my $subfield ($field->subfields())

        }# END foreach my $field ($marc_record->field($campo))
    }

    return (\@datos_array);
}

=item
getLibrarianEstCat
trae el texto para mostrar (librarian), segun campo y subcampo, sino exite, devuelve 0
=cut
sub getLibrarianEstCat{
    my ($campo, $subcampo,$dato, $itemtype)= @_;

    my $dbh = C4::Context->dbh;
    my $query = "SELECT ec.*,ir.idinforef, ir.referencia as tabla, campos, separador, orden";
    $query .= " FROM cat_estructura_catalogacion ec LEFT JOIN pref_informacion_referencia ir ";
    $query .= " ON (ec.id = ir.idestcat) ";
    $query .= " WHERE(ec.campo = ?)and(ec.subcampo = ?)and(ec.itemtype = ?) ";

    my $sth=$dbh->prepare($query);
    $sth->execute($campo, $subcampo, $itemtype);
    my $nuevoDato;
    my $data=$sth->fetchrow_hashref();

    if($data && $data->{'visible'}){
        if($data->{'referencia'} && $dato ne ""){
        #DA ERROR FIXME 
        #$nuevoDato=&buscarDatoReferencia($dato,$data->{'tabla'},$data->{'campos'},$data->{'separador'});
            $data->{'dato'}=$nuevoDato;
        }
        else{
            $data->{'dato'}=$dato;
        }
    }
    else{
        $data->{'liblibrarian'}=0;
        $data->{'dato'}="";
        $data->{'visible'}=0;
        
    }
#0 si no trae nada
    return $data;
}

=item
getLibrarianEstCatOpac
trae el texto para mostrar (librarian), segun campo y subcampo, sino exite, devuelve 0
=cut
sub getLibrarianEstCatOpac{
    my ($campo, $subcampo, $dato, $itemtype)= @_;

    my $dbh = C4::Context->dbh;

# open(A, ">>/tmp/debug.txt");
# print A "\n";
# print A "entro a getLibrarianEstCatOpac \n";
# print A "*************************************************************************\n";
# print A "campo: $campo \n";
# print A "subcampo: $subcampo \n";
# print A "itemtype: $itemtype \n";
# print A "dato: $dato \n";

my $query = " SELECT * ";
$query .= " FROM cat_estructura_catalogacion_opac eco INNER JOIN";
$query .= " cat_encabezado_item_opac eio ";
$query .= " ON (eco.idencabezado = eio.idencabezado) ";
$query .= " WHERE(eco.campo = ?)and(eco.subcampo = ?) and (visible = 1) ";
$query .= " and (eio.itemtype = ?)";

    my $sth=$dbh->prepare($query);
    $sth->execute($campo, $subcampo, $itemtype);
        my $data1=$sth->fetchrow_hashref;

    my $data;
    my $textPred;
    my $textSucc;

    if($data1){

        $textPred= $data1->{'textpred'};
        $textSucc= $data1->{'textsucc'};

        my $dbh = C4::Context->dbh;
        my $query = "SELECT ec.*, ir.idinforef, ir.referencia as tabla, campos, separador, orden";
        $query .= " FROM cat_estructura_catalogacion ec LEFT JOIN pref_informacion_referencia ir ";
        $query .= " ON (ec.id = ir.idestcat) ";
        $query .= " WHERE(ec.campo = ?)and(ec.subcampo = ?)and(ec.itemtype = ?) ";

        my $sth=$dbh->prepare($query);
        $sth->execute($campo, $subcampo, $itemtype);
        my $nuevoDato;
        $data=$sth->fetchrow_hashref();

        if($data->{'referencia'} && $dato ne ""){
          $nuevoDato=&buscarDatoReferencia($dato,$data->{'tabla'},$data->{'campos'},$data->{'separador'});
# print A "dato nuevo **************************************** $nuevoDato \n";
          $data->{'dato'}= $nuevoDato;
          $data->{'textPred'}= $textPred;
          $data->{'textSucc'}= $textSucc;
#         return $textPred." ".$nuevoDato;
          return $data;
#         return $nuevoDato;

        }
        else{
          $data->{'dato'}= $dato;
          $data->{'textPred'}= $textPred;
          $data->{'textSucc'}= $textSucc;
# print A "dato **************************************** $dato \n";
# print A "textpred **************************************** $textPred \n";
#         return $textPred." ";
          return $data;
        }
        
#       return $textPred." ".$data->{'dato'}." ".$textSucc;
#       return $textPred." ";

    }
    else {
        $data->{'dato'}= "";
        $data->{'textPred'}= "";
        $data->{'textSucc'}= "";
        return $data;
#       return 0;
    }
# close(A);

#0 si no trae nada
#   return $sth->fetchrow_hashref; 
}


=item
getLibrarianMARCSubField
trae el texto para mostrar (librarian), segun campo y subcampo, sino exite, devuelve 0
=cut
sub getLibrarianMARCSubField{
    my ($campo, $subcampo)= @_;
    my $dbh = C4::Context->dbh;

    my $query = " SELECT * ";
    $query .= " FROM pref_estructura_subcampo_marc ";
    $query .= " WHERE (campo = ? )and(subcampo = ?)";

    my $sth=$dbh->prepare($query);
    $sth->execute($campo, $subcampo);

    return $sth->fetchrow_hashref;
}

=item
getLibrarianIntra
Busca para un campo y subcampo, dependiendo el itemtype, como esta catalogado para mostrar en el template. Busca en la tabla estructura_catalogacion y sino lo encuentra lo busca en marc_subfield_structure que si o si esta.
=cut
sub getLibrarianIntra{
    my ($campo, $subcampo,$dato, $itemtype,$detalleMARC) = @_;

#busca librarian segun campo, subcampo e itemtype
    my $librarian= &getLibrarianEstCat($campo, $subcampo, $dato,$itemtype);

#si no encuentra, busca para itemtype = 'ALL'
    if(!$librarian->{'liblibrarian'}){
        $librarian= &getLibrarianEstCat($campo, $subcampo, $dato,'ALL');
    }
    
    if($librarian->{'liblibrarian'} && !$librarian->{'visible'} && !$detalleMARC){
        #Si esta catalogado y pero no esta visible retorna 0 para que no se vea el dato
        $librarian->{'liblibrarian'}=0;
        $librarian->{'dato'}="";
        return $librarian;
    }
    elsif(!$librarian->{'liblibrarian'}){
        $librarian= &getLibrarianMARCSubField($campo, $subcampo);
        $librarian->{'dato'}=$dato;
    }
    return $librarian;
}

=item
getLibrarianOpac
Busca para un campo y subcampo, dependiendo el itemtype, como esta catalogado para mostrar en el template. Busca en la tabla estructura_catalogacion_opac y sino lo encuentra lo busca en marc_subfield_structure que si o si esta.
=cut
sub getLibrarianOpac{
    my ($campo, $subcampo,$dato, $itemtype,$detalleMARC) = @_;
    my $textPred;   
    my $textSucc;
#busca librarian segun campo, subcampo e itemtype
    my $librarian= &getLibrarianEstCatOpac($campo, $subcampo, $dato, $itemtype);
#si no encuentra, busca para itemtype = 'ALL'
    if(!$librarian){
        $librarian= &getLibrarianEstCatOpac($campo, $subcampo, $dato, 'ALL');
    }
    elsif($detalleMARC){
        $librarian= &getLibrarianMARCSubField($campo, $subcampo);
        $librarian->{'dato'}=$dato;
    }


    return $librarian;
}

sub getLibrarian{
    my ($campo, $subcampo,$dato,$itemtype,$tipo,$detalleMARC)=@_;
    my $librarian;
    if($tipo eq "intra"){
        $librarian=&getLibrarianIntra($campo, $subcampo,$dato, $itemtype,$detalleMARC);
    }else{
        $librarian=&getLibrarianOpac($campo, $subcampo,$dato, $itemtype,$detalleMARC);
    } 
    return $librarian;
}

=item
buscarMapeo
Asocia los campos marc correspondientes con los campos de las tablas de los nivel 1, 2 y 3 (koha) correspondiente al parametro que llega.
=cut
sub buscarMapeo{
    my ($tabla)= @_;
    my $dbh = C4::Context->dbh;
    my %mapeo;
    my $llave;
    my $query = " SELECT * FROM cat_pref_mapeo_koha_marc WHERE tabla = ? ";
    
    my $sth=$dbh->prepare($query);
    $sth->execute($tabla);
    while(my $data=$sth->fetchrow_hashref){
        $llave=$data->{'campo'}.",".$data->{'subcampo'};
        $mapeo{$llave}->{'campo'}=$data->{'campo'};
        $mapeo{$llave}->{'subcampo'}=$data->{'subcampo'};
        $mapeo{$llave}->{'tabla'}=$data->{'tabla'};
        $mapeo{$llave}->{'campoTabla'}=$data->{'campoTabla'};
    }
    return (\%mapeo);
}

=item
buscarMapeoTotal
Busca el mapeo de los campos de todas las tablas de niveles y obtiene el nombre de los campos
=cut
sub buscarMapeoTotal{
    my $dbh = C4::Context->dbh;
    my %mapeo;
    my $llave;
    my $query = " SELECT * FROM cat_pref_mapeo_koha_marc WHERE tabla like 'cat_nivel%' ORDER BY tabla";
    
    my $sth=$dbh->prepare($query);
    $sth->execute();
    while(my $data=$sth->fetchrow_hashref){
        $llave=$data->{'campo'}.",".$data->{'subcampo'};
        $mapeo{$llave}->{'campo'}=$data->{'campo'};
        $mapeo{$llave}->{'subcampo'}=$data->{'subcampo'};
        $mapeo{$llave}->{'tabla'}=$data->{'tabla'};
        $mapeo{$llave}->{'campoTabla'}=$data->{'campoTabla'};
        $mapeo{$llave}->{'nombre'}=$data->{'nombre'};
    }
    return (\%mapeo);
}

sub buscarMapeoCampoSubcampo{
    my ($campo,$subcampo,$nivel)=@_;
    my $dbh = C4::Context->dbh;
    my $tabla="nivel".$nivel;
    my $campoTabla=0;
    my $query = " SELECT campoTabla FROM cat_pref_mapeo_koha_marc WHERE tabla =? AND campo=? AND subcampo=?";
    my $sth=$dbh->prepare($query);
    $sth->execute($tabla,$campo,$subcampo);
    if(my $data=$sth->fetchrow_hashref){
        $campoTabla=$data->{'campoTabla'};
    }
    return $campoTabla;
}

=item
buscarSubCamposMapeo
Busca el mapeo para el subcampo perteneciente al campo que se pasa por parametro.
=cut
sub buscarSubCamposMapeo{
    my ($campo)=@_;
    my $dbh = C4::Context->dbh;
    my %mapeo;
    my $llave;
    my $query = " SELECT * FROM cat_pref_mapeo_koha_marc WHERE tabla like 'cat_nivel%' AND campo = ?";
    
    my $sth=$dbh->prepare($query);
    $sth->execute($campo);
    while(my $data=$sth->fetchrow_hashref){
        $llave=$data->{'campo'}.",".$data->{'subcampo'};
        $mapeo{$llave}->{'subcampo'}=$data->{'subcampo'};
        $mapeo{$llave}->{'tabla'}=$data->{'tabla'};
    }
    return (\%mapeo);
}





=item
obtenerEdiciones
obtiene las ediciones que pose un id de nivel 1.
=cut
sub obtenerEdiciones{
    my ($id1,$itemtype)=@_;
    my @ediciones;
    my $dbh = C4::Context->dbh;
    my $query="SELECT * FROM cat_nivel2 WHERE id1=? ";

    if($itemtype != -1 && $itemtype ne "" && $itemtype ne "ALL"){
        $query .=" and tipo_documento = '".$itemtype."'";
    }

    my $sth=$dbh->prepare($query);
    $sth->execute($id1);
    my $i=0;
    while(my $data=$sth->fetchrow_hashref){
        $ediciones[$i]->{'anio_publicacion'}=$data->{'anio_publicacion'};
        $i++;
    }
    return(@ediciones);
}

=item
obtenerGrupos
Esta funcion devuelve los datos de los grupos a mostrar en una busaqueda dado un id1. Se puede filtrar por tipo de documento.
=cut
sub obtenerGrupos {
    my ($id1,$itemtype,$type,$niveles2)=@_;
    
    #Obtenemos los niveles 2
    if (!$niveles2){
        $niveles2 = C4::AR::Nivel2::getNivel2FromId1($id1);
    }
    
    my @result;
    my $res=0;
    foreach my $nivel2 (@$niveles2){
        $result[$res]->{'id2'}                  = $nivel2->getId2;
        $result[$res]->{'edicion'}              = $nivel2->getEdicion;
        $result[$res]->{'anio_publicacion'}     = $nivel2->getAnio_publicacion;
        $result[$res]->{'estantes_array'}       = C4::AR::Estantes::getEstantesById2($nivel2->getId2());
        $res++;
    }

    return (\@result);
}

=item
obtenerEstadoDeColeccion
Esta funcion devuelve los datos de los fasciculos agrupados para años .
=cut
sub obtenerEstadoDeColeccion {
    my ($id1,$itemtype,$type, $niveles2)=@_;
    
    my $cant_revistas=0;
    #Obtenemos los niveles 2

    if (!$niveles2){
       $niveles2 = C4::AR::Nivel2::getNivel2FromId1($id1);
    }
    
    my %HoH = {}; 
    foreach my $nivel2 (@$niveles2){
        
        if($nivel2->getTipoDocumento eq 'REV'){
            $cant_revistas++;
            
            my $anio='#';
            if(($nivel2->getAnioRevista ne undef)&&(C4::AR::Utilidades::trim($nivel2->getAnioRevista) ne '')){
                $anio = C4::AR::Utilidades::trim($nivel2->getAnioRevista);
            }
            
            my $volumen='#';
            if(($nivel2->getVolumenRevista ne undef)&&(C4::AR::Utilidades::trim($nivel2->getVolumenRevista) ne '')){
                $volumen = C4::AR::Utilidades::trim($nivel2->getVolumenRevista);
            }
            
            my $numero='#';
            if(($nivel2->getNumeroRevista ne undef)&&(C4::AR::Utilidades::trim($nivel2->getNumeroRevista) ne '')){
                $numero = C4::AR::Utilidades::trim($nivel2->getNumeroRevista);
            }
            
            $HoH{$anio}->{$volumen}->{$numero}=$nivel2->getId2;
            
        }
    }

return ($cant_revistas,\%HoH);
}


sub obtenerDisponibilidadTotal{
    my ($id1, $itemtype) = @_;

    my @disponibilidad;

    my ($cat_ref_tipo_nivel3_array_ref) = C4::AR::Nivel3::getNivel3FromId1($id1);

    
    my $cant_para_domicilio     = 0;
    my $cant_para_sala          = 0;
    my $cant_no_disponible      = 0;
    my $i                       = 0;

    foreach my $n3 (@$cat_ref_tipo_nivel3_array_ref){
        # C4::AR::Debug::debug("Busquedas => obtenerDisponibilidadTotal => BARCODE => ".$n3->getBarcode());
        if($n3->estadoDisponible){
            if ($n3->esParaPrestamo) {
            #DOMICILIO    
                # C4::AR::Debug::debug("Busquedas => obtenerDisponibilidadTotal => DOMICILIO");
                $cant_para_domicilio++;
            } elsif($n3->esParaSala) {
            #PARA SALA
                # C4::AR::Debug::debug("Busquedas => obtenerDisponibilidadTotal => PARA SALA");
                $cant_para_sala++;
            }
        } else {
            #NO DISPONIBLE
            # C4::AR::Debug::debug("Busquedas => obtenerDisponibilidadTotal => NO DISPONIBLE ");
            $cant_no_disponible++;
        }
    }

    $disponibilidad[$i]->{'tipoPrestamo'}   = "Domicilio";
    $disponibilidad[$i]->{'domicilio'}      = 1;
    $disponibilidad[$i]->{'cantTotal'}      = $cant_para_domicilio || 0;

    $i++;
    $disponibilidad[$i]->{'tipoPrestamo'}   = "Sala";
    $disponibilidad[$i]->{'domicilio'}      = 0;
    $disponibilidad[$i]->{'cantTotal'}      = $cant_para_sala || 0;

    $disponibilidad[$i]->{'nodisponibles'}  = "No Disponibles: ".$cant_no_disponible;
    $disponibilidad[$i]->{'prestados'}      = "Prestados: ".C4::AR::Prestamos::getCountPrestamosDelRegistro($id1);
    $disponibilidad[$i]->{'reservados'}     = "Reservados: ".C4::AR::Reservas::cantReservasPorNivel1($id1);

    return(@disponibilidad);
}


#****************************************************MARC DETAIL**************************************************


=item
buscarSubCamposMARC
Busca los subcampos correspondiente al parametro de campo y que no sean propios de una tabla de nivel, solo los que estan en tablas de nivel repetibles.
=cut
sub buscarSubCamposMARC{
    my ($campo) =@_;
    my $dbh = C4::Context->dbh;
    my $query="SELECT subcampo FROM pref_estructura_subcampo_marc ";
    $query .=" WHERE nivel > 0 AND campo = ? ";
    my $mapeo=&buscarSubCamposMapeo($campo);
    foreach my $llave (keys %$mapeo){
        $query.=" AND (subcampo <> '".$mapeo->{$llave}->{'subcampo'}."' ) ";
    }
    my $sth=$dbh->prepare($query);
        $sth->execute($campo);
    my @results;
    while(my $data=$sth->fetchrow_hashref){
        push (@results, $data->{'subcampo'});
    }

    $sth->finish;
    return (@results);
}



=item
buscarNivel2EnMARC
Busca los datos de la tabla nivel2 y nivel2_repetibles y los devuelve en formato MARC (campo,subcampo,dato).
=cut
sub buscarNivel2EnMARC{
    my ($id1)=@_;
# open(A, ">>/tmp/debug.txt");
# print A "\n";
# print A "desde buscarNivel2EnMARC \n";
    my $dbh = C4::Context->dbh;
    my @nivel2=&buscarNivel2PorId1($id1);
    my $mapeo=&buscarMapeo('cat_nivel2');
    my $id2;
    my $itemtype;
    my $llave;
    my $i=0;
    my $dato;
    my @nivel2Comp;
    foreach my $row(@nivel2){
        $id2=$row->{'id2'};
        $itemtype=$row->{'itemtype'};
        $nivel2Comp[$i]->{'id2'}=$id2;
# print A "         fila: ".$i."\n";
# print A "         id2: ".$id2."\n";
# print A "         itemtype: ".$itemtype."\n";
        $nivel2Comp[$i]->{'itemtype'}=$itemtype;
        foreach my $llave (keys %$mapeo){
            $dato= $row->{$mapeo->{$llave}->{'campoTabla'}};
            $nivel2Comp[$i]->{$llave}=$dato;
# print A "llave ".$llave."\n";
# print A "dato ".$dato."\n";
            $nivel2Comp[$i]->{'campo'}= $mapeo->{$llave}->{'campo'};
            $nivel2Comp[$i]->{'subcampo'}= $mapeo->{$llave}->{'subcampo'};
#           $i++;
        }
        my $query="SELECT * FROM cat_nivel2_repetible WHERE id2=?";
        my $sth=$dbh->prepare($query);
            $sth->execute($id2);
        while (my $data=$sth->fetchrow_hashref){
            $llave=$data->{'campo'}.",".$data->{'subcampo'};

            $nivel2Comp[$i]->{'campo'}= $data->{'campo'};
            $nivel2Comp[$i]->{'subcampo'}= $data->{'subcampo'};

            if(not exists($nivel2Comp[$i]->{$llave})){
                $nivel2Comp[$i]->{$llave}= $data->{'dato'};#FALTA BUSCAR REFERENCIA SI ES QUE TIENE!!!!
            }
            else{
                $nivel2Comp[$i]->{$llave}.= " *?* ".$data->{'dato'};
            }
#           $i++;
# print A "llave ".$llave."\n";
# print A "dato ".$data->{'dato'}."\n";
        }
        $i++;
# print A "*****************************************Otra HASH********************************************** \n"
    }
    return \@nivel2Comp;
}

sub buscarDatoDeCampoRepetible {
    my ($id,$campo,$subcampo,$nivel)=@_;
    
    my $niveln;
    my $idn;
    if ($nivel eq "1") {$niveln='cat_nivel1_repetible';$idn='id1';} elsif ($nivel eq "2"){$niveln='cat_nivel2_repetible';$idn='id2';} else {$niveln='cat_nivel3_repetible';$idn='id3';}

    my $dbh = C4::Context->dbh;
    my $query="SELECT dato FROM ".$niveln." WHERE campo = ? and subcampo = ? and ".$idn." = ?;";
    my $sth=$dbh->prepare($query);
    $sth->execute($campo,$subcampo,$id);
    my $data=$sth->fetchrow_hashref;
    return $data->{'dato'};
}

sub getLevel{
        my ($cod) = @_;
        my $dbh = C4::Context->dbh;
        my $query = "SELECT * from ref_nivel_bibliografico where code = ? ";
        my $sth = $dbh->prepare($query);
        $sth->execute($cod);
        my $res=$sth->fetchrow_hashref;
        $sth->finish();
        return $res;
}

#Nivel bibliografico
sub getLevels {
    my $dbh   = C4::Context->dbh;
    my $sth   = $dbh->prepare("select * from ref_nivel_bibliografico");
    my %resultslabels;
    $sth->execute;
    while (my $data = $sth->fetchrow_hashref) {
        $resultslabels{$data->{'code'}}= $data->{'description'};
    }
    $sth->finish;
    return(%resultslabels);
} # sub getlevels

sub  getCountry{
        my ($cod) = @_;
        my $dbh = C4::Context->dbh;
        my $query = "SELECT * FROM ref_pais WHERE iso = ? ";
        my $sth = $dbh->prepare($query);
        $sth->execute($cod);
        my $res=$sth->fetchrow_hashref;
        $sth->finish();
        return $res;
}

sub getCountryTypes{
    my $dbh   = C4::Context->dbh;
    my $sth   = $dbh->prepare("SELECT * FROM ref_pais ");
     my %resultslabels;
    $sth->execute;
    while (my $data = $sth->fetchrow_hashref) {
        $resultslabels{$data->{'iso'}}= $data->{'printable_name'};  
    }
    $sth->finish;
    return(%resultslabels);
} # sub getcountrytypes

sub getSupport{
        my ($cod) = @_;
        my $dbh = C4::Context->dbh;
        my $query = "SELECT * from ref_soporte where idSupport = ? ";
        my $sth = $dbh->prepare($query);
        $sth->execute($cod);
        my $res=$sth->fetchrow_hashref;
        $sth->finish();
        return $res;
}


sub getSupportTypes{
    my $dbh   = C4::Context->dbh;
    my $sth   = $dbh->prepare("SELECT * FROM ref_soporte");
    my %resultslabels;
    $sth->execute;
    while (my $data = $sth->fetchrow_hashref) {
            $resultslabels{$data->{'idSupport'}}= $data->{'description'};   
    }
    $sth->finish;
    return(%resultslabels);
} # sub getsupporttypes

sub getLanguage{
        my ($cod) = @_;
        my $dbh = C4::Context->dbh;
        my $query = "SELECT * FROM ref_idioma WHERE idLanguage = ? ";
        my $sth = $dbh->prepare($query);
        $sth->execute($cod);
        my $res=$sth->fetchrow_hashref;
        $sth->finish();
        return $res;
}

sub getLanguages{
     my $dbh   = C4::Context->dbh;
    my $sth   = $dbh->prepare("SELECT * FROM ref_idioma");
    my %resultslabels;
    $sth->execute;
    while (my $data = $sth->fetchrow_hashref) {
            $resultslabels{$data->{'idLanguage'}}= $data->{'description'};  
    }
    $sth->finish;
    return(%resultslabels);
} # sub getlanguages

sub getItemType {
    my ($type)=@_;
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare("SELECT nombre FROM cat_ref_tipo_nivel3 WHERE id_tipo_doc=?");
    $sth->execute($type);
    my $dat=$sth->fetchrow_hashref;
    $sth->finish;

    return ($dat->{'nombre'});
}

## FIXME DEPRECATED
sub getItemTypes {
    my $dbh   = C4::Context->dbh;
    my $sth   = $dbh->prepare("SELECT * FROM cat_ref_tipo_nivel3 ORDER BY nombre");
    my $count = 0;
    my @results;

    $sth->execute;
    while (my $data = $sth->fetchrow_hashref) {
            $results[$count] = $data;
            $count++;
    }

    $sth->finish;
    return($count, @results);
} # sub getitemtypes

=item getborrowercategory
  $description = &getborrowercategory($categorycode);
Given the borrower's category code, the function returns the corresponding
description for a comprehensive information display.
=cut
## FIXME DEPRECATEDDDDDDDDDDDDDDDDDD C4::AR::Busquedas::getborrowercategory
sub getborrowercategory{
    my ($catcode) = @_;
    my $dbh = C4::Context->dbh;
    my $sth = $dbh->prepare("SELECT description FROM usr_ref_categoria_socio WHERE categorycode = ?");
    $sth->execute($catcode);
    my $description = $sth->fetchrow();
    $sth->finish();
    return $description;
} # sub getborrowercategory

sub getAvail{
        my ($cod) = @_;
        my $dbh = C4::Context->dbh;
        my $query = "SELECT * from ref_disponibilidad where codigo = ? ";
        my $sth = $dbh->prepare($query);
        $sth->execute($cod);
        my $res=$sth->fetchrow_hashref;
        $sth->finish();
        return $res;
}

#Disponibilidad
sub getAvails {
    my $dbh   = C4::Context->dbh;
    my $sth   = $dbh->prepare("select * from ref_disponibilidad");
    my %resultslabels;
    $sth->execute;
    while (my $data = $sth->fetchrow_hashref) {
            $resultslabels{$data->{'codigo'}}= $data->{'nombre'};
    }
    $sth->finish;
    return(%resultslabels);
} # sub getavails


#Temas, toma un id de tema y devuelve la descripcion del tema.
sub getTema{
    my ($idTema)=@_;
    my $dbh = C4::Context->dbh;
        my $query = "SELECT * from cat_tema where id = ? ";
        my $sth = $dbh->prepare($query);
        $sth->execute($idTema);
        my $tema=$sth->fetchrow_hashref;
        $sth->finish();
    return($tema);
}

=item
getNombreLocalidad
Devuelve el nombre de la localidad que se pasa por parametro.
=cut
## FIXME DEPRECATEDDDDDDDDDDDDDDDDDD   C4::AR::Busquedas::getNombreLocalidad
sub getNombreLocalidad{
    my ($catcode) = @_;
    my $dbh = C4::Context->dbh;
    my $sth = $dbh->prepare("SELECT nombre FROM ref_localidad WHERE localidad = ?");
    $sth->execute($catcode);
    my $description = $sth->fetchrow();
    $sth->finish();
    if ($description) {return $description;}
    else{return "";}
}

=item
getBranches
Devuelve una hash con todas bibliotecas y sus relaciones.
=cut

sub getBranches {
# returns a reference to a hash of references to branches...
    my %branches;
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" SELECT pref_unidad_informacion.*,categorycode 
                FROM pref_unidad_informacion INNER JOIN pref_relacion_unidad_informacion 
                ON pref_unidad_informacion.id_ui=pref_relacion_unidad_informacion.branchcode");
    $sth->execute;
    while (my $branch=$sth->fetchrow_hashref) {
        $branches{$branch->{'id_ui'}}=$branch;
    }
    return (\%branches);
}

=item
getBranch
=cut
sub getBranch{
    my($branch) = @_;

    return C4::AR::PdfGenerator::datosBiblio($branch);
}


########################################################## NUEVOS!!!!!!!!!!!!!!!!!!!!!!!!!! #################################################


sub _getMatchMode{
  my ($tipo) = @_;
  #por defecto se setea este match_mode
  my $tipo_match = SPH_MATCH_ANY;

  if($tipo eq 'SPH_MATCH_ANY'){
    #Match any words
    $tipo_match = SPH_MATCH_ANY;
  }elsif($tipo eq 'SPH_MATCH_PHRASE'){
    #Exact phrase match
    $tipo_match = SPH_MATCH_PHRASE;
  }elsif($tipo eq 'SPH_MATCH_BOOLEAN'){
    #Boolean match, using AND (&), OR (|), NOT (!,-) and parenthetic grouping
    $tipo_match = SPH_MATCH_BOOLEAN;
  }elsif($tipo eq 'SPH_MATCH_EXTENDED'){
    #Extended match, which includes the Boolean syntax plus field, phrase and proximity operators
    $tipo_match = SPH_MATCH_EXTENDED;
  }elsif($tipo eq 'SPH_MATCH_ALL'){
    #Match all words
    $tipo_match = SPH_MATCH_ALL;
  }
}

sub index_update{
  system('indexer --rotate --all');
}

sub getSuggestion{
    my ($search,$cant_result_busqueda,$obj_for_log,$sphinx_options) = @_;
    my $speller = Text::Aspell->new;
    my $lang = C4::AR::Auth::getUserLocale();
    C4::AR::Debug::debug("******************* USER LANG DE SUGGESTIONS: ".$lang);
    C4::AR::Debug::debug("******************* SUGGESTION!!!!!: ".suggestion($search));

    my $only_sphinx        = 0;
    my $only_available     = 0;
    my $session = CGI::Session->load();
    
    if ($sphinx_options){
        $only_sphinx        = $sphinx_options->{'only_sphinx'} || 0;
        $only_available     = $sphinx_options->{'only_available'} || 0;
    }

    $speller->set_option('lang',$lang);
    
    $obj_for_log->{'from_suggested'} = 1;
    my $suggestion = "";
    my @words = split(/ /,$search);
    my $total_found = 0;
    my $cont = 0;
    while ( ($total_found <= 0) && ($cont < 50) ){
        $suggestion="";

        foreach my $word (@words){
            my @suggestions = $speller->suggest($word);
            $suggestion.= @suggestions[$cont]." ";
        }
        
        $suggestion = Encode::encode_utf8($suggestion);
        $obj_for_log->{'no_log_search'} = 1;
        ($total_found) = C4::AR::Busquedas::busquedaCombinada_newTemp($suggestion,$session,$obj_for_log,$sphinx_options);
        $cont++;
    }

    if ( ($suggestion ne $search) && (C4::AR::Utilidades::validateString($suggestion)) ){
        if ( ($cant_result_busqueda < 10) && ($total_found) ){
            return ($suggestion);
        }
    }
    return (0);
}

sub buildTrigrams {
    my ($keyword) = @_;
    my $t = "__" . $keyword . "__";

    my $trigrams = "";
    for (my $i=0; $i<length($t)-2; $i++ ){
        $trigrams .= substr ( $t, $i, 3 ) . " ";
    }

    return $trigrams;
}

sub suggestion {
    my ($keyword) = @_;
    
    use Sphinx::Search;
    use Text::LevenshteinXS qw(distance);

    my $trigrams = buildTrigrams ( $keyword );
    my $query = "\"$trigrams\"/1";
    my $len = length($keyword);
    my $delta = 2;

    my $sphinx          = Sphinx::Search->new();

    $sphinx->SetMatchMode (  SPH_MATCH_EXTENDED2 );
    $sphinx->SetRankingMode ( SPH_RANK_WORDCOUNT );
    $sphinx->SetFilterRange ( "len", $len-$delta, $len+$delta );
    $sphinx->SetSelect ( "*, \@weight+$delta-abs(len-$len) AS myrank" );
    $sphinx->SetSortMode ( SPH_SORT_EXTENDED, "myrank DESC, freq DESC" );

    $sphinx->SetLimits ( 0, 10 );
    my $res = $sphinx->Query ( $query,  C4::AR::Preferencias::getValorPreferencia("nombre_indice_sugerencia_sphinx") );

    if ((!$res) || (!$res->{"matches"})){
        return 0;
    }

    my $matches = $res->{"matches"};
    foreach my $match  (@$matches)
    {
      my  $suggested = $match->{"keyword"};
          C4::AR::Debug::debug("******************* SUGGESTION!!!!!: ". $suggested." ditancia ".distance( $keyword, $suggested ) );
      if ( distance( $keyword, $suggested ) le  C4::AR::Preferencias::getValorPreferencia("distancia_sugerencia_sphinx") ){
            return $suggested;
     }
    }
    return '';
}

sub busquedaAvanzada_newTemp{
    my ($params,$session) = @_;

    use Sphinx::Search;
    
    my $only_sphinx     = $params->{'only_sphinx'};
    my $only_available  = $params->{'only_available'};
    my $opac_only_state_available = $params->{'opac_only_state_available'} || 0;

    my $sphinx          = Sphinx::Search->new();

            C4::AR::Debug::debug(" only_sphinx BUSQUEDA --------------------------- : ".$only_sphinx);

    if ($only_sphinx){
        if ($params->{'report'}){ 
            $sphinx->SetLimits($params->{'ini'}, 100000);
 
       } else {            
            $sphinx->SetLimits($params->{'ini'}, C4::AR::Preferencias::getValorPreferencia('paginas'));  
            C4::AR::Debug::debug("LIMITE BUSQUEDA --------------------------- : ".$params->{'ini'}." - ".C4::AR::Preferencias::getValorPreferencia('paginas'));
       }

    }

    my $query   = '';
    my $tipo    = 'SPH_MATCH_EXTENDED';
    my $orden   = $params->{'orden'} || 'titulo';
    my $sentido_orden   = $params->{'sentido_orden'};
    my $keyword;
   
    if($params->{'titulo'} ne ""){
        $keyword = unac_string('utf8',$params->{'titulo'});
        #le sacamos los acentos para que busque indistintamente
#        $params->{'titulo'} = unac_string('utf8',$params->{'titulo'});
        $query .= ' @titulo "'.$keyword;
        if($params->{'tipo'} eq "normal"){
            $query .= "*";
        }
        $query .='"';
    }

    if($params->{'autor'} ne ""){
        $keyword = unac_string('utf8',$params->{'autor'});
#        $params->{'autor'} = unac_string('utf8',$params->{'autor'});
#        C4::AR::Debug::debug("autorrrrrrrrrrrr --------------------------- : ".$params->{'autor'});
        $query .= ' @autor "'.$keyword;

        if($params->{'tipo'} eq "normal"){
            $query .= "*";
        }
        $query .='"';
    }

    if( ($params->{'tipo_nivel3_name'} ne "") && ($params->{'tipo_nivel3_name'} ne "ALL") ){
        $query .= ' @string "'."cat_ref_tipo_nivel3%".$params->{'tipo_nivel3_name'};

        $query .='"';
    }

    if( $params->{'codBarra'} ne "") {
        $query .= ' @string "'."barcode%".$sphinx->EscapeString($params->{'codBarra'})."*'";
        $query .='*"';
    }


    if ($only_available){
        $query .= ' @string "ref_disponibilidad_code%'.C4::Modelo::RefDisponibilidad::paraPrestamoValue.'"';
    }
    
    if ($params->{'signatura'}){
        $query .= ' @string "'."signatura%".$sphinx->EscapeString($params->{'signatura'}).'*"';
    }
    
    if ($params->{'isbn'}){
        $query .= ' @string "'."isbn%".$sphinx->EscapeString($params->{'isbn'}).'*"';
    }

    if ($params->{'tema'} ne ""){
        C4::AR::Debug::debug("tema en el pm : ".$params->{'tema'});
        $keyword = unac_string('utf8',$params->{'tema'});
        $query .= ' @string "'."cat_tema%".$sphinx->EscapeString($keyword).'*"';
    }

    
    
    C4::AR::Debug::debug("tipo_nivel3_name BUSQUEDA_AVANZADA =================> ".$params->{'tipo_nivel3_name'});

    C4::AR::Debug::debug("Busquedas => query string => ".$query);

    my $tipo_match = C4::AR::Utilidades::getSphinxMatchMode($tipo);

    if ($opac_only_state_available){
        # Se filtran los registros que posean algún ejemplar disponible o bien sean analíticas
        $query .= ' ("ref_estado_code%'.C4::Modelo::RefEstado::estadoDisponibleValue.'" | "cat_ref_tipo_nivel3%ANA" | "cat_ref_tipo_nivel3%ELE")';
        $tipo_match = C4::AR::Utilidades::getSphinxMatchMode('SPH_MATCH_BOOLEAN');
    }

    $sphinx->SetMatchMode($tipo_match);
    
    
    if ($orden eq 'autor'){
            if ($sentido_orden){
                $sphinx->SetSortMode(SPH_SORT_ATTR_DESC,"autor_local");
            } else {
                $sphinx->SetSortMode(SPH_SORT_ATTR_ASC,"autor_local");
            }
    }elsif ($orden eq 'titulo') {
            if ($sentido_orden){
                $sphinx->SetSortMode(SPH_SORT_ATTR_DESC,"titulo_local");
            } else {
                $sphinx->SetSortMode(SPH_SORT_ATTR_ASC,"titulo_local");
            }
    } else {
            $sphinx->SetSortMode(SPH_SORT_EXTENDED,"promoted DESC, hits DESC, titulo_local ASC");
    }
    
    $sphinx->SetEncoders(\&Encode::encode_utf8, \&Encode::decode_utf8);
#     $sphinx->SetLimits($params->{'ini'}, $params->{'cantR'});

    # NOTA: sphinx necesita el string decode_utf8
   
    my $index_to_use = C4::AR::Preferencias::getValorPreferencia("nombre_indice_sphinx") || 'test1';
    
    my $results = $sphinx->Query($query, $index_to_use);

    my @id1_array;
    my $matches = $results->{'matches'};

    C4::AR::Debug::debug("RESULTS ".$results);
    
    C4::AR::Utilidades::printARRAY($results->{'matches'});

    C4::AR::Utilidades::printHASH($results);

    C4::AR::Debug::debug("CANTIDAD DE RESULTADOS EN DATOS ARRAY ".scalar(@$matches));

    
    my $total_found = $results->{'total_found'};
    $params->{'total_found'} = $total_found;

    C4::AR::Debug::debug("total_found: ".$total_found);
    C4::AR::Debug::debug("Busquedas.pm => LAST ERROR: ".$sphinx->GetLastError());
    C4::AR::Debug::debug("MATCH_MODE => ".$tipo);
    
    foreach my $hash (@$matches){
        my %hash_temp = {};
        $hash_temp{'id1'} = $hash->{'doc'};
        $hash_temp{'hits'} = $hash->{'weight'};

        push (@id1_array, \%hash_temp);
    }

    my ($total_found_paginado, $resultsarray);
    #arma y ordena el arreglo para enviar al cliente
    ($total_found_paginado, $resultsarray) = C4::AR::Busquedas::armarInfoNivel1($params, @id1_array);
    #se loquea la busqueda

    C4::AR::Busquedas::logBusqueda($params, $session);

    return ($total_found, $resultsarray);
}


sub busquedaPorId{
    my ($string,$session) = @_;

    use Sphinx::Search;
    
    my $sphinx          = Sphinx::Search->new();

    my $query   = '';
    my $tipo    = 'SPH_MATCH_EXTENDED';
    my $keyword;
   
    $keyword = unac_string('utf8',$string);
    $query .= ' @id "'.$sphinx->EscapeString($keyword).'"';
    

    my $tipo_match = C4::AR::Utilidades::getSphinxMatchMode($tipo);

    $sphinx->SetMatchMode($tipo_match);
    
    
    $sphinx->SetEncoders(\&Encode::encode_utf8, \&Encode::decode_utf8);
#     $sphinx->SetLimits($params->{'ini'}, $params->{'cantR'});

    # NOTA: sphinx necesita el string decode_utf8
   
    my $index_to_use = C4::AR::Preferencias::getValorPreferencia("nombre_indice_sphinx") || 'test1';
    
    my $results = $sphinx->Query($query, $index_to_use);

    my @id1_array;
    my $matches = $results->{'matches'};
    my $total_found = $results->{'total_found'};
    my %params = {};
    $params{'total_found'} = $total_found;

    foreach my $hash (@$matches){
        my %hash_temp = {};
        $hash_temp{'id1'} = $hash->{'doc'};
        $hash_temp{'hits'} = $hash->{'weight'};

        push (@id1_array, \%hash_temp);
    }

    my ($total_found_paginado, $resultsarray);
    #arma y ordena el arreglo para enviar al cliente
    ($total_found_paginado, $resultsarray) = C4::AR::Busquedas::armarInfoNivel1(\%params, @id1_array);
    #se loquea la busqueda

    C4::AR::Busquedas::logBusqueda(\%params, $session);

    return ($total_found, $resultsarray);
}

sub busquedaPorTema{
    
    my ($tema, $session, $obj_for_log) = @_;
    
    $obj_for_log->{'match_mode'} = 'SPH_MATCH_PHRASE';
    
    $tema = "tema@".$tema; #FIXME ES ASI????????????????????????
    
    my ($cantidad, $resultId1, $suggested) = C4::AR::Busquedas::busquedaCombinada_newTemp($tema, $session, $obj_for_log);



    return ($cantidad, $resultId1, $suggested); 
}

sub busquedaPorISBN{
    
    my ($isbn, $session, $obj_for_log) = @_;
    
    
    $obj_for_log->{'match_mode'} = 'SPH_MATCH_PHRASE';
    
    $isbn = "isbn@".$isbn;
    
    my ($cantidad, $resultId1, $suggested) = C4::AR::Busquedas::busquedaCombinada_newTemp($isbn, $session, $obj_for_log);
    

    return ($cantidad, $resultId1, $suggested); 
}

sub busquedaPorEstante{
    
    my ($estante, $session, $obj) = @_;
    my ($cantidad, $resultEstante) = C4::AR::Estantes::buscarEstante($estante,$obj->{'ini'},$obj->{'cantR'});
    return ($cantidad, $resultEstante, 0);  
}

sub busquedaEstanteDeGrupo{
    
    my ($id2, $session, $obj) = @_;
    my ($cantidad, $resultEstante) = C4::AR::Estantes::getEstantesById2($id2,$obj->{'ini'},$obj->{'cantR'});
    return ($cantidad, $resultEstante, 0);  
}

# TODO ver si se puede centralizar 
sub busquedaPorTitulo{
    my ($titulo) = @_;

    use Sphinx::Search;
    
    my $sphinx      = Sphinx::Search->new();
    my $query       = '@titulo '.$titulo;
    my $tipo        = 'SPH_MATCH_EXTENDED';
    my $tipo_match  = C4::AR::Utilidades::getSphinxMatchMode($tipo);

    $sphinx->SetMatchMode($tipo_match);

#     if ($orden eq 'autor'){
#             $sphinx->SetSortMode(SPH_SORT_ATTR_ASC,"autor");
#     }else{
#             $sphinx->SetSortMode(SPH_SORT_ATTR_ASC,"titulo_local");
#     }

    $sphinx->SetSortMode(SPH_SORT_RELEVANCE);
    $sphinx->SetEncoders(\&Encode::encode_utf8, \&Encode::decode_utf8);
    # NOTA: sphinx necesita el string decode_utf8
    my $index_to_use = C4::AR::Preferencias::getValorPreferencia("nombre_indice_sphinx") || 'test1';
    
    my $results = $sphinx->Query($query, $index_to_use);

    my @id1_array;
    my $matches                 = $results->{'matches'};
    my $total_found             = $results->{'total_found'};
#     C4::AR::Utilidades::printHASH($results);
    C4::AR::Debug::debug("C4::AR::Busqueda::busquedaPorTitulo => total_found: ".$total_found);
#     C4::AR::Debug::debug("Busquedas.pm => LAST ERROR: ".$sphinx->GetLastError());
    foreach my $hash (@$matches){
      my %hash_temp         = {};
      $hash_temp{'id1'}     = $hash->{'doc'};
      $hash_temp{'hits'}    = $hash->{'weight'};

      push (@id1_array, \%hash_temp);
    }

    return (scalar(@id1_array), \@id1_array);
}

sub busquedaPorAutor{
    my ($autor) = @_;

    use Sphinx::Search;

    my $sphinx      = Sphinx::Search->new();
    my $query       = '@autor '.$autor;
    my $tipo        = 'SPH_MATCH_EXTENDED';
    my $tipo_match  = C4::AR::Utilidades::getSphinxMatchMode($tipo);

    $sphinx->SetMatchMode($tipo_match);
    $sphinx->SetSortMode(SPH_SORT_RELEVANCE);
    $sphinx->SetEncoders(\&Encode::encode_utf8, \&Encode::decode_utf8);
    # NOTA: sphinx necesita el string decode_utf8
    my $index_to_use = C4::AR::Preferencias::getValorPreferencia("nombre_indice_sphinx") || 'test1';
    
    my $results = $sphinx->Query($query, $index_to_use);

    my @id1_array;
    my $matches                 = $results->{'matches'};
    my $total_found             = $results->{'total_found'};
#     C4::AR::Utilidades::printHASH($results);
    C4::AR::Debug::debug("C4::AR::Busqueda::busquedaPorAutor => total_found: ".$total_found);
#     C4::AR::Debug::debug("Busquedas.pm => LAST ERROR: ".$sphinx->GetLastError());
    foreach my $hash (@$matches){
      my %hash_temp         = {};
      $hash_temp{'id1'}     = $hash->{'doc'};
      $hash_temp{'hits'}    = $hash->{'weight'};

      push (@id1_array, \%hash_temp);
    }

    return (scalar(@id1_array), \@id1_array);
}


sub busquedaCombinada_ROSE{

    my ($string_utf8_encoded,$session,$obj_for_log,$sphinx_options) = @_;


    $string_utf8_encoded    = unac_string('utf8',$string_utf8_encoded);
    $session    =   $session || CGI::Session->load();
    
    my $from_suggested = $obj_for_log->{'from_suggested'} || 0;
    my @searchstring_array = C4::AR::Utilidades::obtenerBusquedas($string_utf8_encoded);
    my $string_suggested;
    my @filtros;    
    my $only_sphinx        = 0;
    my $only_available     = 0;
    
    if ($sphinx_options){
        $only_sphinx        = $sphinx_options->{'only_sphinx'} || 0;
        $only_available     = $sphinx_options->{'only_available'} || 0;
    }    
    my $sphinx = Sphinx::Search->new();
    my $ini    = $obj_for_log->{'ini'} || 0;
    my $cantR  = $obj_for_log->{'cantR'} || 0;

    if ($only_sphinx){
        if ($sphinx_options->{'report'}){ 
            $ini    = 0;
            $cantR  = 0;
       }
            
    }


    my $query = "";
    my @boolean_ops = ("&","|","!","-");
    my $tipo        = $obj_for_log->{'match_mode'}||'SPH_MATCH_ALL';
    my $orden       = $obj_for_log->{'orden'} || 'titulo';
    my $sentido_orden = $obj_for_log->{'sentido_orden'};

    my $tipo_match  = C4::AR::Utilidades::getSphinxMatchMode($tipo);

    C4::AR::Debug::debug("Busquedas _ busquedaCombinada_ROSE => match_mode ".$tipo);

    #se arma el query string
    foreach my $string (@searchstring_array){

        if($tipo eq 'SPH_MATCH_PHRASE'){
            push(@filtros, ( string => { like => '%'.$string.'%'}));
        } 
        elsif ($tipo eq 'SPH_MATCH_BOOLEAN'){
            if ($string eq "AND"){
                $string = " AND ";
            }elsif ($string eq "OR"){
                $string = "OR";
            }elsif ($string eq "NOT"){
                $string = "!";
            }
            push(@filtros, ( string => { like => $string.'%'}));
        }else{
            push(@filtros, ( string => { like => '%'.$string.'%'}));
        }
    }


   if ($only_available){
    push(@filtros, ( string => { like => '%'.' "ref_disponibilidad_code%'.C4::Modelo::RefDisponibilidad::paraPrestamoValue.'"'.'%'}));
   }

   my $busqueda_rose = C4::Modelo::IndiceBusqueda::Manager->get_indice_busqueda( query => \@filtros,
                                                                                  limit => $cantR,
                                                                                  offset => $ini,
                                                                                  sort_by => $orden,);



   my $total_found = C4::Modelo::IndiceBusqueda::Manager->get_indice_busqueda_count( query => \@filtros );


   my @id1_array;

    foreach my $hash (@$busqueda_rose){
        my %hash_temp = {};
        $hash_temp{'id1'} = $hash->id;
        push (@id1_array, \%hash_temp);
    }

    my ($total_found_paginado, $resultsarray) = C4::AR::Busquedas::armarInfoNivel1($obj_for_log, @id1_array);
    #se loquea la busqueda
    
    C4::AR::Busquedas::logBusqueda($obj_for_log, $session);

  
    return ($total_found, $resultsarray,$string_suggested);
}


sub busquedaCombinada_newTemp{

    my ($string_utf8_encoded,$session,$obj_for_log,$sphinx_options) = @_;

    use Sphinx::Search;

    # Se agregó para sacar los acentos y que no se mame el suggest, total es lo mismo porque
    # Sphinx busca con o sin acentos
    $string_utf8_encoded    = unac_string('utf8',$string_utf8_encoded);
    # no se encodea nunca a utf8 antes de llegar aca    
    # $string_utf8_encoded    = Encode::decode_utf8($string_utf8_encoded);
    # limpiamos puntuación
    $string_utf8_encoded    = C4::AR::Utilidades::cleanPunctuation($string_utf8_encoded);

    $session    =   $session || CGI::Session->load();
    
    my $from_suggested = $obj_for_log->{'from_suggested'} || 0;
    my @searchstring_array = C4::AR::Utilidades::obtenerBusquedas($string_utf8_encoded);
    my $string_suggested;
    
    my $only_sphinx        = 0;
    my $only_available     = 0;
    
    my $opac_only_state_available     = 0;

    if ($sphinx_options){
        $only_sphinx        = $sphinx_options->{'only_sphinx'} || 0;
        $only_available     = $sphinx_options->{'only_available'} || 0;
        $opac_only_state_available     = $sphinx_options->{'opac_only_state_available'} || 0;
    }    
    
    my $sphinx = Sphinx::Search->new();

    if ($only_sphinx){
        if ($sphinx_options->{'report'}){ 
        
            $sphinx->SetLimits($obj_for_log->{'ini'}, 100000);
 
       } else {
            $sphinx->SetLimits($obj_for_log->{'ini'}, C4::AR::Preferencias::getValorPreferencia('paginas'));  
       }
            
    }

    my $query = "";
    my @boolean_ops = ("&","|","!","-");
    my $tipo        = $obj_for_log->{'match_mode'}||'SPH_MATCH_ALL';
    my $orden       = $obj_for_log->{'orden'} || undef;
    my $sentido_orden = $obj_for_log->{'sentido_orden'};

    my $tipo_match  = C4::AR::Utilidades::getSphinxMatchMode($tipo);

    C4::AR::Debug::debug("Busquedas => match_mode ".$tipo);

    #se arma el query string
    foreach my $string (@searchstring_array){

        if($tipo eq 'SPH_MATCH_PHRASE'){
            $query .=  " '".$string."'";
        } 
        elsif ($tipo eq 'SPH_MATCH_BOOLEAN'){
            if ($string eq "AND"){
                $string = "&";
            }elsif ($string eq "OR"){
                $string = "|";
            }elsif ($string eq "NOT"){
                $string = "-";
            }
            if (C4::AR::Utilidades::existeInArray($string,@boolean_ops)){
               $query .=  " ".$string;
            }else{
               $query .=  " ".$string."*";
            }
        }else{
            $query .=  " *".$string."*";
        }
    }

    if( ($obj_for_log->{'tipo_nivel3_name'} ne "") && ($obj_for_log->{'tipo_nivel3_name'} ne "ALL") ){
        $query .= "  cat_ref_tipo_nivel3%".$obj_for_log->{'tipo_nivel3_name'};
    }

    if ($only_available){
        $query .= ' "ref_disponibilidad_code%'.C4::Modelo::RefDisponibilidad::paraPrestamoValue.'"';
    }

    if ($opac_only_state_available){
        # Se filtran los registros que posean algún ejemplar disponible o bien sean analíticas
        $query .= ' ("ref_estado_code%'.C4::Modelo::RefEstado::estadoDisponibleValue.'" | "cat_ref_tipo_nivel3%ANA" | "cat_ref_tipo_nivel3%ELE")';
        $tipo_match = C4::AR::Utilidades::getSphinxMatchMode('SPH_MATCH_BOOLEAN');
    }

    C4::AR::Debug::debug("Busquedas => query string ".$query);

    $sphinx->SetMatchMode($tipo_match);



    if ($orden eq 'autor') {
            if ($sentido_orden){
                $sphinx->SetSortMode(SPH_SORT_ATTR_DESC,"autor_local");
            } else {
                $sphinx->SetSortMode(SPH_SORT_ATTR_ASC,"autor_local");
            }
    } elsif ($orden eq 'titulo') {
            if ($sentido_orden){
                $sphinx->SetSortMode(SPH_SORT_ATTR_DESC,"titulo_local");
            } else {
                $sphinx->SetSortMode(SPH_SORT_ATTR_ASC,"titulo_local");
            }
    } else {
            $sphinx->SetSortMode(SPH_SORT_EXTENDED,"promoted DESC, hits DESC, titulo_local ASC");
    }

    $sphinx->SetEncoders(\&Encode::encode_utf8, \&Encode::decode_utf8);

    #FIX porque cuando viene 1, se saltea el primer resultado
    if ($obj_for_log->{'ini'}==1){
      $obj_for_log->{'ini'} = 0;
    }

    if (!$only_sphinx){
        $sphinx->SetLimits($obj_for_log->{'ini'}, $obj_for_log->{'cantR'},100000);
    }
  
    # C4::AR::Debug::debug("C4::AR::Busquedas::busquedaCombinada_newTemp => ini => ".$obj_for_log->{'ini'});
    # C4::AR::Debug::debug("C4::AR::Busquedas::busquedaCombinada_newTemp => cantR => ".$obj_for_log->{'cantR'});

    # NOTA: sphinx necesita el string decode_utf8
    
    my $index_to_use = C4::AR::Preferencias::getValorPreferencia("nombre_indice_sphinx") || 'test1';

=item
#NUEVO
    $sphinx->SetLimits( 0, 10, 10 );
    $sphinx->SetRankingMode( SPH_RANK_PROXIMITY_BM25 );
#FIN NUEVO
=cut
    my $results = $sphinx->Query($query, $index_to_use);

    my ($total_found_paginado, $resultsarray);
    my @id1_array;
    my $matches = $results->{'matches'};
    my $total_found = $results->{'total_found'};

    if ($only_sphinx){
        C4::AR::Debug::debug("total_found: ".$total_found);
        if ($sphinx->GetLastError()) {
            C4::AR::Debug::info( "Busquedas.pm => LAST ERROR: ".$sphinx->GetLastError() );
        } 
        return ($total_found,$matches);
    }
#arma y ordena el arreglo para enviar al cliente
    $obj_for_log->{'total_found'} = $total_found;
    C4::AR::Debug::debug("total_found: ".$total_found);
    C4::AR::Debug::info("Busquedas.pm => LAST ERROR: ".$sphinx->GetLastError());
    foreach my $hash (@$matches){
        my %hash_temp = {};
        $hash_temp{'id1'} = $hash->{'doc'};
        $hash_temp{'hits'} = $hash->{'weight'};
        push (@id1_array, \%hash_temp);
    }

    ($total_found_paginado, $resultsarray) = C4::AR::Busquedas::armarInfoNivel1($obj_for_log, @id1_array);
    #se loquea la busqueda
        
    if (!$obj_for_log->{'no_log_search'}){
        C4::AR::Busquedas::logBusqueda($obj_for_log, $session);
    }

    if ( (!$from_suggested) && ($total_found == 0) && ($tipo ne 'SPH_MATCH_PHRASE') ){
        $string_suggested = suggestion($string_utf8_encoded);
    }
    
  
    return ($total_found, $resultsarray,$string_suggested);
}

sub busquedaSinPaginar {

     my ($session,$obj) = @_;

     my %sphinx_options;
     

     
     my  ($total_found,$matches);
 
     C4::AR::Debug::debug("stringgg : ----------------------------------------------------------ffffffffffffffffffffffffffff----- : ".$obj->{'string'});

     if ($obj->{'tipoAccion'} eq "BUSQUEDA_COMBINABLE"){
                $sphinx_options{'only_sphinx'} = 1;
                $sphinx_options{'report'} = 1;
                $sphinx_options{'opac_only_state_available'} = $obj->{'opac_only_state_available'};
    
               ($total_found,$matches) = C4::AR::Busquedas::busquedaCombinada_newTemp($obj->{'string'},$session,$obj,\%sphinx_options);
      } else {
            $obj->{'only_sphinx'}=1;
            $obj->{'report'}=1;
     
            ($total_found,$matches) = C4::AR::Busquedas::busquedaAvanzada_newTemp($obj,$session);
      }
    

    my @id1_array=();

    C4::AR::Debug::debug("total_found SIN PAGINAR: ".$total_found);
    
   
    my ($total_found_paginado, $resultsarray);

    if ($obj->{'tipoAccion'} eq "BUSQUEDA_COMBINABLE"){
        foreach my $hash (@$matches){
              my %hash_temp = {};
              $hash_temp{'id1'} = $hash->{'doc'};
              $hash_temp{'hits'} = $hash->{'weight'};
              push (@id1_array, \%hash_temp);
        }
        ($total_found_paginado, $resultsarray) = C4::AR::Busquedas::armarInfoNivel1($obj, @id1_array);      
        C4::AR::Debug::debug("total_found_paginado: ".$total_found_paginado);
    } else  {
           $total_found_paginado=$total_found;
           $resultsarray= $matches; 
    }
        
  

    return ($total_found, $resultsarray);
}

sub toOAI{
    
    my ($resultId1)    = @_;
    use MARC::Crosswalk::DublinCore;
    use MARC::File::XML;

    my $dc_xml = C4::AR::Catalogacion::headerDCXML();
    
    foreach my $record (@$resultId1){
        my $crosswalk = MARC::Crosswalk::DublinCore->new;
        my $marc =  $record->{'marc_record'} ;
        my $dc;
        eval{
          # Convert a MARC record to Dublin Core (simple)
            $dc   = $crosswalk->as_dublincore( $marc );
        };
                
        $dc_xml .= C4::AR::Catalogacion::toOAIXML($dc,$record->{'id1'});
        
    }
    
    $dc_xml .= C4::AR::Catalogacion::footerDCXML();
    
    C4::AR::Debug::debug("XML DUBLINCORE DE LA BUSQUEDA: ");
    
    C4::AR::Debug::debug($dc_xml);
    
    return ($dc_xml);
}

sub armarInfoNivel1{
    my ($params, @resultId1)    = @_;

    use C4::AR::PortadaNivel2;

    my $tipo_nivel3_name        = $params->{'tipo_nivel3_name'};
    my $only_available          = $params->{'only_available'};
    my @result_array_paginado   = @resultId1;
    my $cant_total              = scalar(@resultId1);


    my @result_array_paginado_temp;

    for(my $i=0;$i<scalar(@result_array_paginado);$i++ ) {

        my $nivel1 = C4::AR::Nivel1::getNivel1FromId1(@result_array_paginado[$i]->{'id1'});

        if($nivel1){

        # TODO ver si esto se puede sacar del resultado del indice asi no tenemos q ir a buscarlo
            @result_array_paginado[$i]->{'titulo'}                      = $nivel1->getTituloStringEscaped();
            
            if ($params->{'isOAI_search'}){
                @result_array_paginado[$i]->{'marc_record'}             = $nivel1->toMARC_OAI();
            }

            @result_array_paginado[$i]->{'titulo'}              .= ($nivel1->getRestoDelTituloStringEscaped() ne "")?": ".$nivel1->getRestoDelTituloStringEscaped():"";
            my $autor_object                                            = $nivel1->getAutorObject();

            @result_array_paginado[$i]->{'nomCompleto'}                 = $nivel1->getAutorStringEscaped();
            @result_array_paginado[$i]->{'nomCompletoRegistroFuente'}   = $nivel1->getAutorStringEscaped();
            @result_array_paginado[$i]->{'idAutor'}                     = $autor_object->getId();
            @result_array_paginado[$i]->{'esta_en_favoritos'}           = C4::AR::Nivel1::estaEnFavoritos($nivel1->getId1());

            #aca se procesan solo los ids de nivel 1 que se van a mostrar
            #se generan los grupos para mostrar en el resultado de la consulta

            my $nivel2_array_ref    = C4::AR::Nivel2::getNivel2FromId1($nivel1->getId1);
            @result_array_paginado[$i]->{'signaturas'}          = $nivel1->getSignaturas($nivel2_array_ref);

            my $ediciones           = C4::AR::Busquedas::obtenerGrupos(@result_array_paginado[$i]->{'id1'}, $tipo_nivel3_name, "INTRA",$nivel2_array_ref);
            @result_array_paginado[$i]->{'grupos'} = 0;
            if(scalar(@$ediciones) > 0){
                @result_array_paginado[$i]->{'grupos'}  = $ediciones;
            }

            #se genera el estado de coleccion si se trata de revistas
                C4::AR::Debug::debug("REVISTA: se genera el estado de coleccion");
                my ($cant_revistas ,$estadoDeColeccion)           = C4::AR::Busquedas::obtenerEstadoDeColeccion(@result_array_paginado[$i]->{'id1'}, $tipo_nivel3_name, "INTRA",$nivel2_array_ref);
                @result_array_paginado[$i]->{'estadoDeColeccion'} = 0;
                if($cant_revistas > 0){
                    @result_array_paginado[$i]->{'estadoDeColeccion'}  = $estadoDeColeccion;
                }
            
                        
            @result_array_paginado[$i]->{'cat_ref_tipo_nivel3'}     = C4::AR::Nivel2::getFirstItemTypeFromN1($nivel1->getId1,$nivel2_array_ref);
            @result_array_paginado[$i]->{'cat_ref_tipo_nivel3_name'}= C4::AR::Referencias::translateTipoNivel3(@result_array_paginado[$i]->{'cat_ref_tipo_nivel3'});
            
            if (@result_array_paginado[$i]->{'cat_ref_tipo_nivel3'} eq "ANA"){

                my $cat_reg_analiticas_array_ref = C4::AR::Nivel2::getAllAnaliticasById1($nivel2_array_ref->[0]->getId1());

                if( ($cat_reg_analiticas_array_ref) && (scalar(@$cat_reg_analiticas_array_ref) > 0) ){
                    my $n2 = C4::AR::Nivel2::getNivel2FromId2($cat_reg_analiticas_array_ref->[0]->getId2Padre());

                    if($n2){
                        @result_array_paginado[$i]->{'autor_registro_padre'}        = $n2->nivel1->getAutorStringEscaped();
                        @result_array_paginado[$i]->{'nivel1_padre'}                = $n2->getId1();
                        @result_array_paginado[$i]->{'nivel2_padre'}                = $n2->getId2();
                        @result_array_paginado[$i]->{'tipo_documento_padre'}        = $n2->getTipoDocumentoObject->getNombre;
                        @result_array_paginado[$i]->{'titulo_registro_padre'}       = $n2->nivel1->getTituloStringEscaped();
                        @result_array_paginado[$i]->{'detalle_grupo_registro_padre'}= $n2->getDetalleGrupo();
                        @result_array_paginado[$i]->{'primer_signatura'}            = $n2->getSignaturas->[0];
                    }
                }
            }

            my @nivel2_portadas = ();
            my @nivel2_portadas_personalizadas = ();
            my $portadas_perzonalizadas_cant = 0;
            my $cant;

            if (scalar(@$nivel2_array_ref)){
                for(my $x=0;$x<scalar(@$nivel2_array_ref);$x++){
                    my %hash_nivel2 = {};
                    my $images_n2_hash_ref                      = $nivel2_array_ref->[$x]->getAllImage();
                    if ($images_n2_hash_ref){
                        $hash_nivel2{'portada_registro'}          =  $images_n2_hash_ref->{'S'};
                        $hash_nivel2{'portada_registro_medium'}   =  $images_n2_hash_ref->{'M'};
                        $hash_nivel2{'portada_registro_big'}      =  $images_n2_hash_ref->{'L'};
                        $hash_nivel2{'grupo'}                     =  $nivel2_array_ref->[$x]->getId2;

                        push(@nivel2_portadas, \%hash_nivel2);
                    }

                    my %hash_nivel2_portadas = {};
                    $cant = $nivel2_array_ref->[$x]->getCountPortadasEdicion($nivel2_array_ref->[$x]->getId2);
                    if ($cant){
                        $hash_nivel2_portadas{'portadas'}       =  $nivel2_array_ref->[$x]->getPortadasEdicion($nivel2_array_ref->[$x]->getId2);
                        push(@nivel2_portadas_personalizadas, \%hash_nivel2_portadas);
                        $portadas_perzonalizadas_cant = $portadas_perzonalizadas_cant + $cant;
                    }

                }

                @result_array_paginado[$i]->{'portadas_grupo'}  = \@nivel2_portadas;
                @result_array_paginado[$i]->{'portadas_grupo_cant'}  = scalar(@nivel2_portadas);
                @result_array_paginado[$i]->{'portadas_perzonalizadas_cant'}  = $portadas_perzonalizadas_cant;
                @result_array_paginado[$i]->{'portadas_perzonalizadas'}  = \@nivel2_portadas_personalizadas;
            }
            







            #se obtine la disponibilidad total 
            @result_array_paginado[$i]->{'rating'}              =  C4::AR::Nivel2::getRatingPromedio($nivel2_array_ref);

            my @disponibilidad = C4::AR::Busquedas::obtenerDisponibilidadTotal(@result_array_paginado[$i]->{'id1'}, $tipo_nivel3_name);
        
            @result_array_paginado[$i]->{'disponibilidad'}= 0;
          
            if (scalar(@disponibilidad) > 0){
                @result_array_paginado[$i]->{'disponibilidad'}  = \@disponibilidad;
            }

            push (@result_array_paginado_temp, @result_array_paginado[$i]);
        }
    }

    $cant_total             = scalar(@result_array_paginado_temp);
    @result_array_paginado  = @result_array_paginado_temp;


    return ($cant_total, \@result_array_paginado);
}

sub filtrarPorAutor{
    my ($params,$session) = @_;

    my $sphinx = Sphinx::Search->new();
    my $query = '';

#     if($params->{'titulo'} ne ""){
#         $query .= '@titulo '.$params->{'titulo'};
#         if($params->{'tipo'} eq "normal"){
#             $query .= "*";
#         }
#     }
# 
#     if($params->{'autor'} ne ""){
#         $query .= ' @autor '.$params->{'autor'};
#         if($params->{'tipo'} eq "normal"){
#             $query .= "*";
#         }
#     }
    $query = '@autor '.$params->{'completo'};
    C4::AR::Debug::debug("Busquedas => query string => ".$query);
#     C4::AR::Debug::debug("query string ".$query);
    my $tipo = 'SPH_MATCH_EXTENDED';
    my $tipo_match = C4::AR::Utilidades::getSphinxMatchMode($tipo);

    $sphinx->SetMatchMode($tipo_match);
    $sphinx->SetSortMode(SPH_SORT_RELEVANCE);
    $sphinx->SetEncoders(\&Encode::encode_utf8, \&Encode::decode_utf8);
    $sphinx->SetLimits($params->{'ini'}, $params->{'cantR'});
    # NOTA: sphinx necesita el string decode_utf8

    my $index_to_use = C4::AR::Preferencias::getValorPreferencia("nombre_indice_sphinx") || 'test1';
    
    my $results = $sphinx->Query($query,$index_to_use);

    my @id1_array;
    my $matches = $results->{'matches'};
    my $total_found = $results->{'total_found'};
    $params->{'total_found'} = $total_found;
#     C4::AR::Utilidades::printHASH($results);
    C4::AR::Debug::debug("total_found: ".$total_found);
#     C4::AR::Debug::debug("Busquedas.pm => LAST ERROR: ".$sphinx->GetLastError());
    foreach my $hash (@$matches){
      my %hash_temp = {};
      $hash_temp{'id1'} = $hash->{'doc'};
      $hash_temp{'hits'} = $hash->{'weight'};

      push (@id1_array, \%hash_temp);
    }

    my ($total_found_paginado, $resultsarray);
    #arma y ordena el arreglo para enviar al cliente
    ($total_found_paginado, $resultsarray) = C4::AR::Busquedas::armarInfoNivel1($params, @id1_array);
    #se loquea la busqueda
    C4::AR::Busquedas::logBusqueda($params, $session);

    return ($total_found, $resultsarray);
}


# DEPRECATED
# sub busquedaPorBarcode{
#     my ($string_utf8_encoded,$session,$obj_for_log) = @_;
# 
# 
#     my @id1_array;
#     my $nivel3 = C4::AR::Nivel3::getNivel3FromBarcode($string_utf8_encoded);
# 
#     if($nivel3){
#         my %hash_temp = {};
#         $hash_temp{'id1'} = $nivel3->getId1();
#         $hash_temp{'hits'} = undef;
# 
#         push (@id1_array, \%hash_temp);
#     }
# 
#     my ($total_found_paginado, $resultsarray);
#     #arma y ordena el arreglo para enviar al cliente
#     ($total_found_paginado, $resultsarray) = C4::AR::Busquedas::armarInfoNivel1($obj_for_log, @id1_array);
#     #se loquea la busqueda
#     C4::AR::Busquedas::logBusqueda($obj_for_log, $session);
# 
#     return ($total_found_paginado, $resultsarray);
# }

sub busquedaPorBarcodeBySphinx{
    
    my ($barcode, $session, $obj_for_log) = @_;
    
    
    #$obj_for_log->{'match_mode'} = 'SPH_MATCH_PHRASE';
    
    
    my ($cantidad, $resultId1, $suggested) = C4::AR::Busquedas::busquedaCombinada_newTemp($barcode, $session, $obj_for_log, 0);
    

    return ($cantidad, $resultId1, $suggested); 
}



# TODO 
# sub busquedaSignaturaBetween{
# 
#     my ($obj) = @_;
# 
#     my $min= $obj->{'desde_signatura'};
#     my $max= $obj->{'hasta_signatura'};
# 
#     C4::AR::Debug::debug("---------------------------HOLAGOLAGOALFSADOFD---------------------------");
# 
#     use Sphinx::Search;
#     
#     my $sphinx  = Sphinx::Search->new();
#     my $query   = '';
#     my $tipo    = 'SPH_MATCH_PHRASE';
# #     my $orden   = $params->{'orden'};
#    
#     $query .= ' @string "'.$min.'"';
#     
# #     $sphinx->SetLimits($params->{'ini'}, $params->{'cantR'});
#     $sphinx->SetEncoders(\&Encode::encode_utf8, \&Encode::decode_utf8);
# #     $sphinx->SetIDRange($min, $max);
#     
#     # NOTA: sphinx necesita el string decode_utf8
#    
#     my $results = $sphinx->Query($query);
#  
#     C4::AR::Utilidades::printHASH($results);
# 
#     my $matches = $results->{'matches'};
#     my $total_found = $results->{'total_found'};
#   
# 
#     C4::AR::Debug::debug("TOTAL FOUND".$total_found);
# 
#     return ($total_found, $results );
# 
# }




sub t_loguearBusqueda {
    my($nro_socio,$desde,$http_user_agent,$search_array)=@_;
    my $msg_object= C4::AR::Mensajes::create();
    $desde = $desde || 'SIN_TIPO';
    my $historial = C4::Modelo::RepHistorialBusqueda->new();
    my $db = $historial->db;
    my $msg_object= C4::AR::Mensajes::create();
    $db->{connect_options}->{AutoCommit} = 0;
    #eval {
        $historial->agregar($nro_socio,$desde,$http_user_agent,$search_array);
        $db->commit;
    #};

    if ($@){
        #Se loguea error de Base de Datos
        #Se setea error para el usuario
        &C4::AR::Mensajes::printErrorDB($@, 'B407',"INTRA");
        $msg_object->{'error'}= 1;
        #no se debe informar nada al usuario, no debería saber de esto      
#         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'R011', 'params' => []} ) ;        
        $db->rollback;
    }
    $db->{connect_options}->{AutoCommit} = 1;
    return ($msg_object);
}


sub logBusqueda{
    my ($params,$session) = @_;
    #esta funcion loguea las busquedas relizadas desde la INTRA u OPAC si:
    #la preferencia del OPAC es 1 y estoy buscando desde OPAC  
    #la preferencia de la INTRA es 1 y estoy buscando desde la INTRA

    my @search_array;
    my $valorOPAC= C4::AR::Preferencias::getValorPreferencia("logSearchOPAC");
    my $valorINTRA= C4::AR::Preferencias::getValorPreferencia("logSearchINTRA");

    $session = $session || CGI::Session->load();
 
    
    if( (($valorOPAC == 1)&&($params->{'type'} eq 'OPAC')) || (($valorINTRA == 1)&&($params->{'type'} eq 'INTRA')) ){
       
        if($params->{'codBarra'} ne ""){
            my $search;
            $search->{'barcode'}= $params->{'codBarra'};
            push (@search_array, $search);
        }

        if($params->{'autor'} ne ""){
            my $search;
            $search->{'autor'}= $params->{'autor'};
            push (@search_array, $search);
        }
    
        if($params->{'titulo'} ne ""){
            my $search;
            $search->{'titulo'}= $params->{'titulo'};
            push(@search_array, $search);
        }
    
        if($params->{'tipo_nivel3_name'} != -1 && $params->{'tipo_nivel3_name'} ne ""){
            my $search;
            $search->{'tipo_documento'}= $params->{'tipo_nivel3_name'};
            push (@search_array, $search);
        }

      
        if($params->{'keyword'} != -1 && $params->{'keyword'} ne ""){
            my $search;
            $search->{'keyword'}= $params->{'keyword'};
            push (@search_array, $search);
        }

        if($params->{'isbn'} ne ""){
            my $search;
            $search->{'isbn'}= $params->{'isbn'};
            push (@search_array, $search);
        }

        if($params->{'tema'} ne ""){
            my $search;
            $search->{'tema'}= $params->{'tema'};
            push (@search_array, $search);
        }

        if($params->{'signatura'} ne ""){
            my $search;
            $search->{'signatura'}= $params->{'signatura'};
            push (@search_array, $search);
        }

        if($params->{'filtrarPorAutor'} ne ""){
            my $search;
            $search->{'filtrarPorAutor'}= $params->{'filtrarPorAutor'};
            push(@search_array, $search);
        }
    }

    my ($error, $codMsg, $message)= C4::AR::Busquedas::t_loguearBusqueda(
                                        $session->param('nro_socio'),
                                        $params->{'type'},
                                        $session->param('browser'),
                                        \@search_array
                                        );
}


=item
Esta funcion arma el string para mostrar en el cliente lo que a buscado, 
ademas escapa para evitar XSS
=cut
sub armarBuscoPor{
    my ($params) = @_;
    
    my $buscoPor="";
    my $str;

    if(C4::AR::Utilidades::validateString($params->{'keyword'})){
        $str      = C4::AR::Utilidades::verificarValor($params->{'keyword'});
        $buscoPor.= $str."&";
    }

    if( $params->{'tipo_nivel3_name'} != -1 &&  C4::AR::Utilidades::validateString($params->{'tipo_nivel3_name'})){
        if ($params->{'tipo_nivel3_name'} eq 'ALL'){
            $buscoPor.= C4::AR::Utilidades::verificarValor(C4::AR::Filtros::i18n("TODOS"))."&";
        }else{
            $buscoPor.= Encode::decode_utf8((C4::AR::Utilidades::verificarValor(C4::AR::Referencias::translateTipoNivel3($params->{'tipo_nivel3_name'}))."&"));
        }
    }

    if( C4::AR::Utilidades::validateString($params->{'titulo'})){
        $buscoPor.= ($params->{'titulo'})."&";  
    }
    
    if( C4::AR::Utilidades::validateString($params->{'completo'})){
        $buscoPor.= (C4::AR::Filtros::i18n("Autor").": ".$params->{'completo'})."&";
    }

    if( C4::AR::Utilidades::validateString($params->{'autor'})){
        $buscoPor.= (C4::AR::Filtros::i18n("Autor").": ".$params->{'autor'})."&";
    }

    if( C4::AR::Utilidades::validateString($params->{'signatura'})){
        $buscoPor.= (C4::AR::Filtros::i18n("Signatura").": ".$params->{'signatura'})."&";
    }

    if( C4::AR::Utilidades::validateString($params->{'isbn'})){
        $buscoPor.= "ISBN: ".($params->{'isbn'})."&";
    }       

    if( C4::AR::Utilidades::validateString($params->{'tema'})){
        $buscoPor.= "Tema: ".($params->{'tema'})."&";
    }       

    if( C4::AR::Utilidades::validateString($params->{'estante'})){
        $buscoPor.= "Estantes Virtuales: ".($params->{'estante'})."&";
    }   
    if( C4::AR::Utilidades::validateString($params->{'estantes'})){
        $buscoPor.= "Estantes Virtuales: ".($params->{'estantes'})."&";
    }

    if( C4::AR::Utilidades::validateString($params->{'estantes_grupo'})){
        $buscoPor.= "Estantes virtuales de: ".($params->{'titulo_nivel_1'})."&";
    }   

    if( C4::AR::Utilidades::validateString($params->{'codBarra'})){
        $buscoPor.= Encode::decode_utf8((C4::AR::Filtros::i18n("Barcode").": ".$params->{'codBarra'}))."&";
    }       

    if( C4::AR::Utilidades::validateString($params->{'date_begin'})){
        $buscoPor.= Encode::decode_utf8(C4::AR::Filtros::i18n("desde")." ".$params->{'date_begin'})."&";  
    }
    
    if( C4::AR::Utilidades::validateString($params->{'date_end'})){
        $buscoPor.= Encode::decode_utf8(C4::AR::Filtros::i18n("hasta")." ".$params->{'date_end'})."&";  
    }

    if(($params->{'only_available'})){
        $buscoPor.= C4::AR::Filtros::i18n("Solo disponibles")."&";  
    }

    my @busqueda    = split(/&/,$buscoPor);
    $buscoPor       = " ";
    
    foreach my $str (@busqueda){
        $buscoPor.=", ".$str;
    }
    
    $buscoPor = substr($buscoPor,2,length($buscoPor));

    return $buscoPor;
}


#*****************************************Soporte MARC************************************************************************
#devuelve toda la info en MARC de un item (id3 de nivel 3)
sub MARCRecordById3 {
    my ($id3)= @_;

        my $nivel3= C4::AR::Nivel3::getNivel3FromId3($id3);
        my $marc_record = MARC::Record->new_from_usmarc($nivel3->nivel1->getMarcRecord());
        $marc_record->append_fields(MARC::Record->new_from_usmarc($nivel3->nivel2->getMarcRecord())->fields());
        
        ##Agregamos el indice
        if ($nivel3->nivel2->tiene_indice){
            $marc_record->append_fields(MARC::Field->new(865, '', '', 'a' => $nivel3->nivel2->getIndice));
        }
        
        $marc_record->append_fields(MARC::Record->new_from_usmarc($nivel3->getMarcRecord())->fields());
    return $marc_record;
}

sub MARCRecordById3WithReferences {
    my ($id3)= @_;

    my $marc_record = C4::AR::Busquedas::MARCRecordById3($id3);
    
    my $tipo_doc    = C4::AR::Catalogacion::getRefFromStringConArrobas($marc_record->subfield("910","a"));
    foreach my $field ($marc_record->fields) {
        if(! $field->is_control_field){
            my $campo                       = $field->tag;
            my $indicador_primario_dato     = $field->indicator(1);
            my $indicador_secundario_dato   = $field->indicator(2);
            foreach my $subfield ($field->subfields()) {
                my $subcampo                        = $subfield->[0];
                my $dato                            = $subfield->[1];
                my $nivel                           = C4::AR::EstructuraCatalogacionBase::getNivelFromEstructuraBaseByCampoSubcampo($campo, $subcampo);
                if (C4::AR::Utilidades::trim($dato) ne ''){
                    $dato                           = C4::AR::Catalogacion::getRefFromStringConArrobasByCampoSubcampo($campo, $subcampo, $dato, $tipo_doc,$nivel);
                    my $datoFinal= C4::AR::Catalogacion::getDatoFromReferencia($campo, $subcampo, $dato,$tipo_doc,$nivel);
                    if($datoFinal){
                        $field->update( $subcampo => $datoFinal);
                    }
                }
            }
        }
    }
    return $marc_record;
}


sub MARCDetail{
    my ($id3,$tipo)= @_;

    my @MARC_result;
    my $marc_array_nivel1;
    my $marc_array_nivel2;
    my $marc_array_nivel3;

    my $nivel3_object= C4::AR::Nivel3::getNivel3FromId3($id3);


    if($nivel3_object ne 0){
        ($marc_array_nivel3)= $nivel3_object->toMARC;
    }
    if($nivel3_object->nivel2){
        ($marc_array_nivel2)= $nivel3_object->nivel2->toMARC;
    }
    if($nivel3_object->nivel1){
        ($marc_array_nivel1)= $nivel3_object->nivel1->toMARC;
    }

    my @result;
    push(@result, @$marc_array_nivel1);
    push(@result, @$marc_array_nivel2);
    push(@result, @$marc_array_nivel3);
    
    my @MARC_result_array;
# FIXME no es muy eficiente pero funciona, ver si se puede mejorar, orden cuadrado
    
    for(my $i=0; $i< scalar(@result); $i++){
        my %hash;   
        my $campo= @result[$i]->{'campo'};
        my @info_campo_array;
        C4::AR::Debug::debug("Proceso todos los subcampos del campo: ".$campo);
    #   if(!_existeEnArregloDeCampoMARC(\@MARC_result_array, $campo) ){
            #proceso todos los subcampos del campo
        my $subcampos=$result[$i]->{'subcampos_array'};
            for(my $j=0;$j < @$subcampos;$j++){
                if(C4::AR::Utilidades::trim($subcampos->[$j]{'dato'})){
                    my %hash_temp;
                    $hash_temp{'subcampo'}= $subcampos->[$j]{'subcampo'};
                    $hash_temp{'liblibrarian'}= $subcampos->[$j]{'liblibrarian'};
                    $hash_temp{'dato'}= $subcampos->[$j]{'dato'};
                    push(@info_campo_array, \%hash_temp);
                    C4::AR::Debug::debug("campo, subcampo, dato: ".$result[$i]->{'campo'}.", ".$subcampos->[$j]{'subcampo'}.", ".$subcampos->[$j]{'liblibrarian'});
                }
            }
            if(scalar(@info_campo_array)){
                $hash{'campo'}= $campo;
                $hash{'header'}= @result[$i]->{'header'};
                $hash{'info_campo_array'}= \@info_campo_array;
                push(@MARC_result_array, \%hash);
    #           C4::AR::Debug::debug("campo: ".$campo);
                C4::AR::Debug::debug("cant subcampos: ".scalar(@info_campo_array));
            }
        #}
    }

    #EL INDICE. Hay que ver si se puede subir, asi no queda desordenado. 
    if($nivel3_object->nivel2->tiene_indice){
        my %hash;
        my @info_campo_array;
        my %hash_temp;
        $hash_temp{'subcampo'}= 'a';
        $hash_temp{'liblibrarian'}= 'Índice';
        $hash_temp{'dato'}= $nivel3_object->nivel2->getIndice;
        push(@info_campo_array, \%hash_temp);
        $hash{'campo'}= '865';
        $hash{'header'}= 'Índice';
        $hash{'info_campo_array'}= \@info_campo_array;
        push(@MARC_result_array, \%hash);
    }
    
    return (\@MARC_result_array);
    
}

=item
Verifica si existe en el arreglo de campos el campo pasado por parametro
=cut
sub _existeEnArregloDeCampoMARC{
    my ($array, $campo)= @_;

    for(my $j=0;$j < scalar(@$array);$j++){

        if($array->[$j]->{'campo'} eq $campo){
            return 1;
        }
    }

    return 0;
}


=item sub getRegistrosFromRange

Retorna todos los registros que se encuentran dentro del rango [$biblio_ini, $biblio_fin]
=cut
sub getRegistrosFromRange {
    my ($params, $cgi ) = @_;

    my $resultsarray;
    my $sphinx  = Sphinx::Search->new();
    my $query   = '';

    if ($cgi->param('tipo_nivel3_name') ne "") {
        #filtro por tipo de ejemplar
        $query .= " cat_ref_tipo_nivel3@".$cgi->param('tipo_nivel3_name');
    } 

    if ($cgi->param('name_nivel_bibliografico') ne "") {
        #filtro por el nivel bibliográfico
        $query .= " ref_nivel_bibliografico@".$cgi->param('name_nivel_bibliografico');
    } 

    if ($cgi->param('name_ui') ne "") {
        #filtro por homebranch
        $query .= " pref_unidad_informacion@".$cgi->param('name_ui');
    } 

    my $tipo = 'SPH_MATCH_EXTENDED';
    my $tipo_match = C4::AR::Utilidades::getSphinxMatchMode($tipo);

    $sphinx->SetMatchMode($tipo_match);
    $sphinx->SetSortMode(SPH_SORT_RELEVANCE);
    $sphinx->SetEncoders(\&Encode::encode_utf8, \&Encode::decode_utf8);
    # $sphinx->SetLimits($params->{'ini'}, $params->{'cantR'});
    # NOTA: sphinx necesita el string decode_utf8
    C4::AR::Debug::debug("Busquedas.pm => query: ".$query);
    my $index_to_use = C4::AR::Preferencias::getValorPreferencia("nombre_indice_sphinx") || 'test1';
    
    my $results = $sphinx->Query($query, $index_to_use);

    my @id1_array;
    my @id1_array_aux;
    my $matches                 = $results->{'matches'};
    my $total_found             = $results->{'total_found'};
    $params->{'total_found'}    = $total_found;

    #C4::AR::Debug::debug("Busquedas.pm => total_found: ".$total_found);
    #C4::AR::Debug::debug("Busquedas.pm => LAST ERROR: ".$sphinx->GetLastError());
    foreach my $hash (@$matches) {
        push (@id1_array, $hash->{'doc'});
    }

    if ($cgi->param('limit') ne "") {
        #muesrto los primeros "limit" registros
        @id1_array = @id1_array[0..$cgi->param('limit') - 1];
    }   

    if ( ($cgi->param('biblio_ini') ne "") && ($cgi->param('biblio_fin') ne "") ){
        #filtro por rango de id1
        foreach my $id1 (@id1_array) {
            if( ($id1 >= $cgi->param('biblio_ini')) && ( $id1 <= $cgi->param('biblio_fin')) ){

                push (@id1_array_aux, $id1);
            }
        }

        @id1_array = @id1_array_aux;
    }
    

    C4::AR::Debug::debug("Busquedas.pm => TOTAL FINAL =============== : ".scalar(@id1_array));

    return (scalar(@id1_array), \@id1_array);
}

sub cantServidoresExternos{
    return (C4::Modelo::SysExternosMeran::Manager->get_sys_externos_meran_count());
}

sub getServidoresExternos{
    return (C4::Modelo::SysExternosMeran::Manager->get_sys_externos_meran(require_objects => ['ui'],));
}






#***************************************Fin**Soporte MARC*********************************************************************


1;
