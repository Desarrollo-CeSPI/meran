# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2015 Grupo de desarrollo de Meran CeSPI-UNLP
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

package C4::AR::ImportacionIsoMARC;

#
#para la importacion de codigos iso a marc y donde estan las descripciones de cada campo y sus
#subcampos
#

use strict;
require Exporter;

use C4::Context;
use Date::Manip;
use C4::AR::Utilidades;
use C4::Modelo::IoImportacionIso;
use C4::Modelo::IoImportacionIsoRegistro;


use MARC::Record;
use MARC::Field;
use C4::AR::BackgroundJob;

use MARC::Moose::Record;

#use MARC::Moose::Reader::File::Iso2709;
use MARC::Moose::Reader::File::Isis;
#use MARC::Moose::Reader::File::Marcxml;
use MARC::Moose::Formater::Iso2709;


use Spreadsheet::Read;

use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw(
           guardarNuevaImportacion
           getImportaciones
           eliminarImportacion
           getImportacionById
           getImportacionLike
           getEsquema
           getRow
           editarValorEsquema
           addCampo
           cancelarImportacion
);

=item sub guardarNuevaImportacion
Guarda una nueva imporatción
=cut
sub guardarNuevaImportacion {
    my ($params,$msg_object) = @_;

    my $db =  C4::Modelo::IoImportacionIso->new()->db;
       $db->{connect_options}->{AutoCommit} = 0;
       $db->begin_work;


    my $Io_importacion = C4::Modelo::IoImportacionIso->new(db=> $db);
    my $nuevo_esquema =0;
    #Si el esquema es nuevo hay que crearlo vacio al menos!

    C4::AR::Debug::debug("Nuevo esquema?? ".$params->{'nuevo_esquema'}." o usamos uno existente: ". $params->{'esquemaImportacion'});

    if (!$params->{'nombreEsquema'}) {
        $params->{'esquemaImportacion'} = $params->{'esquemaImportacion'};
        }
    else{
        if($params->{'nuevo_esquema'}){
           #Crear Nuevo Esquema
               my %parametros;
               $parametros{'nombre'}      = $params->{'nombreEsquema'};
               $parametros{'descripcion'}   = 'Esquema generado';
               $nuevo_esquema = C4::Modelo::IoImportacionIsoEsquema->new(db=> $db);
               $nuevo_esquema->agregar(\%parametros);

           #Necesitamos el id del nuevo esquema ACA!
               $params->{'esquemaImportacion'}     = $nuevo_esquema->getId;
            }
    }

    $Io_importacion->agregar($params);

    C4::AR::Debug::debug("Obtener Campos !!");

    # MARC pasa 1 a 1
    if ($params->{'esquemaImportacion'} ne 'MARC') {
        #Obtengo los campos/subcampos para ver si por si es necesario realizar un corrimiento de campos
         my $campos_archivo = C4::AR::ImportacionIsoMARC::obtenerCamposDeArchivo($params);
         $params->{'camposArchivo'}     = $campos_archivo;
         my %camposMovidos;
         $params->{'camposMovidos'}     = \%camposMovidos;
    }

    C4::AR::Debug::debug("Guardar Registros !!");

    #Ahora los registros del archivo $params->{'write_file'}
    C4::AR::ImportacionIsoMARC::guardarRegistrosNuevaImportacion($Io_importacion,$params,$msg_object,$db);

    C4::AR::Debug::debug("Nuevo Esquma !!");

    #Si el esquema es nuevo hay que llenarlo con los datos de los registros cargados
    if($params->{'nuevo_esquema'}){
       #Armar nuevo esquema (hash de hashes)
        my $detalle_esquema = $Io_importacion->obtenerCamposSubcamposDeRegistros();

        my $total = 0;
        my $actual = 0;
        foreach my $campo ( keys %$detalle_esquema) {
            foreach my $subcampo ( keys %{$detalle_esquema->{$campo}}) {
                $actual++;
                my $nuevo_esquema_detalle          = C4::Modelo::IoImportacionIsoEsquemaDetalle->new(db=>$db);
                my %detalle=();
                $detalle{'campo'}=$campo;
                $detalle{'subcampo'}=$subcampo;
                $detalle{'id_importacion_esquema'}=$nuevo_esquema->getId;
                $nuevo_esquema_detalle->agregar(\%detalle);

                C4::AR::Utilidades::printAjaxPercent($total,$actual);
            }
        }
    }

    $db->commit;

     if ($@){
        #Se loguea error de Base de Datos
        &C4::AR::Mensajes::printErrorDB($@, 'B456',"INTRA");
        eval {$db->rollback};
        #Se setea error para el usuario
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO08', 'params' => []} );
      }

    $db->{connect_options}->{AutoCommit} = 1;
}

=item sub releerEsquemaDeRegistros
Relee el esquema a partir de los Registros de una importación
=cut

sub releerEsquemaDeRegistrosDeImportacion {
    my ($id) = @_;

    my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id);

    #Limpio el detalle del Esquema
    foreach my $detalle_esquema ($importacion->esquema->detalle){
        $detalle_esquema->delete();
    }

    #Armar nuevo esquema (hash de hashes)
    my $detalle_esquema = $importacion->obtenerCamposSubcamposDeRegistros();

    foreach my $campo ( keys %$detalle_esquema) {
        foreach my $subcampo ( keys %{$detalle_esquema->{$campo}}) {
            my $nuevo_esquema_detalle          = C4::Modelo::IoImportacionIsoEsquemaDetalle->new();
            my %detalle=();
            $detalle{'campo'}=$campo;
            $detalle{'subcampo'}=$subcampo;
            $detalle{'id_importacion_esquema'} = $importacion->getEsquema();
            $nuevo_esquema_detalle->agregar(\%detalle);
        }
    }
}

=item sub guardarRegistrosNuevaImportacion
Guarda los registros de una nueva imporatción
=cut
sub guardarRegistrosNuevaImportacion {
    my ($importacion,$params,$msg_object,$db) = @_;


    if($params->{'formatoImportacion'} eq "xls"){
        #ES UNA PLANILLA DE CALCULO

        # NO HAY CAMPOS Y SUBCAMPOS
        # Los campo se van a ir agregando a partir del 100 en adelante con subcampo a
        my $campo = 100;
        my $subcampo = 'a';

        my $ref = Spreadsheet::Read::ReadData($params->{'write_file'}, parser => $params->{'file_ext'} , dtfmt => "dd/mm/yyyy");

        #my @rows = Spreadsheet::Read::rows($ref->[1]);

        my $primera_fila = $params->{'xls_first'};
        C4::AR::Debug::debug( "PRIMERA FILA?? ". $primera_fila);

        my $ss = $ref->[1];
        foreach my $row (1 .. $ss->{maxrow}) {
            
            my @fila = Spreadsheet::Read::row($ss,$row);
            
            if(!$primera_fila){
                my $marc_record = MARC::Record->new();
                my $campo = 100;
                my $subcampo='a';
                foreach my $dato (@fila){

                    my $dato_fila = C4::AR::Utilidades::trim($dato);

                    $dato_fila = Encode::decode_utf8(Encode::encode_utf8($dato_fila));

                    if($dato_fila ne ''){
                        C4::AR::Debug::debug( "LEO EXCEL!!! campo: ". $campo." => dato: ".$dato_fila);
                        my $new_field= MARC::Field->new($campo,'#','#',$subcampo => $dato_fila);
                        $marc_record->append_fields($new_field);
                    }

                    $campo++;
                    }

                my %parametros;
                $parametros{'id_importacion_iso'}   = $importacion->getId;
                $parametros{'marc_record'}          = $marc_record->as_usmarc();
                my $Io_registro_importacion         = C4::Modelo::IoImportacionIsoRegistro->new(db => $db);
                $Io_registro_importacion->agregar(\%parametros);

            }else{
                $primera_fila=0;
            }
        }

    }
    else {
        #ES UN ISO

    use Switch;
    my $reader;
    switch ($params->{'formatoImportacion'}) {
        case "iso"   {$reader=MARC::Moose::Reader::File::Iso2709->new(file   => $params->{'write_file'})}
        case "isis"  {$reader=MARC::Moose::Reader::File::Isis->new(file   => $params->{'write_file'})}
        case "xml"   {$reader=MARC::Moose::Reader::File::Marcxml->new(file   => $params->{'write_file'})}
    }

#Leemos los registros armamos el Marc::Record
    while ( my $record = $reader->read() ) {
    eval {
         my $marc_record = MARC::Record->new();
         my $registro_erroneo=0;
         for my $field ( @{$record->fields} ) {
             my $new_field=0;
             if ($field->tag < '010'){next;}
             if(($field->tag < '010')&&(!$field->{'subf'})){
                 #CONTROL FIELD
                 $new_field = MARC::Field->new( $field->tag, $field->{'value'} );
                 }
                 else {
                    for my $subfield ( @{$field->subf} ) {

                        if(!$new_field){
                            my $ind1=$field->ind1?$field->ind1:'#';
                            my $ind2=$field->ind2?$field->ind2:'#';
                            my $campo = $field->tag;
                            #Si es un campo de CONTROL pero tiene SUBCAMPOS hay que moverlo a un 900 para que no se pierdan los datos.
                             if(($field->tag < '010')&&($field->{'subf'})){
                                 #Empiezo viendo a partir de los campos 900 (son solo 10 los de control!!!)
                                my $movidos =$params->{'camposMovidos'};
                                my $campos =$params->{'camposArchivo'};

                                if($movidos->{$campo}){
                                    #ya fue movido?
                                    $campo=$movidos->{$campo};
                                 }
                                 else{
                                     #hay que moverlo
                                     $campo+=900;
                                     while (($campos->{$campo}) && ($campo <= 999)){
                                         C4::AR::Debug::debug("Campo ".$campo." ==> ".$campos->{$campo});
                                         $campo++;
                                        }
                                        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO017', 'params' => [$field->tag,$campo]});
                                      #lo marco como movido y utilizado
                                     $movidos->{$field->tag}=$campo;
                                     $campos->{$campo}=1;
                                }
                             }

                            $new_field= MARC::Field->new($campo, $ind1, $ind2,$subfield->[0] => $subfield->[1]);
                            }
                        else{
                            $new_field->add_subfields( $subfield->[0] => $subfield->[1] );
                        }

                       if($subfield->[1] =~ m/\x1e/g){
                          #Encuentro un delimitador en un campo de texto, algo está mal, REGISTRO ERRONEO
                          $registro_erroneo=1;
                        }

                    }
                }
             if($new_field){
                $marc_record->append_fields($new_field);
             }
         }

            C4::AR::Debug::debug($marc_record->as_usmarc());

            my %parametros;
            $parametros{'id_importacion_iso'}      = $importacion->getId;
            $parametros{'marc_record'}   = $marc_record->as_usmarc();
            if ($registro_erroneo) {
              $parametros{'estado'}   = "ERROR";
            }

            my $Io_registro_importacion          = C4::Modelo::IoImportacionIsoRegistro->new(db => $db);
            $Io_registro_importacion->agregar(\%parametros);

      };

     if ($@){
         #Se loguea error de Base de Datos
         &C4::AR::Mensajes::printErrorDB($@, 'B455','INTRA');
         #Se setea error para el usuario
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO04', 'params' => []} ) ;
     }

    } # WHILE  ( my $record = $reader->read()
  } # IF EXCEL
}

=item sub getImportaciones
obtiene las importaciones
=cut
sub getImportaciones {
    require C4::Modelo::IoImportacionIso;
    require C4::Modelo::IoImportacionIso::Manager;

    my $importaciones = C4::Modelo::IoImportacionIso::Manager->get_io_importacion_iso(sort_by => ['fecha_upload DESC']);
    my @importaciones;

    foreach my $importacion (@$importaciones){
        push (@importaciones, $importacion);
    }

    return (\@importaciones);
}

=item sub getRegistrosFromImportacion
Se obtienen los registros de la importacion
=cut
sub getRegistrosFromImportacion {

    my ($id_importacion,$filter,$ini,$cantR,$search,$db) = @_;

    require C4::Modelo::IoImportacionIsoRegistro;
    require C4::Modelo::IoImportacionIsoRegistro::Manager;
    $db = $db || C4::Modelo::IoImportacionIsoRegistro->new()->db;

    my @filtros;
    push (@filtros, ( id_importacion_iso => { eq => $id_importacion}));

    if ($search){
        push (@filtros, ( marc_record => { like => '%'.$search.'%'}));

    }

    if((!$filter)||($filter eq 'MAIN')){
        #Solo registros padre por defecto
        push (@filtros, ( relacion => { eq => '' }));
        }
    elsif($filter eq 'UNIDENTIFIED'){
        push (@filtros, ( identificacion => { eq => undef }));
        }
    elsif($filter eq 'MATCH'){
        push (@filtros, ( matching => { eq => 1 }));
        }
    elsif($filter eq 'IGNORED'){
        push (@filtros, ( or => [ estado => { eq => 'IGNORADO' }, estado => { eq => 'ERROR' }]));
        }
    elsif($filter eq 'ALL'){
        #si se muestran todos no se agregan mas filtros
        }


    my $registros_array_ref;

    if($cantR eq 'ALL'){

     $registros_array_ref= C4::Modelo::IoImportacionIsoRegistro::Manager->get_io_importacion_iso_registro(  db              => $db,
                                                                                                    query => \@filtros,
                                                                                                    with_objects    => [ 'ref_importacion', 'ref_importacion.esquema'],
                                                                                                    );
     }else{
     $registros_array_ref= C4::Modelo::IoImportacionIsoRegistro::Manager->get_io_importacion_iso_registro(  db              => $db,
                                                                                                    query => \@filtros,
                                                                                                    limit   => $cantR,
                                                                                                    offset  => $ini,
                                                                                                    with_objects    => [ 'ref_importacion', 'ref_importacion.esquema' ],
                                                                                                        );

     }

    #Obtengo la cantidad total de registros de la importacion para el paginador
    my $registros_array_ref_count = C4::Modelo::IoImportacionIsoRegistro::Manager->get_io_importacion_iso_registro_count(  db  => $db,
                                                                                                                        query => \@filtros);

    if(scalar(@$registros_array_ref) > 0){
        return ($registros_array_ref_count, $registros_array_ref, $registros_array_ref->[0]->ref_importacion->esquema->id);
    }else{
        return (0,0);
    }

}

=item
     Esta funcion devuelve un registro de importacion segun su id
=cut
sub getRegistroFromImportacionById {
    my ($id) = @_;

    require C4::Modelo::IoImportacionIsoRegistro;
    require C4::Modelo::IoImportacionIsoRegistro::Manager;

    my $registroImportacionTemp;
    my @filtros;

    if ($id){
        push (@filtros, ( id => { eq => $id}));
        $registroImportacionTemp = C4::Modelo::IoImportacionIsoRegistro::Manager->get_io_importacion_iso_registro( query => \@filtros,
                                                                                                                    with_objects    => [ 'ref_importacion','ref_importacion.esquema' ]
                                                                                                                );
        return $registroImportacionTemp->[0];
    }

    return 0;
}


=item
     Esta funcion devuelve un los ejemplares de un  registro de importacion segun su id
=cut
sub getRegistrosHijoFromRegistroDeImportacionById {
    my ($id) = @_;

    my ($registro_importacion) = C4::AR::ImportacionIsoMARC::getRegistroFromImportacionById($id);

    if ($registro_importacion->getIdentificacion){
        my @filtros;
        push (@filtros, ( relacion => { eq => $registro_importacion->getIdentificacion }));
        push (@filtros, ( id_importacion_iso => { eq => $registro_importacion->id_importacion_iso }));

        require C4::Modelo::IoImportacionIsoRegistro;
        require C4::Modelo::IoImportacionIsoRegistro::Manager;

        #Obtengo la cantidad total de registros de la importacion para el paginador
        my $registros_array_ref = C4::Modelo::IoImportacionIsoRegistro::Manager->get_io_importacion_iso_registro( query => \@filtros );

        if(scalar(@$registros_array_ref) > 0){
            return (scalar(@$registros_array_ref), $registros_array_ref);
        }
    }
    return (0,0);
}

=item
     Esta funcion devuelve un los ejemplares de un  registro de importacion segun su id
=cut
sub getRegistroPadreFromRegistroDeImportacionById {
    my ($id) = @_;

    my ($registro_importacion) = C4::AR::ImportacionIsoMARC::getRegistroFromImportacionById($id);

    if ($registro_importacion->getRelacion){
        my @filtros;
        push (@filtros, ( identificacion => { eq => $registro_importacion->getRelacion }));
        push (@filtros, ( id_importacion_iso => { eq => $registro_importacion->id_importacion_iso }));

        require C4::Modelo::IoImportacionIsoRegistro;
        require C4::Modelo::IoImportacionIsoRegistro::Manager;

        #Obtengo la cantidad total de registros de la importacion para el paginador
        my $registros_array_ref = C4::Modelo::IoImportacionIsoRegistro::Manager->get_io_importacion_iso_registro( query => \@filtros );

        if($registros_array_ref->[0]){
            return $registros_array_ref->[0];
        }
    }
    return 0;
}


=item
    Esta funcion elimina una importacion (con todos sus registros)
    Parametros:
                {id_importacion}
=cut
sub eliminarImportacion {

     my ($id) = @_;
     my $msg_object= C4::AR::Mensajes::create();
     my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id);

     eval {
        $msg_object = $importacion->eliminar();
        if(!$msg_object->{'error'}){
         $msg_object->{'error'}= 0;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO00', 'params' => []} ) ;
        }
     };

     if ($@){
         #Se loguea error de Base de Datos
         &C4::AR::Mensajes::printErrorDB($@, 'B453','INTRA');
         #Se setea error para el usuario
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO01', 'params' => []} ) ;
     }

     return ($msg_object);
}

=item
     Esta funcion devuelve la importacion segun su id
=cut
sub getImportacionById {
    my ($id) = @_;

    require C4::Modelo::IoImportacionIso;
    require C4::Modelo::IoImportacionIso::Manager;

    my $importacionTemp;
    my @filtros;

    if ($id){
        push (@filtros, ( id => { eq => $id}));
        $importacionTemp = C4::Modelo::IoImportacionIso::Manager->get_io_importacion_iso( query => \@filtros,
                                                                                          with_objects    => ['esquema']
                                                                                        );

        return $importacionTemp->[0]
    }

    return 0;
}


=item
    Este funcion devuelve la informacion de importaciones segun su nombre, archivo o comentario
=cut
sub getImportacionLike {
    my ($busqueda,$orden,$ini,$cantR,$inicial) = @_;

    require C4::Modelo::IoImportacionIso;
    require C4::Modelo::IoImportacionIso::Manager;

    my @filtros;
    my $importacionTemp = C4::Modelo::IoImportacionIso->new();

    if($busqueda ne 'TODOS'){
        if (!($inicial)){
                push (  @filtros, ( or   => [   nombre => { like => '%'.$busqueda.'%'}, archivo => { like => '%'.$busqueda.'%'}, comentario => { like => '%'.$busqueda.'%'},]));
        }else{
                push (  @filtros, ( or   => [   nombre => { like => $busqueda.'%'}, archivo => { like => $busqueda.'%'}, comentario => { like => '%'.$busqueda.'%'},]) );
        }
    }

    my $ordenAux= $importacionTemp->sortByString($orden);
    my $importaciones_array_ref = C4::Modelo::IoImportacionIso::Manager->get_io_importacion_iso(   query => \@filtros,
                                                                                        sort_by => $ordenAux,
                                                                                        limit   => $cantR,
                                                                                        offset  => $ini,
     );

    #Obtengo la cantidad total de importaciones para el paginador
    my $importaciones_array_ref_count = C4::Modelo::IoImportacionIso::Manager->get_io_importacion_iso_count( query => \@filtros);

    if(scalar(@$importaciones_array_ref) > 0){
        return ($importaciones_array_ref_count, $importaciones_array_ref);
    }else{
        return (0,0);
    }
}

=item sub guardarNuevaImportacion
Obtiene un esquema de importacion
=cut

sub getEsquema{
    my ($id_esquema,$campo_search,$offset,$limit) = @_;

    use C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;
    my @filtros;

    $offset = $offset || 0;
    $limit = $limit || 0;

    push(@filtros,(id_importacion_esquema => {eq =>$id_esquema}));
    if ($campo_search){
        push(@filtros,(campo_origen => {like =>$campo_search.'%'}));
    }

    my $detalle_esquema;

    if ($limit){
        $detalle_esquema = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(
                                                                                                        query => \@filtros,
                                                                                                        group_by => ['campo_origen,subcampo_origen'],
                                                                                                        limit   => $limit,
                                                                                                        offset  => $offset,
                                                                                                        sort_by => ['campo_origen']
        );
    }else{
        $detalle_esquema = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(
                                                                                                        query => \@filtros,
                                                                                                        group_by => ['campo_origen,subcampo_origen'],
                                                                                                        sort_by => ['campo_origen']
        );

    }

    my $cant_total = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(
                                                                                                        query => \@filtros,
                                                                                                        group_by => ['campo_origen,subcampo_origen'],

    );

    $cant_total = scalar(@$cant_total);

    my $esquema = getEsquemaObject($id_esquema);

    return ($detalle_esquema,$esquema,$cant_total);
}

sub addEsquema{
    my ($nombre,$descripcion) = @_;

    use C4::Modelo::IoImportacionIsoEsquema;

    my $esquema = C4::Modelo::IoImportacionIsoEsquema->new();
    $esquema->setNombre($nombre);
    $esquema->setDescripcion($descripcion);
    $esquema->save();

    return $esquema;
}

sub addCampo{
    my ($id_esquema) = @_;

    use C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;
    my @filtros;

    my $esquema = C4::Modelo::IoImportacionIsoEsquemaDetalle->new();
    my $value = "ZZZ";
    my $error_code = 0;

    eval{
        $esquema->setIdImportacionEsquema($id_esquema);
        $esquema->setCampoOrigen($value);
        $esquema->setSubcampoOrigen($value);
        $esquema->setCampoDestino($value);
        $esquema->setSubcampoDestino($value);
        $esquema->setNivel(1);
        $esquema->setIgnorar(0);

        $esquema->save();
    };

    if ($@){
        return ($esquema,'IO02');
    }

    return ($esquema,$error_code);
}

sub getOrdenEsquema{

    my ($params) = @_;

    use C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;
    my @filtros;

    my $detalle = getRow($params->{'id_esquema'});

    push(@filtros,(id_importacion_esquema => { eq => $detalle->esquema->getId }));
    push(@filtros,(campo_origen           => { eq => $detalle->getCampoOrigen}));
    push(@filtros,(subcampo_origen => { eq => $detalle->getSubcampoOrigen }));

    my $detalle_esquema = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(
                                                                                                    query => \@filtros,
                                                                                                    sort_by => ['orden ASC'],
    );

    return ($detalle_esquema,$detalle);

}

sub updateNewOrder{
    my ($params) = @_;
    my $msg_object      = C4::AR::Mensajes::create();

    # ordeno los ids que llegan desordenados primero, para obtener un clon de los ids, y ahora usarlo de indice para el orden
    # esto es porque no todos los campos de cat_visualizacion_intra se muestran en el template a ordenar ( ej 8 y 9 )
    # entonces no puedo usar un simple indice como id.
    my $newOrderArray = $params->{'newOrderArray'};

    my @array = sort { $a <=> $b } @$newOrderArray;

    my $i = 0;
    # hay que hacer update de todos los campos porque si viene un nuevo orden y es justo ordenado (igual que @array : 1,2,3...)
    # tambien hay que actualizarlo
    foreach my $campo (@$newOrderArray){

        my @filtros;
        push(@filtros,(id => { eq => $campo }));

        my $config_temp   = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(
                                                                    query   => \@filtros,
                               );

        my $configuracion = $config_temp->[0];

        $configuracion->setOrden($i+1);
        $configuracion->save();

        $i++;
    }

    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'M000', 'params' => []} ) ;

    return ($msg_object);
}

sub addCampoAEsquema{
    my ($params) = @_;

    use C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;
    my @filtros;

    my $esquema = getRow($params->{'id_esquema'});
    my $msg_object = C4::AR::Mensajes::create();

    eval{
        my $new_esquema = C4::Modelo::IoImportacionIsoEsquemaDetalle->new();
        $new_esquema->setIdImportacionEsquema($esquema->getIdImportacionEsquema);
        $new_esquema->setCampoOrigen($esquema->getCampoOrigen);
        $new_esquema->setSubcampoOrigen($esquema->getSubcampoOrigen);
        $new_esquema->setCampoDestino($params->{'campo'});
        $new_esquema->setSubcampoDestino($params->{'subcampo'});
        $new_esquema->setSeparador($params->{'separador'});
        $new_esquema->setNivel(1);
        $new_esquema->setIgnorar(0);
        $new_esquema->setNextOrden();

        $new_esquema->save();

        $msg_object->{'error'}= 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO016', 'params' => [$params->{'campo'},$params->{'subcampo'},$esquema->esquema->getNombre]} ) ;

    };

    if ($@){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO015', 'params' => []} ) ;
    }

    return ($msg_object);

}


sub getRow{
    my ($id) = @_;

    use C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;
    my @filtros;

    push(@filtros,(id => {eq =>$id}));

    my $esquema = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(query => \@filtros,);

    if ($esquema->[0]){
        return $esquema->[0];
    }else{
        return 0;
    }

}

sub getEsquemaObject{
    my ($id) = @_;

    use C4::Modelo::IoImportacionIsoEsquema::Manager;
    my @filtros;

    push(@filtros,(id => {eq =>$id}));

    my $esquema = C4::Modelo::IoImportacionIsoEsquema::Manager->get_io_importacion_iso_esquema(query => \@filtros,);

    if ($esquema->[0]){
        return $esquema->[0];
    }else{
        return 0;
    }

}

sub delEsquema{
    my ($id_esquema) = @_;

    use C4::Modelo::IoImportacionIsoEsquema::Manager;
    use C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;

    my $msg_code = 'IO05';

    my @filtros_detalle;
    push(@filtros_detalle,(id_importacion_esquema => {eq =>$id_esquema}));

    my @filtros_esquema;
    push(@filtros_esquema,(id => {eq =>$id_esquema}));

    eval{
        C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->delete_io_importacion_iso_esquema_detalle(where => \@filtros_detalle);
        C4::Modelo::IoImportacionIsoEsquema::Manager->delete_io_importacion_iso_esquema(where => \@filtros_esquema);
    };

    if ($@){
        return 'IO06';
    }

    return($msg_code);
}

sub delCampo{
    my ($id) = @_;

    my $row = getRow($id);

    my @filtros;
    my $id_esquema = $row->esquema->getId;

    push( @filtros, ( id_importacion_esquema => { eq => $id_esquema }, ) );
    push( @filtros, ( campo_origen => { eq => $row->getCampoOrigen }, ) );
    push( @filtros, ( subcampo_origen => { eq => $row->getSubcampoOrigen }, ) );

    eval{
        C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->delete_io_importacion_iso_esquema_detalle(where => \@filtros);
    };

    if ($@){
       return (0,'IO07');
    }else{
        return ($id_esquema,'IO03');
    }
}

sub delCampoOne{
    my ($id) = @_;

    my $row = getRow($id);

    my @filtros;
    my $id_esquema = $row->esquema->getId;

    push( @filtros, ( id => { eq => $id }, ) );

    eval{
        C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->delete_io_importacion_iso_esquema_detalle(where => \@filtros);
    };

    if ($@){
       return (0,'IO07');
    }else{
        return ($id_esquema,'IO03');
    }
}

sub actualizarMappeo{
    my ($row,$new_value,$action) = @_;

    my @filtros;
    push( @filtros, ( id_importacion_esquema => { eq => $row->esquema->getId }, ) );
    push( @filtros, ( campo_origen => { eq => $row->getCampoOrigen }, ) );
    push( @filtros, ( subcampo_origen => { eq => $row->getSubcampoOrigen }, ) );

    if ($action eq "co"){
        C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->update_io_importacion_iso_esquema_detalle(
                                                                                             where => \@filtros,
                                                                                             set   => { campo_origen => $new_value },

        );
    }else{
        C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->update_io_importacion_iso_esquema_detalle(
                                                                                             where => \@filtros,
                                                                                             set   => { subcampo_origen => $new_value },

        );

    }
}

sub editarValorEsquema{
    my ($row_id,$value) = @_;

    use Switch;

    my @values = split('___',$row_id);


    my $object = getRow(@values[0]);

    switch (@values[1]) {
        case "co"  {actualizarMappeo($object,$value,@values[1]); $object->load(); $value = $object->getCampoOrigen()}
        case "sco"  {actualizarMappeo($object,$value,@values[1]); $object->load(); $value = $object->getSubcampoOrigen()}
        case "cd"   {$object->setCampoDestino($value); $value = $object->getCampoDestino()}
        case "scd"  {$object->setSubcampoDestino($value); $value = $object->getSubcampoDestino()}
        case "n"    {$object->setNivel($value); $value = $object->getNivel()}
        case "ign"  {$object->setIgnorarFront($value); $object->load(); $value = $object->getIgnorarFront();}
        case "sep"  {$object->setSeparador($value); $value = $object->getSeparador();}
    }
    $object->save();

    return ($value);

}

sub editarEsquema{
    my ($row_id,$value) = @_;

    use Switch;

    my @values = split('___',$row_id);


    my $object = getEsquemaObject(@values[0]);

    switch (@values[1]) {
        case "nombre"  {$object->setNombre($value)}
        case "desc"  {$object->setDescripcion($value)}
    }
    $object->save();

    return ($value);

}

sub getCamposXFromEsquemaOrigenLike {
      my ($id_esquema,$campoX) = @_;

    use C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;

    my @filtros;
    push(@filtros, (id_importacion_esquema => {eq =>$id_esquema}));
    push(@filtros, (campo_origen => { like => $campoX.'%'}) );

    my $db_campos_MARC = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(
                                                                                        query => \@filtros,
                                                                                        sort_by => ('campo_origen'),
                                                                                        select   => [ 'campo_origen'],
                                                                                        group_by => [ 'campo_origen'],
                                                                       );
    return($db_campos_MARC);
}


sub getSubCamposFromEsquemaOrigenLike {
      my ($id_esquema,$campo) = @_;
    use C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;

    my @filtros;
    push(@filtros, (id_importacion_esquema => {eq =>$id_esquema}));
    push(@filtros, (campo_origen => { eq => $campo}) );

    my $db_subcampos_MARC = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(
                                                                                        query => \@filtros,
                                                                                        sort_by => ('subcampo_origen'),
                                                                                        select   => [ 'subcampo_origen'],
                                                                                        group_by => [ 'subcampo_origen'],
                                                                       );
    return($db_subcampos_MARC);
}



sub procesarRelacionRegistroEjemplares {
      my ($params) = @_;

     my $msg_object= C4::AR::Mensajes::create();

     eval {

          my $id_importacion             = $params->{'id'};
          my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id_importacion);

          my $campo_relacion = $params->{'campo_relacion'};
          my $subcampo_relacion = $params->{'subcampo_relacion'};
          my $preambulo_relacion = $params->{'preambulo_relacion'};
          if (($campo_relacion )&&($campo_relacion ne '-1')) {
              $importacion->setCampoRelacion($campo_relacion,$subcampo_relacion,$preambulo_relacion);
              }

          my $campo_identificacion = $params->{'campo_identificacion'};
          my $subcampo_identificacion = $params->{'subcampo_identificacion'};
          if (($campo_identificacion)&&($campo_identificacion ne '-1')) {
              $importacion->setCampoIdentificacion($campo_identificacion,$subcampo_identificacion);
          }

          $importacion->save();

        #ACA HAY QUE PROCESAR LA RELACION
        # 1 - Buscar todas las identificaciones
        # 2 - Buscar todas las relaciones registro/ejemplar
        $importacion->setearIdentificacionRelacionRegistros();

        if(!$msg_object->{'error'}){
         $msg_object->{'error'}= 0;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO09', 'params' => []} ) ;
        }
     };

     if ($@){
         #Se loguea error de Base de Datos
         &C4::AR::Mensajes::printErrorDB($@, 'B457','INTRA');
         #Se setea error para el usuario
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO10', 'params' => []} ) ;
     }

     return ($msg_object);

}


sub obtenerCamposDeArchivo {
    my ($params)    = @_;

    my %detalleCampos=();

    if($params->{'formatoImportacion'} eq "xls"){
        #ES UNA PLANILLA DE CALCULO
        # NO HAY CAMPOS Y SUBCAMPOS
        # Los campo se van a ir agregando a partir del 100 en adelante con subcampo a
        my $campo = 100;
        my $subcampo = 'a';

        C4::AR::Debug::debug( "EXCEL!!! ".$params->{'write_file'}." parser => ".$params->{'file_ext'});
        my $ref = Spreadsheet::Read::ReadData($params->{'write_file'}, parser => $params->{'file_ext'});
        C4::AR::Debug::debug( "EXCEL REF ".$ref->[1]{'label'});
        my @rows = Spreadsheet::Read::rows($ref->[1]);
        my $first_row = $rows[0];
        foreach my $columna (@$first_row){

                if(!$detalleCampos{$campo.""}){
                    #Lo transformo a str :)
                    $detalleCampos{$campo.""}= $columna;
                    C4::AR::Debug::debug( "LEO EXCEL!!! columna: ". $columna." => campo: ".$campo);
                    $campo++;
                }

        }
    }
    else {
        #ES UN ISO
        C4::AR::Debug::debug( $params->{'formatoImportacion'} );

        $params->{'formatoImportacion'}= "isis";
        $params->{'write_file'}="/usr/share/meran/jaula/files/intranet/private-uploads/imports/revmed.iso";
        use Switch;
        my $reader = MARC::Moose::Reader::File::Isis->new(file   => $params->{'write_file'});

  C4::AR::Debug::debug( "Leer campos de ".$params->{'write_file'} );

        while ( my $record = $reader->read() ) {
          C4::AR::Debug::debug( "registro");
             for my $field ( @{$record->fields} ) {
               C4::AR::Debug::debug( "campo".$field->tag);
                 my $campo = $field->tag;
                 if(!$detalleCampos{$campo}){
                    $detalleCampos{$campo}= 1;
                }
             }
        }
    }
    return(\%detalleCampos);
}



sub procesarReglasMatcheo {
      my ($params) = @_;

     my $msg_object= C4::AR::Mensajes::create();

     eval {
          my $id_importacion             = $params->{'id'};
          my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id_importacion);

          my $reglas_matcheo = $params->{'reglas_matcheo'};
          $importacion->setReglasMatcheo($reglas_matcheo);
          $importacion->save();
          my $reglas= $importacion->getReglasMatcheoArray();

        #ACA HAY QUE PROCESAR LAS REGLAS
        my $tt1 = time();
        # Recorrer cada registro y ver si matchea contra alguno de la base
        my $registros_importacion = $importacion->getRegistrosPadre();
        my $cant_registros=0;
        foreach my $registro (@$registros_importacion){
            #Armo las reglas con dato y busco en el catalogo si existe
            my $reglas_registro = $registro->getDatosFromReglasMatcheo($reglas);
            my $id_matching =0;
                if(scalar(@$reglas_registro)){
                    $id_matching = C4::AR::ImportacionIsoMARC::getIdMatchingFromCatalog($reglas_registro);
                }

            if($id_matching){
                $registro->setMatching(1);
                $registro->setIdMatching($id_matching);
                $cant_registros++;
                }
              else{
                $registro->setMatching(0);
                  }
              $registro->save();
            }
        my $tt2 = time();
        my $tardo2=($tt2 - $tt1);
        my $min= $tardo2/60;
        my $hour= $min/60;
        C4::AR::Debug::debug( "AL FIN TERMINO TODO!!! Tardo $tardo2 segundos !!! que son $min minutos !!! o mejor $hour horas !!!");


        if(!$msg_object->{'error'}){
         $msg_object->{'error'}= 0;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO11', 'params' => [$cant_registros]} ) ;
        }
     };

     if ($@){
         #Se loguea error de Base de Datos
         &C4::AR::Mensajes::printErrorDB($@, 'B458','INTRA');
         #Se setea error para el usuario
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO12', 'params' => []} ) ;
     }

     return ($msg_object);

}


sub getIdMatchingFromCatalog {
    my ($reglas)    = @_;

    #obtengo los datod de todos los niveles1

    my  $indice_array_ref = C4::AR::Sphinx::getAllIndiceBusqueda();

    if ($indice_array_ref) {
    foreach my $indice ( @$indice_array_ref) {
            my $marc_record=  $indice->getMarcRecordObject;
            my $match=0;
                foreach my $regla (@$reglas){
                    my @datos = $marc_record->subfield($regla->{'campo'},$regla->{'subcampo'});
                    foreach my $datos (@datos){
#                       C4::AR::Debug::debug("CAMPARANDO ".C4::AR::Utilidades::trim($regla->{'dato'})." <==>".C4::AR::Utilidades::trim($datos));
                        if ( C4::AR::Utilidades::trim($regla->{'dato'}) eq C4::AR::Utilidades::trim($datos)) {
                            C4::AR::Debug::debug("MATCH REGLA=".$regla->{'campo'}."&".$regla->{'subcampo'}." => ".$regla->{'dato'});
                            return $indice->getId;
                            }
                    }
                }

            if($match){
                return $indice->getId;
                }
        }
    }
    return(0);
}


sub cambiarEsdatoRegistro {
      my ($params) = @_;

     my $msg_object= C4::AR::Mensajes::create();

     eval {


          my $id_registro             = $params->{'id'};
          my ($registro_importacion) = C4::AR::ImportacionIsoMARC::getRegistroFromImportacionById($id_registro);
          $registro_importacion->setEstado($params->{'estado'});
          $registro_importacion->save();

        if(!$msg_object->{'error'}){
         $msg_object->{'error'}= 0;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO11', 'params' => []} ) ;
        }
     };

     if ($@){
         #Se loguea error de Base de Datos
         &C4::AR::Mensajes::printErrorDB($@, 'B458','INTRA');
         #Se setea error para el usuario
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO12', 'params' => []} ) ;
     }

     return ($msg_object);

}

#Dividir el registro en niveles de meran

sub getNivelesFromRegistro {
    my ($id_registro) = @_;

    my ($registro_importacion) = C4::AR::ImportacionIsoMARC::getRegistroFromImportacionById($id_registro);
    my $marc_record_to_meran = $registro_importacion->getRegistroMARCResultado();

    C4::AR::Debug::debug("REGISTRO=   ".$marc_record_to_meran->as_formatted());


    #Armamos un grupo de niveles vacio
    my $marc_record_n1 = MARC::Record->new();
    my $marc_record_n2 = MARC::Record->new();
    my $marc_record_n3 = MARC::Record->new();
    my @grupos=();
    my @ejemplares=();
    my $tipo_ejemplar='';
    my $total_ejemplares=0;
    foreach my $field ($marc_record_to_meran->fields) {
        if(! $field->is_control_field){
            my $campo                       = $field->tag;
            my $indicador_primario_dato     = $field->indicator(1);
            my $indicador_secundario_dato   = $field->indicator(2);
            #proceso todos los subcampos del campo
            foreach my $subfield ($field->subfields()) {
                my $subcampo          = $subfield->[0];
                my $dato              = $subfield->[1];
                my $estructura        = C4::AR::EstructuraCatalogacionBase::getEstructuraBaseFromCampoSubCampo($campo, $subcampo);

                if($estructura) {
                 # C4::AR::Debug::debug("NIVEL ??  ".$estructura->getNivel);
                  use Switch;
                  switch ($estructura->getNivel) {
                  case 1 {


                            if ((($campo eq '041')&&($subcampo eq 'h'))&&($marc_record_n1->subfield($campo,$subcampo))){
                                  #ya existe el 041,h IDIOMA, no sirve que haya varios
                                  next;
                           }

                            if ((($campo eq '043')&&($subcampo eq 'a'))&&($marc_record_n1->subfield($campo,$subcampo))){
                                  #ya existe el 043,a PAIS, no sirve que haya varios
                                  next;
                           }
                     #   C4::AR::Debug::debug("NIVEL 1  ".$campo."&".$subcampo."=".$dato." ".$marc_record_n1->subfield($campo,$subcampo)." repetible? ".$estructura->getRepetible);
                        #El campo es de Nivel 1

                        #preguntamos si existe el campo primero
                        if ($marc_record_n1->field($campo)){

                      #      C4::AR::Debug::debug("EL CAMPO $campo EXISTE");

                            if  ($estructura->getRepetible) {

                       #         C4::AR::Debug::debug("EL CAMPO ES REPETIBLE");

                                #si es hacemos un add_subfields
                                #Existe el campo y es repetible, agrego el subcampo
                                $marc_record_n1->field($campo)->add_subfields($subcampo => $dato);

                            } else {
                        #        C4::AR::Debug::debug("EL CAMPO  NO ! ES REPETIBLE");
                                #NO es repetible

                                #preguntamos si existe el subcampo
                                if ($marc_record_n1->subfield($campo,$subcampo)) {

                         #           C4::AR::Debug::debug("Existe el subcampo $subcampo ");
                                    #Parche Campo Notas unido 505 a en nivel 1
                                    if (($campo eq '505')&&($subcampo eq 'a')){
                                       $marc_record_n1->field($campo)->update( $subcampo =>  $marc_record_n1->subfield($campo,$subcampo)." - ".$dato);
                                        next;
                                    }

                                    #existe el subcampo y no es repetible, hay que agregar uno nuevo
                                    my $field = MARC::Field->new($campo,'','',$subcampo => $dato);
                                    $marc_record_n1->append_fields($field);

                                } else {
                          #          C4::AR::Debug::debug("NO ! existe el subcampo $subcampo , lo agregamos ");
                                    #NO existe el SUBCAMPO LO AGREGO
                                    $marc_record_n1->field($campo)->add_subfields($subcampo => $dato);
                                }

                            }

                        } else {

                           # C4::AR::Debug::debug("EL CAMPO $campo NO! EXISTE");

                            my $field = MARC::Field->new($campo,'','',$subcampo => $dato);
                            $marc_record_n1->append_fields($field);
                        }

                      } #end case1
                  case 2 {
                          #Nivel 2

                            #  C4::AR::Debug::debug("NIVEL 2  ".$campo."&".$subcampo."=".$dato." ".$marc_record_n2->subfield($campo,$subcampo)." repetible? ".$estructura->getRepetible);

                          if ((($campo eq '900')&&($subcampo eq 'b'))&&($marc_record_n2->subfield($campo,$subcampo))){
                                  #ya existe el 900,b NIVEL BIBLIOGRAFICO, no sirve que haya varios
                                  next;
                            }

                          if ((($campo eq '041')&&($subcampo eq 'a'))&&($marc_record_n2->subfield($campo,$subcampo))){
                                  #ya existe el 041,a IDIOMA, no sirve que haya varios
                                  next;
                           }

                          if ((($campo eq '043')&&($subcampo eq 'c'))&&($marc_record_n2->subfield($campo,$subcampo))){
                                  #ya existe el 043,c PAIS, no sirve que haya varios
                                  next;
                           }

                          if ((($campo eq '910')&&($subcampo eq 'a'))&&($marc_record_n2->subfield($campo,$subcampo))){
                                  #ya existe el 910,a TIPO DOC, no sirve que haya varios
                                  next;
                           }


                          #HAY QUE CREAR UNO NUEVO??
                          #C4::AR::Debug::debug("HAY QUE CREAR UNO NUEVO??  ".$campo."&".$subcampo."=".$dato." ".$marc_record_n2->subfield($campo,$subcampo)." repetible? ".$estructura->getRepetible);
                          # FIXME y si hay varios????? ===> Busco el último y me fijo ahi siempre !!!

                          my @campos_registro = $marc_record_n2->field($campo);
                          if($campos_registro[-1]){
                            #C4::AR::Debug::debug("ULTIMO CAMPO ".$campos_registro[-1]->as_formatted() );
                            }
                          if(($campos_registro[-1])&&($campos_registro[-1]->subfield($subcampo))&&(!$estructura->getRepetible)){
                              #Existe el subcampo y no es repetible ==> es un nivel 2 nuevo
                             # C4::AR::Debug::debug("Existe el subcampo y no es repetible ==> es un nivel 2 nuevo  ".$campo."&".$subcampo."=".$dato);

                              #Agrego el último ejemplar y lo guardo
                              if (scalar($marc_record_n3->fields())){
                              #    C4::AR::Debug::debug("EJEMPLAR ".$marc_record_n3->as_formatted);
                                  push(@ejemplares,$marc_record_n3);
                                  $marc_record_n3 = MARC::Record->new();
                              }

                              #Guardo el nivel 2 con sus ejemplares
                              if(($marc_record_n2->subfield('910','a'))||(!$tipo_ejemplar)){
                                $tipo_ejemplar = C4::AR::ImportacionIsoMARC::getTipoDocumentoFromMarcRecord($marc_record_n2);
                              }

                              my %hash_temp;
                              $hash_temp{'grupo'}  = $marc_record_n2;
                              $hash_temp{'tipo_ejemplar'}  = $tipo_ejemplar;
                              $hash_temp{'cant_ejemplares'}   = scalar(@ejemplares);
                              $total_ejemplares+=$hash_temp{'cant_ejemplares'};
                              my @ejemplares_grupo =   @ejemplares; #esto hace la copia del arreglo
                              $hash_temp{'ejemplares'}   = \@ejemplares_grupo;
                              #C4::AR::Debug::debug("GRUPO CON ".$hash_temp{'cant_ejemplares'}." EJEMPLARES");
                              push (@grupos, \%hash_temp);
                              $marc_record_n2 = MARC::Record->new();

                              my $field = MARC::Field->new($campo,'','',$subcampo => $dato);
                              $marc_record_n2->append_fields($field);

                              @ejemplares = ();
                              #$tipo_ejemplar ='';
                          }
                          else{
                              #El campo es de Nivel 2
                              #FIXME y si son muchos campos repetibles??
                              if (($campos_registro[-1])&&(!$campos_registro[-1]->subfield($subcampo))){
                                  #Existe el campo pero no el subcampo, agrego el subcampo
                                #    C4::AR::Debug::debug("Existe el campo pero no el subcampo, agrego el subcampo");
                                  $campos_registro[-1]->add_subfields($subcampo => $dato);
                              }
                              else{
                               #   C4::AR::Debug::debug("CAMPO NUEVO");
                                  #No existe el campo, se crea uno nuevo
                                  my $field = MARC::Field->new($campo,'','',$subcampo => $dato);
                                  $marc_record_n2->append_fields($field);
                                  }

                            }
                          }
                  case 3 {
                          #Nivel 3
                          #Aca no hay ningun campo que sea repetible, si ya existe el subcampo es un nuevo ejemplar.
                           if($marc_record_n3->subfield($campo,$subcampo)){
                              #Existe el subcampo y no es repetible ==> es un nivel 3 nuevo
                              #Agrego el último ejemplar y lo guardo
                              #C4::AR::Debug::debug("EJEMPLAR ".$marc_record_n3->as_formatted);
                                  push(@ejemplares,$marc_record_n3);
                                  $marc_record_n3 = MARC::Record->new();
                              }
                          #C4::AR::Debug::debug("EJ ".$campo."&".$subcampo."=".$dato);
                          #El campo es de Nivel 3
                          if ($marc_record_n3->field($campo)){
                              #Existe el campo, agrego el subcampo
                              $marc_record_n3->field($campo)->add_subfields($subcampo => $dato);
                          }
                          else{
                              #No existe el campo, se crea
                              my $field = MARC::Field->new($campo,'','',$subcampo => $dato);
                              $marc_record_n3->append_fields($field);
                              }

                           ### PARCHE PARA ARQUITECTURA ###
                            if (($campo eq '995')&&($subcampo eq 't')){
                                #Signatura Topográfica
                                if ($dato =~ m/Folleto/g ){
                                    $tipo_ejemplar = 'FOL';

                                    if($marc_record_n2->field('910')){
                                        $marc_record_n2->field('910')->update( 'a' => $tipo_ejemplar);
                                    }else{
                                            my $new_field= MARC::Field->new('910','#','#','a' => $tipo_ejemplar);
                                            $marc_record_n2->append_fields($new_field);
                                    }

                                    #El último dato es el inventario del ejemplar
                                    my @signatura =  split(' ', $dato);
                                    my $nro_inventario = pop(@signatura);
                                    if ($marc_record_n3->field('995')){
                                        $marc_record_n3->field('995')->add_subfields('f' => $nro_inventario);
                                    }else{
                                        my $field = MARC::Field->new('995','','','f' => $nro_inventario);
                                        $marc_record_n3->append_fields($field);
                                    }
                                }
                            }
                           #### FIN PARCHE ###
                          }
                  case 0 {
                      #C4::AR::Debug::debug("CAMPO MULTINIVEL ".$campo."&".$subcampo."=".$dato);
                      #FIXME va en el 1 por ahora
                          #El campo es de Nivel 1
                          if (($marc_record_n1->field($campo))&&(!$marc_record_n1->subfield($campo,$subcampo))){
                              #Existe el campo, agrego el subcampo
                              $marc_record_n1->field($campo)->add_subfields($subcampo => $dato);
                          }
                          else{
                              #No existe el campo, se crea
                              my $field = MARC::Field->new($campo,'','',$subcampo => $dato);
                              $marc_record_n1->append_fields($field);
                              }

                      }
                  } #END SWITCH
              }
            }

        }
    }
        #Agrego el último ejemplar y lo guardo
        if (scalar($marc_record_n3->fields())){
            push(@ejemplares,$marc_record_n3);
            $marc_record_n3 = MARC::Record->new();
        }

        #Guardo el nivel 2 con sus ejemplares
        if(($marc_record_n2->subfield('910','a'))||(!$tipo_ejemplar)){
            $tipo_ejemplar = C4::AR::ImportacionIsoMARC::getTipoDocumentoFromMarcRecord($marc_record_n2);
        }

        my %hash_temp;
        $hash_temp{'grupo'}  = $marc_record_n2;
        $hash_temp{'tipo_ejemplar'}  = $tipo_ejemplar;
        $hash_temp{'cant_ejemplares'}   = scalar(@ejemplares);
        $total_ejemplares+=$hash_temp{'cant_ejemplares'};
        my @ejemplares_grupo =   @ejemplares; #esto hace la copia del arreglo
        $hash_temp{'ejemplares'}   = \@ejemplares_grupo;
        @ejemplares=();
        push (@grupos, \%hash_temp);

        #C4::AR::Debug::debug("###########################################################################################");
        foreach my $grupo (@grupos){
            #my $ej = $grupo->{'ejemplares'};
            #C4::AR::Debug::debug(" GRUPO con ".scalar(@$ej)." ej");
            C4::AR::Debug::debug(" Grupo  ".$grupo->{'grupo'}->as_formatted);
                #foreach my $ejemplar (@$ej){
                        #C4::AR::Debug::debug(" Ejemplar  ".$ejemplar->as_formatted);
                #}
        }
        #C4::AR::Debug::debug("###########################################################################################");

        my %hash_temp;
        $hash_temp{'registro'}  = $marc_record_n1;
        $hash_temp{'grupos'}   = \@grupos;
        $hash_temp{'tipo_ejemplar'}  = $tipo_ejemplar;
        $hash_temp{'total_ejemplares'}  = $total_ejemplares;
    return  \%hash_temp;

}

=head2 sub detalleCompleto
    Genera el detalle
=cut

sub detalleCompletoRegistro {
    my ($id_registro) = @_;

    my $detalle = C4::AR::ImportacionIsoMARC::getNivelesFromRegistro($id_registro);

    #recupero el nivel1 segun el id1 pasado por parametro
    my $nivel1              = $detalle->{'registro'};

        #PAIS EN N1
        if($nivel1->subfield('043','a')){
            my $pais  =  C4::AR::ImportacionIsoMARC::getPaisFromMarcRecord_Object($nivel1);
            if($pais){
                #Seteo bien el pais
                $nivel1->field('043')->update( 'a' => $pais->getIso());
            }
        }

        #IDIOMA EN N1
        if($nivel1->subfield('041','h')){
            my $idioma  = C4::AR::ImportacionIsoMARC::getIdiomaFromMarcRecord_Object($nivel1);
            if($idioma){
                #Seteo bien el idioma
                $nivel1->field('041')->update( 'h' => $idioma->getDescription());
            }
        }

    #Parche: Digesto Poner por defecto como autor institucional/corporativo: Universidad Nacional de La Plata en el campo 110^a
    if (C4::AR::Preferencias::getValorPreferencia("defaultUI") eq "UNLP"){
        if($nivel1->field('110')){
            $nivel1->field('110')->update( 'a' => "Universidad Nacional de La Plata");
        }else{
                my $new_field= MARC::Field->new('110','#','#','a' => "Universidad Nacional de La Plata");
                $nivel1->append_fields($new_field);
        }
    }


    #Parche: FAU pide duplicar un campo
    if (C4::AR::Preferencias::getValorPreferencia("defaultUI") eq "DAQ"){

        if ($nivel1->subfield('245','a')){
            if (!$nivel1->field('222')){
               $nivel1->append_fields(MARC::Field->new('222',' ',' ','a' => $nivel1->subfield('245','a')));
            }
            else{
               $nivel1->field('222')->add_subfields(  'a' => $nivel1->subfield('245','a') );
            }
        }
    }

    #Son revistas?
    if ( C4::AR::ImportacionIsoMARC::getTipoDocumentoFromMarcRecord_Object($detalle->{'grupos'}->[0]->{'grupo'})->getId_tipo_doc() eq 'REV') {
        C4::AR::Debug::debug(" REVISTAS!!! ");
        my ($cantidad_ejemplares, $nuevos_grupos ) = procesarRevistas($detalle->{'grupos'});
        $detalle->{'grupos'} = $nuevos_grupos;
        $detalle->{'total_ejemplares'} = $cantidad_ejemplares;
    }

    my $grupos = $detalle->{'grupos'};

    my $tipo_documento;
    my $nivel_bibliografico;
    my @niveles2;
    foreach my $nivel2 (@$grupos){
        my $nivel2_marc = $nivel2->{'grupo'};
        my %hash_nivel2=();

       # C4::AR::Debug::debug("detalleCompletoRegistro >>> GRUPO \n ".$nivel2_marc->as_formatted());

        ##TIPO DE DOCUMENTO##
        if($nivel2_marc->subfield('910','a') || (!$tipo_documento)){
            $hash_nivel2{'tipo_documento'}      = C4::AR::ImportacionIsoMARC::getTipoDocumentoFromMarcRecord_Object($nivel2_marc);
            $tipo_documento                     = $hash_nivel2{'tipo_documento'};
            $nivel2->{'tipo_ejemplar'}          = $tipo_documento->getId_tipo_doc();
        }

        #C4::AR::Debug::debug(" TIPO DOCUMENTO!!! ".$tipo_documento->getNombre());

        #Seteo bien el código de tipo de documento
        if($nivel2_marc->field('910')){
            $nivel2_marc->field('910')->update( 'a' => $tipo_documento->getNombre());
        }else{
                my $new_field= MARC::Field->new('910','#','#','a' => $tipo_documento->getNombre());
                $nivel2_marc->append_fields($new_field);
        }

        ##ISBN vs ISSN##

        if($nivel2_marc->subfield('024','a')){
                    C4::AR::Debug::debug(" ISBN vs ISSN!!! ".$nivel2_marc->subfield('024','a'));
            if ($nivel2_marc->subfield('024','a') eq 'ISBN'){
                #Si es isbn y existe borro el issn
                my $f022=$nivel2_marc->field('022');
                $nivel2_marc->delete_fields($f022);
                my $f024=$nivel2_marc->field('024');
                $nivel2_marc->delete_fields($f024);
            }
            else {
                 if ($nivel2_marc->subfield('024','a') eq 'ISSN'){
                     if($nivel2_marc->field('022')){
                     #Si es issn y existe el campo borro el isbn
                        my $f020=$nivel2_marc->field('020');
                         if($f020){
                            $nivel2_marc->delete_fields($f020);
                         }
                        my $f024=$nivel2_marc->field('024');
                        $nivel2_marc->delete_fields($f024);
                     }
                    }
                }
        }

        ##IDIOMA##
        if($nivel2_marc->subfield('041','a')){
            $hash_nivel2{'idioma'}      = C4::AR::ImportacionIsoMARC::getIdiomaFromMarcRecord_Object($nivel2_marc);
            my $idioma  = $hash_nivel2{'idioma'};
            if($idioma){
                #Seteo bien el idioma
                $nivel2_marc->field('041')->update( 'a' => $idioma->getDescription());
            }
        }


        ##PAIS##
        if($nivel2_marc->subfield('043','c')){
            $hash_nivel2{'pais'}      = C4::AR::ImportacionIsoMARC::getPaisFromMarcRecord_Object($nivel2_marc);
            my $pais  = $hash_nivel2{'pais'};
            if($pais){
                #Seteo bien el pais
                $nivel2_marc->field('043')->update( 'c' => $pais->getIso());
            }
        }


        ##NIVEL BIBLIOGRAFICO##
                ##TIPO DE DOCUMENTO##
        if($nivel2_marc->subfield('900','b') || (!$nivel_bibliografico)){
            $hash_nivel2{'nivel_bibliografico'}     = C4::AR::ImportacionIsoMARC::getNivelBibliograficoFromMarcRecord_Object($nivel2_marc);
            $nivel_bibliografico                    = $hash_nivel2{'nivel_bibliografico'};
        }
            #Seteo bien el código del nivel bibliográfico
            if($nivel2_marc->field('900')){
                $nivel2_marc->field('900')->update( 'b' => $nivel_bibliografico->getDescription());
            }else{
                    my $new_field= MARC::Field->new('900','#','#','b' => $nivel_bibliografico->getDescription());
                    $nivel2_marc->append_fields($new_field);
                }

        $hash_nivel2{'marc_record'}             = $nivel2_marc;
        $hash_nivel2{'nivel2_array'}            = C4::AR::ImportacionIsoMARC::toMARC_Array($nivel2_marc,$tipo_documento->getId_tipo_doc(),'',2);
        $hash_nivel2{'nivel2_template'}         = $nivel2->{'tipo_ejemplar'};
        $hash_nivel2{'tiene_indice'}            = 0;


        if($nivel2->{'grupo'}->subfield('865','a')){
                $hash_nivel2{'indice'}              =   $nivel2_marc->subfield('865','a');
                $hash_nivel2{'tiene_indice'}        =   1;
            }
        $hash_nivel2{'esta_en_estante_virtual'}     =   0;

        my $ejemplares = $nivel2->{'ejemplares'};
        my @niveles3=();

        #Disponibilidad
        $hash_nivel2{'disponibles'}                 =   0;
        $hash_nivel2{'no_disponibles'}              =   0;
        $hash_nivel2{'disponibles_sala'}            =   0;
        $hash_nivel2{'disponibles_domiciliario'}    =   0;

        #POR SI SOLO SE ENCUENTRA 1 EN TODO EL REGISTRO!!!
        my $signaturaBase='';
        my $uiBase='';
        #C4::AR::Debug::debug(" Ejemplares ".scalar(@$ejemplares));
            foreach my $nivel3 (@$ejemplares){

                    my $n3 =  C4::AR::ImportacionIsoMARC::getEjemplarFromMarcRecord($nivel3,$tipo_documento->getId_tipo_doc());

                    #Guardo algunos datos por si vienen una única vez por grupo
                    if($n3->{'ui_origen'}){
                            $uiBase=$n3->{'ui_origen'};
                    } elsif ($uiBase){
                            $n3->{'ui_origen'}=$uiBase;
                    }

                    if($n3->{'ui_duenio'}){
                            $uiBase=$n3->{'ui_duenio'};
                    } elsif ($uiBase){
                            $n3->{'ui_duenio'}=$uiBase;
                    }

                    if($n3->{'signatura_topografica'}){
                            $signaturaBase = $n3->{'signatura_topografica'};
                    } elsif ($signaturaBase){
                            $n3->{'signatura_topografica'}=$signaturaBase;
                    }

                    #Calcular las disponibilidades
                    my $estado= $n3->{'estado'};
                    my $disponibilidad= $n3->{'disponibilidad'};

                    if ($estado->getCodigo eq $estado->estadoDisponibleValue){
                        #disponible
                        $hash_nivel2{'disponibles'}++;
                        if ($disponibilidad->getCodigo eq $disponibilidad->paraPrestamoValue){
                            $hash_nivel2{'disponibles_domiciliario'}++;
                            }else{
                                $hash_nivel2{'disponibles_sala'}++;
                                }
                        }
                        else{
                            $hash_nivel2{'no_disponibles'}++;
                            }
                    #
                    push(@niveles3, $n3);
                }

        $hash_nivel2{'nivel3'}                  = \@niveles3;
        $hash_nivel2{'cant_nivel3'}             = @niveles3;

        push(@niveles2, \%hash_nivel2);
    }

    if(!$tipo_documento){
        $tipo_documento = C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");
        $tipo_documento = C4::AR::Referencias::getTipoNivel3ByCodigo($tipo_documento);
    }

    my %t_params;
    $t_params{'nivel1'}           = C4::AR::ImportacionIsoMARC::toMARC_Array($nivel1,$tipo_documento->getId_tipo_doc(),'',1);
    $t_params{'marc_record'}      = $nivel1;
    $t_params{'nivel1_template'}  = $detalle->{'tipo_ejemplar'};
    $t_params{'cantItemN1'}       = $detalle->{'total_ejemplares'};
    $t_params{'nivel2'}           = \@niveles2;

    return \%t_params;
}

sub procesarRevistas {
    my ($revistas) = @_;

    #Armo regstro base de las revistas
    my $marc_record_base = MARC::Record->new();

    #ejemplares
    my $marc_record_ejemplares_base = MARC::Record->new();
    my $new_field995 = undef;

    my @signaturas = ();

     foreach my $nivel2 (@$revistas){
        my $nivel2_marc = $nivel2->{'grupo'};

            foreach my $field ($nivel2_marc->fields) {
                #Los datos de la colección los proceso luego
                if($field->tag ne '863'){
                    if (! $marc_record_base->field($field->tag)){
                        $marc_record_base->append_fields($field->clone);
                    }
                }
            }

        my $ejemplares = $nivel2->{'ejemplares'};

            foreach my $nivel3_marc (@$ejemplares) {

                #C4::AR::Debug::debug("EJEMPLAR: ".$nivel3_marc->as_formatted );

                my $field995 = $nivel3_marc->field('995');
                if ( $field995 ) {
                    foreach my $sf ($field995->subfields()){
                        my $subcampo = $sf->[0];
                        my $dato = $sf->[1];

                        if ($subcampo eq 't'){
                            #C4::AR::Debug::debug("NUEVA SIGNATURA: ".$dato);
                            #signatura
                            push (@signaturas, $dato);
                        } else {


                            if (($new_field995)&&($new_field995->subfield($subcampo))){
                                $new_field995->update( $subcampo => $new_field995->subfield($subcampo)." ".$dato);
                            }
                            else{
                                if (!$new_field995){
                                   $new_field995 = MARC::Field->new('995',' ',' ',$subcampo => $dato);
                                }
                                else{
                                    $new_field995->add_subfields(  $subcampo => $dato );
                                }
                            }
                        }
                    }
                }
            }

     }
    if($new_field995){
        $marc_record_ejemplares_base->append_fields($new_field995);
    }
    C4::AR::Debug::debug("EJEMPLARES BASE ==>  \n ".$marc_record_ejemplares_base->as_formatted);

    my @nuevos_grupos=();
    my $total_ejemplares=0;

    C4::AR::Debug::debug("REGISTRO BASE ==>  \n ".$marc_record_base->as_formatted);

    #Porceso la colección generando los nuevos grupos
     foreach my $nivel2 (@$revistas){
        #C4::AR::Debug::debug("REVISTA ==>  generamos estado de colección");
        my $nivel2_marc = $nivel2->{'grupo'};

        #C4::AR::Debug::debug("GRUPO ==>  \n ".$nivel2_marc->as_formatted);

        my $field863 = $nivel2_marc->field('863');

        if(($field863)|| ($nivel2_marc->subfield('900','e'))) {


            my @estadoDeColeccion= ();

            if ($nivel2_marc->subfield('900','e')) {
                #Lo saco del base
                  $marc_record_base->field("900")->delete_subfield(code => 'e');

                #Utilizo el subcampo e para indicar que se trata de el estado de colección completo.
                #Ejemplo:
                # 1976(1-2); 1977(3-4-5-6-7-8); 1978(9/10-11-12-13-14); 1979(15-16)
                #C4::AR::Debug::debug("REVISTA ==>  _estadoDeColeccionCompleto");
                @estadoDeColeccion = _estadoDeColeccionCompleto($nivel2_marc->subfield('900','e'));
            }else{
                 #Así fue en Darwinion con Año Volumen y Número separados.
                @estadoDeColeccion = _estadoDeColeccionDatosSeparados($field863);

            }

             #   C4::AR::Debug::debug("ESTADO DE COLECCION ==>  \n ");
            foreach my $rev (@estadoDeColeccion){
                #C4::AR::Debug::debug("REVISTA ==>  \n ".$rev->{'anio'}."-".$rev->{'numero'});

                    my $field863_final;

                    if ($field863){
                        $field863_final = $field863->clone();
                        $field863_final->add_subfields('b' => $rev->{'numero'});
                    }else{
                        $field863_final = MARC::Field->new('863',' ',' ','b' => $rev->{'numero'});
                    }

                    if($rev->{'volumen'}) {
                       $field863_final->add_subfields('a' => $rev->{'volumen'});
                    }

                    #El estado posee el Año de publicación?
                    if ($rev->{'anio'}){
                       $field863_final->add_subfields('i' => $rev->{'anio'});
                    }

                    my $marc_revista =  $marc_record_base->clone();
                    $marc_revista->add_fields($field863_final);

                    my %hash_temp;
                    $hash_temp{'grupo'}  = $marc_revista;
                    $hash_temp{'tipo_ejemplar'}  = $revistas->[0]->{'tipo_ejemplar'};
                    $hash_temp{'cant_ejemplares'}   = 0;
                    my @ejemplares;

                    if (scalar(@signaturas)){

                        foreach my $sig (@signaturas){
                            #C4::AR::Debug::debug("REVISTA ==>  \n SIGNATURA: ".$sig);
                            my $marc_record_n3 = $marc_record_ejemplares_base->clone();

                            if (!$marc_record_n3->field('995')){
                               $marc_record_n3->append_fields(MARC::Field->new('995',' ',' ','t' => $sig));
                            }
                            else{
                               $marc_record_n3->field('995')->add_subfields(  't' => $sig );
                            }
                            $hash_temp{'cant_ejemplares'} ++;
                            push(@ejemplares,$marc_record_n3);
                        }
                    }else{
                        #sin signatura
                        my $marc_record_n3 = $marc_record_ejemplares_base->clone();
                        $hash_temp{'cant_ejemplares'} ++;
                        push(@ejemplares,$marc_record_n3);
                    }

                    $total_ejemplares+=$hash_temp{'cant_ejemplares'};
                    $hash_temp{'ejemplares'}   = \@ejemplares;
                    push (@nuevos_grupos, \%hash_temp);
            }

    }        #if existe el campo 863
    else {
           #no tiene el campo
#           C4::AR::Debug::debug("COLECCION  ==>  ERROR: grupo sin campo 863 \n");

    }


    } #foreach

        return ($total_ejemplares, \@nuevos_grupos);
}

  sub _estadoDeColeccionCompleto{
        my ($estadoDeColeccionCompleto) = @_;

        my @estadoDeColeccion= ();

        #Ejemplo:
        # 1976(1-2); 1977(3-4-5-6-7-8); 1978(9/10-11-12-13-14); 1979(15-16)

        # C4::AR::Debug::debug("COLECCION  ==>  PROCESO : $volumenes \n");
        while($estadoDeColeccionCompleto =~ /((\d*\/?\d*)|\s)\s*((\d*\-?\d*)|\s)\s*(\(([^\)]+)\)|;?);?/g) {
           my $anio = $2;
           my $volumen = $4;
           my $numeros = $6;
           push( @estadoDeColeccion, _generarNumerosDeAnio(C4::AR::Utilidades::trim($anio),C4::AR::Utilidades::trim($volumen),C4::AR::Utilidades::trim($numeros)));
        }

        return  @estadoDeColeccion;
    }

    sub _estadoDeColeccionDatosSeparados {
        my ($field863) = @_;

        my @estadoDeColeccion= ();

        # 863 _i        => Año (se mantiene)
        #     _a9       => Volumen (de acá saco los grupos)
        #     _b89-99   =>  Números (de acá saco los grupos)

        my $new_field863 = $field863->clone();
        $new_field863->delete_subfield(code => 'a');
        $new_field863->delete_subfield(code => 'b');


        my $volumenes = $field863->subfield('a');
        my $numeros   = $field863->subfield('b');

        if ($volumenes) {
        # C4::AR::Debug::debug("COLECCION  ==>  PROCESO : $volumenes \n");
            my @volumenes_separados = split(',', $volumenes );
            foreach my $v (@volumenes_separados){
                if (index($v , '-') != -1) {
                    #son muchos
                    my @vsecuencia = split('-', $v);
                    #Agarro únicamente los 2 primeros valores, el resto lo considero erroneo. Por ej: debe venir a-b y debe ser a>b, no puede ser a-b-c y desordenado
                    if (@vsecuencia gt 1){
                        my $vini = C4::AR::Utilidades::trim($vsecuencia[0]);
                        my $vfin = C4::AR::Utilidades::trim($vsecuencia[1]);
                        if (($vini < $vfin)&&( ($vfin - $vini) <= 365 )) {

                            foreach my $vs ($vini..$vfin) {
     #                           C4::AR::Debug::debug("COLECCION  ==>  AGREGA UNO DE SECUENCIA Volumen: $vs \n");
                                my $volumen_limpio =C4::AR::Utilidades::trim($vs);
                                push( @estadoDeColeccion, _generarNumerosDeVolumen($volumen_limpio,$numeros));
                            }

                        }
                        else{
                            # error en orden de secuencia, lo agrego igual
      #                      C4::AR::Debug::debug("COLECCION  ==>  ERROR EN ORDEN DE SECUENCIA Volumen $v => $vini <= $vfin \n");
                            my $volumen_limpio =C4::AR::Utilidades::trim($v);
                            push( @estadoDeColeccion, _generarNumerosDeVolumen($volumen_limpio,$numeros));
                        }

                    }
                    else{
                        #uno solo, es un error, lo agrego igual
       #                 C4::AR::Debug::debug("COLECCION  ==>  ERROR: posee un - y existe un solo valor $v \n");
                        my $volumen_limpio =C4::AR::Utilidades::trim($v);
                        push( @estadoDeColeccion, _generarNumerosDeVolumen($volumen_limpio,$numeros));
                    }

                }else{
                    #uno solo
        #             C4::AR::Debug::debug("COLECCION  ==>  AGREGA UNO: $v \n");
                    my $volumen_limpio =C4::AR::Utilidades::trim($v);
                    push( @estadoDeColeccion, _generarNumerosDeVolumen($volumen_limpio,$numeros));

                }

                } #foreach
            } #if

        else {
                    #no tiene volumen agrego los números solos, si hay!
                    push( @estadoDeColeccion, _generarNumerosDeVolumen('',$numeros));
        }


        return  @estadoDeColeccion;
    }

    sub _generarNumerosDeVolumen {
        my ($volumen,$numeros) = @_;
            my @estadoDeColeccion= ();

            if ($numeros) {

 #               C4::AR::Debug::debug("COLECCION  ==>  PROCESO : $numeros \n");

                my @numeros_separados = split(',', $numeros );

                foreach my $n (@numeros_separados){
                    if (index($n , '-') != -1) {
                        #son muchos
                        my @secuencia = split('-', $n);
                        #Agarro únicamente los 2 primeros valores, el resto lo considero erroneo. Por ej: debe venir a-b y debe ser a>b, no puede ser a-b-c y desordenado
                        if (@secuencia gt 1){
                            my $ini = C4::AR::Utilidades::trim($secuencia[0]);
                            my $fin = C4::AR::Utilidades::trim($secuencia[1]);
                            # Errores en las secuencias, secuencia inicial mayor ala final o que la diferencia sea de más de un nro por día. Hay registros erroneos y hay que evitarlos.
                            if (($ini < $fin)&&( ($fin - $ini) <= 365 )) {

                                foreach my $ns ($ini..$fin) {
  #                                  C4::AR::Debug::debug("COLECCION  ==>  AGREGA UNO DE SECUENCIA: $ns \n");
                                    my $numero_limpio =C4::AR::Utilidades::trim($ns);
                                    my %fasciculo=();
                                    $fasciculo{'volumen'} = $volumen;
                                    $fasciculo{'numero'} = $numero_limpio;
                                    push(@estadoDeColeccion,\%fasciculo);
                                }
                            }
                            else{
                                # error en orden de secuencia, lo agrego igual
   #                             C4::AR::Debug::debug("COLECCION  ==>  ERROR EN ORDEN DE SECUENCIA $n => $ini <= $fin \n");
                                my $numero_limpio =C4::AR::Utilidades::trim($n);
                                     my %fasciculo=();
                                    $fasciculo{'volumen'} = $volumen;
                                    $fasciculo{'numero'} = $numero_limpio;
                                    push(@estadoDeColeccion,\%fasciculo);
                            }

                        }
                        else{
                            #uno solo, es un error, lo agrego igual
    #                        C4::AR::Debug::debug("COLECCION  ==>  ERROR: posee un - y existe un solo valor $n \n");
                            my $numero_limpio =C4::AR::Utilidades::trim($n);
                            my %fasciculo=();
                            $fasciculo{'volumen'} = $volumen;
                            $fasciculo{'numero'} = $numero_limpio;
                            push(@estadoDeColeccion,\%fasciculo);
                        }

                    }else{
                        #uno solo
    #                     C4::AR::Debug::debug("COLECCION  ==>  AGREGA UNO: $n \n");
                        my $numero_limpio =C4::AR::Utilidades::trim($n);
                        my %fasciculo=();
                        $fasciculo{'volumen'} = $volumen;
                        $fasciculo{'numero'} = $numero_limpio;
                        push(@estadoDeColeccion,\%fasciculo);
                    }

                    } #foreach
                } #if

            else {
                        #no tiene número
                        my %fasciculo=();
                        $fasciculo{'volumen'} = $volumen;
                        $fasciculo{'numero'} = '';
                        push(@estadoDeColeccion,\%fasciculo);
            }

        return  @estadoDeColeccion;
        }

    sub _generarNumerosDeAnio {
        my ($anio,$volumen,$numeros) = @_;
            my @estadoDeColeccion= ();

            if ($numeros) {

 #               C4::AR::Debug::debug("COLECCION  ==>  PROCESO : $numeros \n");

                my @numeros_separados = split(',', $numeros );

                foreach my $n (@numeros_separados){
                    my $numero_limpio =C4::AR::Utilidades::trim($n);
                    my %fasciculo=();
                    $fasciculo{'anio'} = $anio;
                    $fasciculo{'volumen'} = $volumen;
                    $fasciculo{'numero'} = $numero_limpio;
                    push(@estadoDeColeccion,\%fasciculo);
                }

            } else {
                    if($anio || $volumen){
                        #no tiene número
                        my %fasciculo=();
                        $fasciculo{'anio'} = $anio;
                        $fasciculo{'volumen'} = $volumen;
                        $fasciculo{'numero'} = '';
                        push(@estadoDeColeccion,\%fasciculo);
                      }
            }

        return  @estadoDeColeccion;
    }

sub toMARC_Array {
    my ($marc_record, $itemtype, $type, $nivel) = @_;
    my @MARC_result_array;
    $type           = $type || "__NO_TYPE";

    foreach my $field ($marc_record->fields) {
        if(! $field->is_control_field){
            my %hash;
            my $campo                       = $field->tag;
            my $indicador_primario_dato     = $field->indicator(1);
            my $indicador_secundario_dato   = $field->indicator(2);
            #proceso todos los subcampos del campo
            foreach my $subfield ($field->subfields()) {
                my %hash_temp;
                my $subcampo                        = $subfield->[0];
                my $dato                            = $subfield->[1];
                $hash_temp{'campo'}                 = $campo;
                $hash_temp{'subcampo'}              = $subcampo;
                $hash_temp{'liblibrarian'}          = C4::AR::Catalogacion::getLiblibrarian($campo, $subcampo, $itemtype, $type, $nivel);
                $hash_temp{'orden'}                 = C4::AR::Catalogacion::getOrdenFromCampoSubcampo($campo, $subcampo, $itemtype, $type, $nivel);
                $hash_temp{'dato'}                  = $dato;

                #es una referencia?
                $hash_temp{'referencia'} = 0;
                $hash_temp{'referencia_encontrada'} = 0;
                my $estructura = C4::AR::Catalogacion::_getEstructuraFromCampoSubCampo($campo, $subcampo, $itemtype, $nivel);
                if(($estructura)&&($estructura->infoReferencia)){
                    #C4::AR::Debug::debug("REFERENCIA ==>  ".$campo."&".$subcampo."=".$dato);
                    #es una referencia, yo tengo el dato nomás (luego se verá si hay que crear una nueva o ya existe en la base)
                    #my $infoRef = $estructura->infoReferencia->getReferencia;
                    #my $referer_involved = $tabla_referer_involved->getByPk($value_id);
                    $hash_temp{'referencia'} = $estructura->infoReferencia->getReferencia;
                    my ($clave_tabla_referer_involved,$tabla_referer_involved) =  C4::AR::Referencias::getTablaInstanceByAlias($hash_temp{'referencia'});
                    $hash_temp{'referencia_tabla'} = $hash_temp{'referencia'}; #$tabla_referer_involved->meta->table;
                    #C4::AR::Debug::debug("Tabla REF  ==>  ".$hash_temp{'referencia'});
                    my ($ref_cantidad,$ref_valores);
                    #if($hash_temp{'referencia'} eq 'idioma'){
                    #  ($ref_cantidad,$ref_valores) = $tabla_referer_involved->getIdiomaById($dato);
                    #}
                    #els

                    #if($hash_temp{'referencia'} eq 'pais'){
                    #  ($ref_cantidad,$ref_valores) = $tabla_referer_involved->getPaisByIso($dato);
                    #}
                    #else{
                    ($ref_cantidad,$ref_valores) = $tabla_referer_involved->getAll(1,0,0,$dato);
                    #}

                    if ($ref_cantidad){
                        # C4::AR::Debug::debug("ENCONTRE!!!  REF  ==>  ".$ref_valores->[0]->get_key_value);
                        $hash_temp{'referencia_encontrada'} =  $ref_valores->[0]->get_key_value;
                        }
                }

                #
                push(@MARC_result_array, \%hash_temp);
            }
        }
    }

    @MARC_result_array = sort{$a->{'orden'} <=> $b->{'orden'}} @MARC_result_array;

    return (\@MARC_result_array);
}

sub getDisponibilidadEjemplar {
    my ($ejemplar) = @_;
        my $dato = $ejemplar->subfield('995','o');
        my $resultado=C4::AR::Preferencias::getValorPreferencia("defaultDisponibilidad");
        #FIXME  Debería ir a una tabla de referencia de alias o sinónimos
        if ($dato){
            use Switch;
            switch ($dato) {
                case 'PRES' {
                    $resultado = "CIRC0000";
                    }
                case 'SALA' {
                    $resultado = "CIRC0001";
                    }
            }
        }
    return $resultado;
}

sub getEstadoEjemplar {
    my ($ejemplar) = @_;
        my $dato = $ejemplar->subfield('995','e');
        my $resultado=C4::AR::Preferencias::getValorPreferencia("defaultEstado");
        #FIXME  Debería ir a una tabla de referencia de alias o sinónimos
        if ($dato){
            use Switch;
            switch ($dato) {
                case 'DISPONIBLE' {
                    $resultado = "STATE002";
                    }
                case 'NO DISPONIBLE' {
                    $resultado = "STATE000";
                    }
            }


        #Si viene una fecha de baja??

        my @esFecha = split(" ", $dato);
        if(scalar(@esFecha) == 3){
            $resultado = "STATE000";
            }
        }

    return $resultado;
}

sub getEstadoEjemplar_Object {
    my ($ejemplar) = @_;
    my $estado = C4::AR::ImportacionIsoMARC::getEstadoEjemplar($ejemplar);
    my $object_estado = C4::Modelo::RefEstado->getByPk($estado);
    return  $object_estado;
}


sub getDisponibilidadEjemplar_Object {
    my ($ejemplar) = @_;
    my $disponibilidad = C4::AR::ImportacionIsoMARC::getDisponibilidadEjemplar($ejemplar);
    my $object_disponibilidad = C4::Modelo::RefDisponibilidad->getByPk($disponibilidad);
    return $object_disponibilidad;
}

sub getEjemplarFromMarcRecord {
    my ($nivel3,$tipo_documento) = @_;

    my %hash_nivel3=();
    $hash_nivel3{'marc_record'}             = $nivel3;
    $hash_nivel3{'tipo_documento'}          = $tipo_documento;
    $hash_nivel3{'barcode'}                 =  C4::AR::ImportacionIsoMARC::generaCodigoBarraFromMarcRecord($nivel3,$tipo_documento);
  if($hash_nivel3{'barcode'} eq 'AUTOGENERADO'){
    $hash_nivel3{'generar_barcode'}=1;
    }

    $hash_nivel3{'ui_origen'}               = C4::AR::ImportacionIsoMARC::getUIFromMarcRecord($nivel3);
    $hash_nivel3{'ui_duenio'}               = C4::AR::ImportacionIsoMARC::getUIFromMarcRecord($nivel3);
    $hash_nivel3{'signatura_topografica'}   =  $nivel3->subfield('995','t');
    $hash_nivel3{'inventario'}              =  $nivel3->subfield('995','s');

    $hash_nivel3{'fecha_alta'}              =  $nivel3->subfield('995','m');
    $hash_nivel3{'valor_doc'}               =  $nivel3->subfield('995','p');
    $hash_nivel3{'operador'}                =  $nivel3->subfield('900','g');
    $hash_nivel3{'fecha_baja_modificacion'} =  $nivel3->subfield('900','h');

    $hash_nivel3{'disponibilidad'}          =  C4::AR::ImportacionIsoMARC::getDisponibilidadEjemplar_Object($nivel3);
    $hash_nivel3{'estado'}                  =  C4::AR::ImportacionIsoMARC::getEstadoEjemplar_Object($nivel3);

    return \%hash_nivel3;
}

sub getTipoDocumentoFromMarcRecord {
        my ($marc_record) = @_;
    #FIXME  Debería ir a una tabla de referencia de alias o sinónimos
        my $tipo_documento = $marc_record->subfield('910','a') || C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");
        my $nivel_bibliografico = $marc_record->subfield('900','b');

        #C4::AR::Debug::debug(" TIPO DOCUMENTO  ".$tipo_documento );
        #C4::AR::Debug::debug(" NIVEL BIBLIOGRAFICO  ".$nivel_bibliografico );


        my $object_tipo_documento = C4::AR::Referencias::getTipoNivel3ByCodigo($tipo_documento);


        #        C4::AR::Debug::debug(" TIPO DOC??  ".$object_tipo_documento );


        if ($object_tipo_documento){
            return $object_tipo_documento->getId_tipo_doc();
        }
        else{
            my $resultado =C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");
            if ($tipo_documento){

                my %tipo_documento_alias = {
                    'TEXTO' =>  'LIB',
                    'CD'    =>  'CDR',
                    'DVD'   =>  'CDR',
                    'S'     =>  'REV'
                };

            $tipo_documento_alias{'S'} = 'REV';

        #    C4::AR::Debug::debug(" TIPO DOCUMENTO ALIAS! ".C4::AR::Utilidades::trim(uc($tipo_documento))." => ".$tipo_documento_alias{C4::AR::Utilidades::trim(uc($tipo_documento))});

                if ($tipo_documento_alias{C4::AR::Utilidades::trim(uc($tipo_documento))}) {
                    $resultado = $tipo_documento_alias{C4::AR::Utilidades::trim(uc($tipo_documento))};
                }
            }

            ### PARCHE PARA ARQUITECTURA ###
            my $signatura = $marc_record->subfield('995','t');
            if ($signatura =~ m/Folleto/g ){
                    $resultado = 'FOL';
                }

           # C4::AR::Debug::debug(" RESULTADO => ".$resultado );
           return $resultado;
        }
}

sub getTipoDocumentoFromMarcRecord_Object{
        my ($marc_record) = @_;
        my $tipo_documento = C4::AR::ImportacionIsoMARC::getTipoDocumentoFromMarcRecord($marc_record);
        my $object_tipo_documento = C4::AR::Referencias::getTipoNivel3ByCodigo($tipo_documento);
        return $object_tipo_documento;
}

sub getNivelBibliograficoFromMarcRecord{
        my ($marc_record) = @_;

        my $nivel_bibliografico = $marc_record->subfield('900','b');

        my $resultado =C4::AR::Preferencias::getValorPreferencia("defaultNivelBibliografico");
        if ($nivel_bibliografico){
            #FIXME por ahora suponemos que viene bien el codigo, puede haber alias
             $resultado=$nivel_bibliografico;
            use Switch;
            switch ($nivel_bibliografico) {
                case 'IMP' {
                    $resultado = 'm';
                    }
                case 'LIB DIG' {
                    $resultado = 'm';
                    }
            }
        }
    return $resultado;
    }

    sub getNivelBibliograficoFromMarcRecord_Object{
        my ($marc_record) = @_;
        my $nivel_bibliografico = C4::AR::ImportacionIsoMARC::getNivelBibliograficoFromMarcRecord($marc_record);
        #C4::AR::Debug::debug(" NIVEL BIBLIOGRAFICO  ".$nivel_bibliografico );

        $nivel_bibliografico = C4::AR::Utilidades::trim($nivel_bibliografico);
        my $object_nivel_bibliografico = C4::AR::Utilidades::getNivelBibliograficoByCode($nivel_bibliografico);
        #C4::AR::Debug::debug("OBJETO  NIVEL BIBLIOGRAFICO  ".$object_nivel_bibliografico );
        return $object_nivel_bibliografico;
    }

sub getIdiomaFromMarcRecord_Object{
        my ($marc_record) = @_;
        my $idioma = C4::AR::ImportacionIsoMARC::getIdiomaFromMarcRecord($marc_record);

        use C4::Modelo::RefIdioma;
        my ($cantidad, $objetos) = (C4::Modelo::RefIdioma->new())->getIdiomaById($idioma);

        if($cantidad){
             return $objetos->[0];
        }

        return 0;
}


sub getIdiomaFromMarcRecord{
    my ($marc_record) = @_;

    use C4::Modelo::RefIdioma;

    # Depende del tipo de documento
    my $idioma = undef;
    if ( $marc_record->subfield('041','a')) {
        $idioma = $marc_record->subfield('041','a');
    } else{
        #Revista
        $idioma = $marc_record->subfield('041','h');
    }

    # Si hay un () es porque viene nombre (codigo), busco con código, luego con nombre

    my $codigo =undef;
    my $nombre =undef;

    if ( index($idioma,'(') != -1 ){
     ($codigo) =  $idioma =~ /\((.*)\)/;
     $nombre =  substr($idioma, 0, index($idioma,'('));
    }
    else{
        $nombre = $idioma;
    }

    my @textos =();
    if ($codigo){ push (@textos, $codigo);}
    push (@textos, $nombre);


    foreach my $texto (@textos){
        $texto = C4::AR::Utilidades::trim($texto);
        #Casos raros
            use Switch;
            switch (uc($idioma)) {
                case 'CASTELLANO' {
                    $idioma = "es";
                    }
                case 'INGLES' {
                    $idioma = "en";
                    }
                case 'FRANCES' {
                    $idioma = "fr";
                    }
                case 'GALLEGO' {
                    $idioma = "gl";
                    }
            }

        #C4::AR::Debug::debug("busco idioma =>".$texto);
        if (length($texto) le 3 ){
            my ($cantidad, $objetos) = (C4::Modelo::RefIdioma->new())->getIdiomaById($texto);

            if($cantidad){
         #       C4::AR::Debug::debug("encontro idioma =>".$objetos->[0]->getIdLanguage());
                 return  $objetos->[0]->getIdLanguage();
            }
        }

        #NO lo encontre por iso voy a buscar por nombre exacto
        my ($cantidad, $objetos) = (C4::Modelo::RefIdioma->new())->getIdiomaByName($texto);
        if($cantidad){
          #  C4::AR::Debug::debug("encontro idioma =>".$objetos->[0]->getIdLanguage());
            return $objetos->[0]->getIdLanguage();
        }
    }
}


sub getPaisFromMarcRecord_Object{
        my ($marc_record) = @_;
        my $pais = C4::AR::ImportacionIsoMARC::getPaisFromMarcRecord($marc_record);

        use C4::Modelo::RefPais;
        my ($cantidad, $objetos) = (C4::Modelo::RefPais->new())->getPaisByIso($pais);

        if($cantidad){
             return $objetos->[0];
        }

        return 0;
}


sub getPaisFromMarcRecord{
    my ($marc_record) = @_;

    use C4::Modelo::RefPais;

    # Depende del tipo de documento
    my $pais = undef;
    if ( $marc_record->subfield('043','c')) {
        $pais = $marc_record->subfield('043','c');
    } else{
        #Revista
        $pais = $marc_record->subfield('043','a');
    }

    # Si hay un () es porque viene nombre (codigo), busco con código, luego con nombre

    my $codigo =undef;
    my $nombre =undef;

    if ( index($pais,'(') != -1 ){
     ($codigo) =  $pais =~ /\((.*)\)/;
     $nombre =  substr($pais, 0, index($pais,'('));
    }
    else{
        $nombre = $pais;
    }

    my @textos =();
    push (@textos, $nombre);
    if ($codigo){ push (@textos, $codigo);}

    foreach my $texto (@textos){
        $texto = C4::AR::Utilidades::trim($texto);
        #Casos raros
        use Switch;
        switch (uc($texto)) {
            case 'XXK' {
                $texto = "GBR";
                }
            case 'ENK' {
                $texto = "GBR";
                }
            case 'REINO UNIDO' {
                $texto = "GBR";
                }
            case 'XXU' {
                $texto = "USA";
                }
            case 'NE' {
                $texto = "NLD";
                }
            case 'AG' {
                $texto = "ARG";
                }
            case 'BL' {
                $texto = "BRA";
                }
            case 'JA' {
                $texto = "JPN";
                }
            case 'GW' {
                $texto = "DEU";
                }
        }

        #C4::AR::Debug::debug("busco pais =>".$texto);

        if (length($texto) le 3 ){
            # no es un código
            my ($cantidad, $objetos) = (C4::Modelo::RefPais->new())->getPaisByIso($texto);

            if($cantidad){
                # C4::AR::Debug::debug("encontro pais =>".$objetos->[0]->getNombre());
                 return  $objetos->[0]->getIso();
            }
        }

            #NO lo encontre por iso voy a buscar por nombre exacto
            my ($cantidad, $objetos) = (C4::Modelo::RefPais->new())->getPaisByName($texto);
            if($cantidad){
                #C4::AR::Debug::debug("encontro pais =>".$objetos->[0]->getNombre());
                return $objetos->[0]->getIso();
            }
    }
}



sub getUIFromMarcRecord {
        my ($marc_record) = @_;
    #FIXME  Debería ir a una tabla de referencia de alias o sinónimos
        my $ui = $marc_record->subfield('995','c');

        my $resultado = '';
        #FIXME hay que ver si existe la UI

        if ($ui){
            if(C4::AR::Referencias::obtenerUIByIdUi($ui)){
            #es el id
                $resultado=$ui;
                }
            else{
                my $uiLike=C4::AR::Referencias::obtenerUILike($ui);
                if (scalar(@$uiLike)){
                    #Existe algo parecido?
                    $resultado=$uiLike->[0]->getId_ui;
                    }
                else{
                    #Valor por defecto
                    $resultado =C4::AR::Preferencias::getValorPreferencia("defaultUI");
                    }
                }
            }else{
                     #Valor por defecto
                    $resultado =C4::AR::Preferencias::getValorPreferencia("defaultUI");
                }

    return $resultado;
}

sub generaCodigoBarraFromMarcRecord{
    my($marc_record_n3,$tipo_ejemplar) = @_;

   my $barcode;
   my @estructurabarcode = split(',', C4::AR::Preferencias::getValorPreferencia("barcodeFormat"));

    my $like = '';

    for (my $i=0; $i<@estructurabarcode; $i++) {
        if (($i % 2) == 0) {
            my $pattern_string ='';
            use Switch;
            switch ($estructurabarcode[$i]) {
                case 'UI' {
                    $pattern_string= C4::AR::ImportacionIsoMARC::getUIFromMarcRecord($marc_record_n3);
                    }
                case 'tipo_ejemplar' {
                    $pattern_string= C4::AR::ImportacionIsoMARC::getTipoDocumentoFromMarcRecord($marc_record_n3);
                    }
            }
            if ($pattern_string){
                $like.= $pattern_string;
            }else{
                $like.= $estructurabarcode[$i];
            }
        } else {
            $like.= $estructurabarcode[$i];
        }
    }

    my $nro_inventario = $marc_record_n3->subfield('995','f');
    if ($nro_inventario){
     #viene con nro de inventario
        $barcode  = $like.C4::AR::Nivel3::completarConCeros($nro_inventario);
     }

    if ((C4::AR::Nivel3::existeBarcode($barcode))||(!$barcode)){
        # Si no viene el códifo en el campo 995, f  o ya existe se busca el máximo de su tipo
        $barcode  = 'AUTOGENERADO';
     }

    return ($barcode);
}


sub procesarReferencia {
    my($dato,$tabla,$clave_tabla_referer_involved,$tabla_referer_involved) = @_;
    #Hay que agregar la referencia a la tabla correspondiente y devolver el id
    # TABLAS => cat_autor, cat_tema, ref_localidad,

            my ($clave_tabla_referer_involved,$tabla_referer_involved) =  C4::AR::Referencias::getTablaInstanceByAlias($tabla);

            C4::AR::Debug::debug("procesarReferencia =>  TABLA!!".$tabla);

            use Switch;
            switch ($tabla) {
                case 'tema' {
                    $tabla_referer_involved->setNombre($dato);
                    $tabla_referer_involved->save();
                    return $tabla_referer_involved->getId();
                    }
                case 'autor' {
                    my $autor = $dato;


                    C4::AR::Debug::debug("procesarReferencia => AUTOR!!".$dato);
                     $tabla_referer_involved->setApellido("");
                     $tabla_referer_involved->setNombre("");

                    my @autor = split(', ', $dato);
                    if ($autor[0]){
                        $tabla_referer_involved->setApellido($autor[0]);
                        if ($autor[1]){
                          $tabla_referer_involved->setNombre($autor[1]);
                        }
                        else{
                          $tabla_referer_involved->setNombre($autor[0]);
                          }
                     } else {
                        if ($autor[1]){
                          $tabla_referer_involved->setApellido($autor[1]);
                          $tabla_referer_involved->setNombre($autor[1]);
                        }
                      }

                    $tabla_referer_involved->setCompleto($dato);
                    $tabla_referer_involved->save();


                    C4::AR::Debug::debug("NUEVO AUTOR: ".$dato." => ".$tabla_referer_involved->getId());
                    return $tabla_referer_involved->getId();
                    }
                case 'ciudad' {
                    $tabla_referer_involved->setNombre($dato);
                    $tabla_referer_involved->save();
                    C4::AR::Debug::debug("NUEVA CIUDAD: ".$dato." => ".$tabla_referer_involved->getId());
                    return $tabla_referer_involved->getIdLocalidad();
                    }
            }

        }


sub procesarImportacion {
    my($id,$job) = @_;

    my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id);

    if (!$job){
        $job = C4::AR::BackgroundJob->new("IMPORTACION_".$importacion->getNombre(),"NULL",10);
    }

    $importacion->jobID($job->id);
    $importacion->save();

    #Se obtienen los registros NO IGNORADOS; NI IMPORTADOS;  NI QUE MATCHEEN
    my $registros_importar = $importacion->getRegistrosParaImportar();

    my $count = 1;

    foreach my $io_rec (@$registros_importar){
        C4::AR::Debug::debug("Importacion => Procesando registro ".$io_rec->getId());

          eval{
            $io_rec->aplicarImportacion();
            $io_rec->setEstado('IMPORTADO');
            $io_rec->save();
          }or do
          {
           C4::AR::Mensajes::printErrorDB($@, 'B450',"INTRA");
           C4::AR::Debug::debug("Importacion => ERROR en registro ".$io_rec->getId());
           $io_rec->setEstado('ERROR');
           $io_rec->save();
           };

        my $percent = C4::AR::Utilidades::printAjaxPercent(scalar(@$registros_importar),$count);
        $job->progress($percent);

        $count++;
    }

    #Ahora hay que Actualizar los Registros que MATCHEAN y NO ESTAN IGNORADOS.
    #TODO
    #my $registros_actualizar = $importacion->getRegistrosParaActualizar();

    #foreach my $io_rec (@$registros_actualizar){
    #  eval{
        #$io_rec->aplicarImportacion();
        #$io_rec->setEstado('IMPORTADO');
        #$io_rec->save();
    # };

     # if ($@){
     #  &C4::AR::Mensajes::printErrorDB($@, 'B450',"INTRA");
     #  C4::AR::Debug::debug("Importacion => ERROR en registro ".$io_rec->getId());
     #  $io_rec->setEstado('ERROR');
     #  $io_rec->save();
     #  }
    # }
    $importacion->jobID(undef);
    $importacion->save();
}


sub cancelarImportacion{
    my($id,$jobID) = @_;
    my $msg_object = C4::AR::Mensajes::create();

    my $job;

    if ($jobID){
        $job = C4::AR::BackgroundJob->fetch($jobID);
    }

    eval{
        my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id);

        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO020', 'params' => []} ) ;
        $importacion->jobID(undef);
        if ($job){
            $job->finish;
        }
        $importacion->save();
    };

    if ($@){
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO019', 'params' => []} ) ;
    }

    return $msg_object;
}



sub leerValoresCampoImportacion {
    my ($id,$campo) = @_;

    my $hash = ();
    my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id);

    #Limpio el detalle del Esquema
    foreach my $registro ($importacion->registros){
        my $marc = $registro->getRegistroMARCOriginal();
        my $field = $marc->field($campo);
        if($field){
            if($field->is_control_field()){
                my $dato  = $field->data;
                if($hash->{$dato}){
                        $hash->{$dato}++;
                    }else{
                        $hash->{$dato}=1;
                    }
            }else{
                foreach my $subfield ($field->subfields()) {
                    my $dato              = $subfield->[1];
                    if($hash->{$dato}){
                        $hash->{$dato}++;
                    }else{
                        $hash->{$dato}=1;
                    }                }
            }
        }
    }

    return $hash;
}

END { }       # module clean-up code here (global destructor)

1;
__END__
