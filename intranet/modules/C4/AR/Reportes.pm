
package C4::AR::Reportes;


use strict;
no strict "refs";
use C4::Date;


use vars qw(@EXPORT_OK @ISA);
@ISA       = qw(Exporter);
@EXPORT_OK = qw(
  getBusquedasDeUsuario 
  getReportFilter
  getItemTypes
  getConsultasOPAC
  getArrayHash
  toXLS
  registroDeUsuarios
  altasRegistro
  estantesVirtuales
  listarItemsDeInventarioPorSigTop
  listarItemsDeInventarioPorBarcode
  reporteRegistrosNoIndexados
  reporteDisponibilidad
  reporteColecciones
);

sub altasRegistro {

    # FIXME Cambiar a Sphinx!
    # Filtrar por UI cuando se cambie a Sphinx

    my ( $ini, $cantR, $params, $total ) = @_;
    use C4::Modelo::CatRegistroMarcN3;

    my $f_inicio  = $params->{'date_begin'};
    my $f_fin     = $params->{'date_end'};
    my $item_type = $params->{'item_type'};

    my $dateformat = C4::Date::get_date_format();
    my @filtros;

    if ( C4::AR::Utilidades::validateString($f_inicio) ) {
        push(
            @filtros,
            (
                updated_at => {
                    eq => format_date_in_iso( $f_inicio, $dateformat ),
                    gt => format_date_in_iso( $f_inicio, $dateformat )
                }
            )
        );
    }

    if (   ( C4::AR::Utilidades::validateString($item_type) )
        && ( $item_type ne 'ALL' ) )
    {
        push(
            @filtros,
            (
                'nivel2.marc_record' =>
                  { like => '%cat_ref_tipo_nivel3@' . $item_type . '%', }
            )
        );
    }

    if ( C4::AR::Utilidades::validateString($f_fin) ) {
        push(
            @filtros,
            (
                updated_at => {
                    eq => format_date_in_iso( $f_fin, $dateformat ),
                    lt => format_date_in_iso( $f_fin, $dateformat )
                }
            )
        );
    }

    my ($cat_registro_n3);
    if ( ( ( $cantR == 0 ) && ( $ini == 0 ) ) || ($total) ) {
        $cat_registro_n3 =
          C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
            query           => \@filtros,
            select          => ['*'],
            require_objects => [ 'nivel2', 'nivel1' ],
            sort_by         => 'id1 DESC',
          );
    }
    else {
        $cat_registro_n3 =
          C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
            query           => \@filtros,
            select          => ['*'],
            limit           => $cantR,
            offset          => $ini,
            require_objects => [ 'nivel2', 'nivel1' ],
            sort_by         => 'id1 DESC',
          );

    }

    ## Retorna la cantidad total, sin paginar.

    ## FIXME no anda el _count, tuve que poner la agregacion COUNT(*) en el campo id1.
    my ($cat_registro_n3_count) =
      C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
        query           => \@filtros,
        select          => ['COUNT(*) AS agregacion_temp'],
        require_objects => [ 'nivel2', 'nivel1' ],
      );

    $cat_registro_n3_count = $cat_registro_n3_count->[0]->{'agregacion_temp'};

#Este for es sólo para hacer el array de id1, para que se puedar usar armarInfoNivel1
    my @id1_array;

    foreach my $record (@$cat_registro_n3) {
        my $record_item_type = $record->nivel2->getTipoDocumento;
        my %hash_temp        = {};

        $hash_temp{'id1'}     = $record->getId1;
        $hash_temp{'marc_n3'} = $record;

        push( @id1_array, \%hash_temp );
    }

    $params->{'tipo_nivel3_name'} = $item_type;

    my ( $total_found_paginado, $resultsarray ) =
      C4::AR::Busquedas::armarInfoNivel1( $params, @id1_array );

    return ( $cat_registro_n3_count, $resultsarray );

}

sub getReportFilter {
    my ($params) = @_;

    my $tabla_ref   = C4::Modelo::PrefTablaReferencia->new();
    my $alias_tabla = $params->{'alias_tabla'};

    $tabla_ref->createFromAlias($alias_tabla);

}

# FUNCIONES PARA ESTADISTICAS CON OpenFlashChart2
sub random_color {
    my @hex;
    for ( my $i = 0 ; $i < 64 ; $i++ ) {
        my ( $rand, $x );
        for ( $x = 0 ; $x < 3 ; $x++ ) {
            $rand = rand(255);
            $hex[$x] = sprintf( "%x", $rand );
            if ( $rand < 9 ) {
                $hex[$x] = "0" . $hex[$x];
            }
            if ( $rand > 9 && $rand < 16 ) {
                $hex[$x] = "0" . $hex[$x];
            }
        }
    }
    return "\#" . $hex[0] . $hex[1] . $hex[2];
}

sub next_colour {

    my ($position) = @_;

    my @colours_array = (
        "#330000", "#3333FF", "#669900", "#990000",
        "#FF9900", "#9966FF", "#FF9900", "#66FF66"
    );

    return ( @colours_array[$position] );

}

sub getItemTypes {
    my ( $params, $return_arrays ) = @_;

    use C4::Modelo::CatRegistroMarcN2;

    my ($cat_registro_n2) =
      C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2(
        select => ['*'] );

    my @items;
    my @cant;
    my @colours;
    my @array_for_file_export;

    my %item_type_hash = {0};
    if ( ( $params->{'item_type'} ) && ( $params->{'item_type'} ne 'ALL' ) ) {
        foreach my $record (@$cat_registro_n2) {
            my $item_type = $record->getTipoDocumento;
            if ( ( $params->{'item_type'} eq $item_type ) ) {
                if ( !$item_type_hash{$item_type} ) {
                    $item_type_hash{$item_type} = 0;
                }
                $item_type_hash{$item_type}++;
            }
        }
    }
    else {
        foreach my $record (@$cat_registro_n2) {
            my $item_type = $record->getTipoDocumento;
            if ( !$item_type_hash{$item_type} ) {
                $item_type_hash{$item_type} = 0;
            }
            $item_type_hash{$item_type}++;
        }
    }

    my $limit_of_view = 0;

    foreach my $item ( keys %item_type_hash ) {
        $item_type_hash{$item} = int $item_type_hash{$item};
        if ( $item_type_hash{$item} > 0 ) {
            push( @items,   $item );
            push( @cant,    $item_type_hash{$item} );
            push( @colours, next_colour( $limit_of_view++ ) );

            #HASH PARA EXPORTAR
            my %hash_temp;
            $hash_temp{'Cantidad'} = $item_type_hash{$item};
            $hash_temp{'Item'}     = $item;
            push( @array_for_file_export, \%hash_temp );
        }
    }

    sort_and_cumulate( \@items, \@colours, \@cant );

    if ($return_arrays) {
        return ( \@array_for_file_export, 1 );
    }

    return ( \@items, \@colours, \@cant );
}



sub listarItemsDeInventarioPorSigTop{
    my ($params_hash_ref) = @_;

    my @filtros;
    my @info_reporte;
   
    my $ini=$params_hash_ref->{'ini'};
    my $cantR=$params_hash_ref->{'cantR'};  
    
    my $signatura= $params_hash_ref->{'sigtop'};
    
    my $ui_signatura = $params_hash_ref->{'id_ui'};
    my $tipo_ui= $params_hash_ref->{'tipoUI'};

    my $campoRegMARC;

    C4::AR::Debug::debug($tipo_ui);

    if ($tipo_ui eq "Origen"){
        $campoRegMARC= 'dpref_unidad_informacion@'.$ui_signatura;
    } else {
        $campoRegMARC= 'cpref_unidad_informacion@'.$ui_signatura;
    }
    
   
   
    my $db= C4::Modelo::CatRegistroMarcN3->new()->db();

    my $cat_nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( 
                                                                                            db  => $db,
                                                                                            query => [  
                                                                                                  signatura => { eq => $signatura },
                                                                                                  marc_record => { like => '%'.$campoRegMARC.'%' }
                                                                                            ], 
                                                                                            limit   => $cantR,
                                                                                            offset  => $ini,
                                                                                            sort_by => ['signatura'],
                                                                          );

   my $cat_nivel3_array_ref_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count( 
                                                                                            db  => $db,
                                                                                            query => [  
                                                                                                  signatura => { eq => $signatura },
                                                                                                  marc_record => { like => '%'.$campoRegMARC.'%' }
                                                                                            ], 
                                                                                     
                                                                          ); 

    
    my($result)= armarResult($cat_nivel3_array_ref);

    return ($cat_nivel3_array_ref_count, $result);
}


sub listarItemsDeInventarioEntreSigTops{
    my ($params_hash_ref) = @_;

    my @filtros;
    my @info_reporte;
   
    my $ini=$params_hash_ref->{'ini'};
    my $cantR=$params_hash_ref->{'cantR'};  
    
    my $desde_sigtop= $params_hash_ref->{'desde_signatura'};
    my $hasta_sigtop= $params_hash_ref->{'hasta_signatura'};
   
    my $ui_signatura = $params_hash_ref->{'id_ui'};
    my $tipo_ui= $params_hash_ref->{'tipoUI'};

    my $campoRegMARC;

    C4::AR::Debug::debug($tipo_ui);

    if ($tipo_ui eq "Origen"){
        $campoRegMARC= 'dpref_unidad_informacion@'.$ui_signatura;
    } else {
        $campoRegMARC= 'cpref_unidad_informacion@'.$ui_signatura;
    }

    my $db= C4::Modelo::CatRegistroMarcN3->new()->db();

    my $cat_nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( 
                                                                                            db  => $db,
                                                                                            query => [  
                                                                                                    signatura => { between => [ $desde_sigtop, $hasta_sigtop ] },
                                                                                                    marc_record => { like => '%'.$campoRegMARC.'%' }
                                                                                                    
                                                                                            ], 
                                                                                            sort_by => ['signatura'],
                                                                                            limit   => $cantR,
                                                                                            offset  => $ini,
                                                                             ,
                                                                          );

   my $cat_nivel3_array_ref_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count( 
                                                                                            db  => $db,
                                                                                            query => [  
                                                                                                    signatura => { between => [ $desde_sigtop, $hasta_sigtop ] },
                                                                                                    marc_record => { like => '%'.$campoRegMARC.'%' }
                                                                                            ], 
                                                                          ); 

    
    my($result)= armarResult($cat_nivel3_array_ref);


#     my($info_reporte)= armarInforme($cat_nivel3_array_ref);

    return ($cat_nivel3_array_ref_count, $result);
}



sub listarItemsDeInventarioPorBarcode{
    my ($params_hash_ref) = @_;

    my @filtros;
    my @info_reporte;

   
    my $ini=$params_hash_ref->{'ini'};
    my $cantR=$params_hash_ref->{'cantR'};  
    
    my $codigo_barra= $params_hash_ref->{'barcode'};
   
    my $ui_barcode = $params_hash_ref->{'id_ui'};
    my $tipo_ui= $params_hash_ref->{'tipoUI'};

    my $campoRegMARC;

    if ($tipo_ui eq "Origen"){
        $campoRegMARC= 'dpref_unidad_informacion@'.$ui_barcode;
    } else {
        $campoRegMARC= 'cpref_unidad_informacion@'.$ui_barcode;
    }

    my $db= C4::Modelo::CatRegistroMarcN3->new()->db();

    my $cat_nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( 
                                                                                            db  => $db,
                                                                                            query => [  
                                                                                                  codigo_barra => { eq => $codigo_barra },
                                                                                                  marc_record => { like => '%'.$campoRegMARC.'%' }
                                                                                            ], 
                                                                                            sort_by => ['codigo_barra'],
                                                                                            limit   => $cantR,
                                                                                            offset  => $ini,
                                                                              
                                                                          );

   my $cat_nivel3_array_ref_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count( 
                                                                                            db  => $db,
                                                                                            query => [  
                                                                                                  codigo_barra => { eq => $codigo_barra },
                                                                                                  marc_record => { like => '%'.$campoRegMARC.'%' }
                                                                                            ], 
                                                                                       
                                                                          ); 


    
    my($result)= armarResult($cat_nivel3_array_ref);

    return ($cat_nivel3_array_ref_count, $result);
}


sub listarItemsDeInventarioEntreBarcodes{
    my ($params_hash_ref) = @_;

    my @filtros;
    my @info_reporte;

   
    my $ini=$params_hash_ref->{'ini'};
    my $cantR=$params_hash_ref->{'cantR'};  

    my $desde_barcode= $params_hash_ref->{'desde_barcode'};
    my $hasta_barcode= $params_hash_ref->{'hasta_barcode'};

    my $ui_barcode = $params_hash_ref->{'id_ui'};
    my $tipo_ui= $params_hash_ref->{'tipoUI'};

    my $campoRegMARC;

    if ($tipo_ui eq "Origen"){
        $campoRegMARC= 'dpref_unidad_informacion@'.$ui_barcode;
     } else {
        $campoRegMARC= 'cpref_unidad_informacion@'.$ui_barcode;
    }


   
    my $db= C4::Modelo::CatRegistroMarcN3->new()->db();

    my $cat_nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( 
                                                                                            db  => $db,
                                                                                            query => [  
                                                                                                   codigo_barra => { between => [ $desde_barcode, $hasta_barcode ] },
                                                                                                   marc_record => { like => '%'.$campoRegMARC.'%' }
#                                                                                                    codigo_barra => { ge => $desde_barcode },
#                                                                                                    codigo_barra => { le =>  $hasta_barcode },
                                                                                            ], 
                                                                                            sort_by => ['codigo_barra'],
                                                                                            limit   => $cantR,
                                                                                            offset  => $ini,
                                                                                        
                                                                          );

   my $cat_nivel3_array_ref_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count( 
                                                                                            db  => $db,
                                                                                            query => [  
                                                                                                 codigo_barra => { between => [ $desde_barcode, $hasta_barcode ] }
                                                                                            ], 
                                                                                     
                                                                          ); 

    
    my($result)= armarResult($cat_nivel3_array_ref);
  

    return ($cat_nivel3_array_ref_count, $result);
}



sub consultaParaReporte {
    my ($params) = @_;

    my $db= C4::Modelo::CatRegistroMarcN3->new()->db();

    my $cat_nivel3_array_ref;

    if ($params->{'sigtop'}){
            
          my $ui_sigtop = $params->{'id_uisignatura'};
          my $tipo_ui= $params->{'tipoUISignatura'};

          my $campoRegMARC;

          if ($tipo_ui eq "Origen"){
              $campoRegMARC= 'dpref_unidad_informacion@'.$ui_sigtop;
           } else {
              $campoRegMARC= 'cpref_unidad_informacion@'.$ui_sigtop;
           }

        
           $cat_nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( 
                                                                                            db  => $db,
                                                                                            query => [  
                                                                                                  signatura => { eq => $params->{'sigtop'} },
                                                                                                   marc_record => { like => '%'.$campoRegMARC.'%' }
                                                                                                  
                                                                                            ], 
                                                                                            sort_by => ['signatura'],
                                                                          );
    } elsif ($params->{'barcode'}){

          my $ui_barcode = $params->{'id_uibarcode'};
          my $tipo_ui= $params->{'tipoUIBarcode'};

          my $campoRegMARC;

          if ($tipo_ui eq "Origen"){
              $campoRegMARC= 'dpref_unidad_informacion@'.$ui_barcode;
          } else {
              $campoRegMARC= 'cpref_unidad_informacion@'.$ui_barcode;
          }

           $cat_nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( 
                                                                                            db  => $db,
                                                                                            query => [  
                                                                                                  codigo_barra => { eq => $params->{'barcode'} },
                                                                                                   marc_record => { like => '%'.$campoRegMARC.'%' }
                                                                                            ], 
                                                                                            sort_by => ['codigo_barra'],
                                                                          );

    } else {
           if ($params->{'desde_signatura'}){
                
                  my $ui_sigtop = $params->{'id_uisignatura'};
                  my $tipo_ui= $params->{'tipoUISignatura'};

                  my $campoRegMARC;

                  if ($tipo_ui eq "Origen"){
                      $campoRegMARC= 'dpref_unidad_informacion@'.$ui_sigtop;
                   } else {
                        $campoRegMARC= 'cpref_unidad_informacion@'.$ui_sigtop;
                    }
  
                  my $orden = $params->{'sort'} || 'signatura';
                  $cat_nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( 
                                                                                            db  => $db,
                                                                                            query => [  
                                                                                                    signatura => { between => [ $params->{'desde_signatura'}, $params->{'hasta_signatura'} ] },
                                                                                                    marc_record => { like => '%'.$campoRegMARC.'%' }  
                                                                                            ], 
                                                                                            sort_by => ['signatura'],
                                                                          );
           } elsif ($params->{'desde_barcode'}){

                    my $ui_barcode = $params->{'id_uibarcode'};
                    my $tipo_ui= $params->{'tipoUIBarcode'};

                    my $campoRegMARC;

                    if ($tipo_ui eq "Origen"){
                        $campoRegMARC= 'dpref_unidad_informacion@'.$ui_barcode;
                    } else {
                        $campoRegMARC= 'cpref_unidad_informacion@'.$ui_barcode;
                    }

                    my $orden = $params->{'sort'} || 'codigo_barra';
                    $cat_nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( 
                                                                                            db  => $db,
                                                                                            query => [  
                                                                                                   codigo_barra => { between => [ $params->{'desde_barcode'}, $params->{'hasta_barcode'} ] },
                                                                                                    marc_record => { like => '%'.$campoRegMARC.'%' }
                                                                                            ], 
                                                                                            sort_by => ['codigo_barra'],
                                                                                       
                                                                          );

           }


    }

    my $cant_total= scalar(@$cat_nivel3_array_ref);

    C4::AR::Debug::debug($cant_total);

    my ($info_reporte);

    my($info_reporte)= armarInforme($cat_nivel3_array_ref);

    return($cant_total,$info_reporte);
}



sub armarResult{

    my ($cat_nivel3_array_ref) = @_;

    my @result;

    foreach my $reg_nivel_3 (@$cat_nivel3_array_ref){
          my %hash_result;
          my $nivel1 = C4::AR::Nivel1::getNivel1FromId3($reg_nivel_3->getId3);
          my $nivel2 = C4::AR::Nivel2::getNivel2FromId1($nivel1->getId1);

          $hash_result{'nivel1'}= $nivel1; 
          $hash_result{'nivel2'}=  @$nivel2[0];
          $hash_result{'nivel3'}= $reg_nivel_3;

          push(@result, \%hash_result);
    }

    return(\@result);
}


sub armarInforme{

    my ($cat_nivel3_array_ref) = @_;

    my @informe;

#     my @headers= ("Código de barra", "Signatura Topográfica", "Autor", "Título", "Editor", "Edición", "UI Origen", "UI Poseedora");

#     push(@informe,\@headers);

    foreach my $reg_nivel_3 (@$cat_nivel3_array_ref){
          my %hash_result;
          my $nivel1 = C4::AR::Nivel1::getNivel1FromId3($reg_nivel_3->getId3);
          my $nivel2 = C4::AR::Nivel2::getNivel2FromId1($nivel1->getId1);

          $hash_result{'codigo_barra'}= $reg_nivel_3->getCodigoBarra; 
          $hash_result{'signatura'}= $reg_nivel_3->getSignatura;
# @$nivel2[0]

          $hash_result{'autor'}= $nivel1->getAutor;
          $hash_result{'titulo'}= $nivel1->getTitulo;
          $hash_result{'editor'}= @$nivel2[0]->getEditor;
          $hash_result{'edicion'}= @$nivel2[0]->getEdicion." ".@$nivel2[0]->getAnio_publicacion ;
          $hash_result{'ui_origen'}= $reg_nivel_3->getId_ui_origen;
          $hash_result{'ui_poseedora'}=$reg_nivel_3->getId_ui_poseedora;       
              
          push(@informe, \%hash_result);
    }

    return(\@informe);
}


sub getEstantes {
    my ( $params, $return_arrays ) = @_;

    use C4::Modelo::CatContenidoEstante;
    use C4::Modelo::CatContenidoEstante::Manager;
    use C4::Modelo::CatEstante;
    
    my ($cat_estante) = C4::Modelo::CatEstante::Manager->get_cat_estante();

    my @items;
    my @cant;
    my @colours;
    my @array_for_file_export;
    my %estante_hash = {0};

    if ( (C4::AR::Utilidades::validateString($params->{'estante'})) && ($params->{'estante'} ne 'ALL') ){    
        foreach my $record (@$cat_estante) {
            my @filtros = ();
            my $estante = $record->getEstante;
            if ($record->getId == $params->{'estante'}){
                 push(
                 @filtros,
                 (
                      id_estante => {
                           eq => $record->getId,
                       }
                  )
                );
               $estante_hash{$estante} = C4::Modelo::CatContenidoEstante::Manager->get_cat_contenido_estante_count(
                        query => \@filtros,
               );
            }
        }
    }else{
        foreach my $record (@$cat_estante) {
            my @filtros = ();
            my $estante = $record->getEstante;
            push(
                 @filtros,
                 (
                      id_estante => {
                           eq => $record->getId,
                       }
                  )
                );
               $estante_hash{$estante} = C4::Modelo::CatContenidoEstante::Manager->get_cat_contenido_estante_count(
                        query => \@filtros,
               );
        }
    }

    my $limit_of_view = 0;

    foreach my $item ( keys %estante_hash ) {
        $estante_hash{$item} = int $estante_hash{$item};
        if ( $estante_hash{$item} > 0 ) {
            push( @items,   $item );
            push( @cant,    $estante_hash{$item} );
            push( @colours, next_colour( $limit_of_view++ ) );

            #HASH PARA EXPORTAR
            my %hash_temp;
            $hash_temp{'Cantidad'} = $estante_hash{$item};
            $hash_temp{'Item'}     = $item;
            push( @array_for_file_export, \%hash_temp );
        }
    }

    sort_and_cumulate( \@items, \@colours, \@cant );

    if ($return_arrays) {
        return ( \@array_for_file_export, 1 );
    }

    return ( \@items, \@colours, \@cant );
}







sub getConsultasOPAC {
    my ( $params, $return_arrays ) = @_;

    my $total       = $params->{'total'};
    my $registrados = $params->{'registrados'};
    my $tipo_socio  = $params->{'tipo_socio'};
    my $f_inicio    = $params->{'f_inicio'};
    my $f_fin       = $params->{'f_fin'};

    my $dateformat = C4::Date::get_date_format();
    my @filtros;
    use C4::Modelo::RepBusqueda::Manager;

    if ( !$total ) {
        if ($registrados) {
            push( @filtros, ( nro_socio => { ne => undef } ) );
        }
        else {
            push( @filtros, ( nro_socio => { eq => undef } ) );
        }
        if ( C4::AR::Utilidades::validateString($tipo_socio) ) {
            push( @filtros, ( categoria_socio => { eq => $tipo_socio } ) );
        }
        if ( C4::AR::Utilidades::validateString($f_inicio) ) {
            push(
                @filtros,
                (
                    fecha => {
                        eq => format_date_in_iso( $f_inicio, $dateformat ),
                        gt => format_date_in_iso( $f_inicio, $dateformat )
                    }
                )
            );
        }
        if ( C4::AR::Utilidades::validateString($f_fin) ) {
            push(
                @filtros,
                (
                    fecha => {
                        eq => format_date_in_iso( $f_fin, $dateformat ),
                        lt => format_date_in_iso( $f_fin, $dateformat )
                    }
                )
            );
        }

    }

    my ($rep_busqueda) = C4::Modelo::RepBusqueda::Manager->get_rep_busqueda(
        query    => \@filtros,
        group_by => ['categoria_socio'],
        select   => [
            'COUNT(categoria_socio) AS agregacion_temp', 'nro_socio',
            'categoria_socio'
        ],
    );
    if ($return_arrays) {
        return ( $rep_busqueda, 0 );
    }

    my @items;
    my @cant;
    my @colors;
    my $cont = 0;
    foreach my $record (@$rep_busqueda) {
        push( @items,  $record->getCategoria_socio_report );
        push( @cant,   $record->agregacion_temp );
        push( @colors, next_colour( $cont++ ) );
    }

    sort_and_cumulate( \@items, \@colors, \@cant );
    return ( \@items, \@colors, \@cant, $rep_busqueda );
}

sub getArrayHash {

    my ( $function_name, $params ) = @_;
    my ( $items, $colours, $cant ) = &$function_name($params);

    my $i   = 0;
    my $max = scalar(@$items);
    my @data;

    for ( $i = 0 ; $i < $max ; $i++ ) {
        my %hash = {};
        $hash{'item'}  = $items->[$i];
        $hash{'cant'}  = $cant->[$i];
        $hash{'color'} = $colours->[$i];
        push( @data, \%hash );
    }

    return ( \@data );

}

sub sort_and_cumulate {

    my $items   = shift;
    my $colours = shift;
    my $cant    = shift;

    C4::AR::Utilidades::bbl_sort( $cant, $items, $colours );

    my $CUMULATIVE_LIMIT = 7;

    if ( scalar(@$items) > $CUMULATIVE_LIMIT ) {
        my $cant = 0;
        for ( my $i = $CUMULATIVE_LIMIT ; $i < scalar(@$items) ; $i++ ) {
            $cant += $cant->[$i];
            splice( @$cant,    $i, 1 );
            splice( @$items,   $i, 1 );
            splice( @$colours, $i, 1 );
        }
        $items->[$CUMULATIVE_LIMIT] = C4::AR::Filtros::i18n("Otros");
        $cant->[$CUMULATIVE_LIMIT] += $cant;
        $colours->[$CUMULATIVE_LIMIT] = next_colour($CUMULATIVE_LIMIT);
    }
}

=head2 
sub getRepRegistroModificacion

Recupero el registro de modificacion pasado por parámetro
retorna un objeto o 0 si no existe
=cut

sub getRepRegistroModificacion {
    my ( $id, $db ) = @_;

    $db = $db || C4::Modelo::RepRegistroModificacion->new()->db();

    my $rep_registro_modificacion_array_ref =
      C4::Modelo::RepRegistroModificacion::Manager
      ->get_rep_registro_modificacion(
        db    => $db,
        query => [ idModificacion => { eq => $id }, ]
      );

    if ( scalar(@$rep_registro_modificacion_array_ref) > 0 ) {
        return ( $rep_registro_modificacion_array_ref->[0] );
    }
    else {
        return 0;
    }
}

sub titleByUser {
    my ($fileType)    = shift;
    my ($report_type) = shift;

    $report_type = $report_type || C4::AR::Filtros::i18n('reporte');
    $fileType    = $fileType    || 'null';

    my $username = C4::AR::Auth::getSessionNroSocio() || 'GUEST_USER_WARNING';
    my $title = $report_type . "_" . $username . "." . $fileType;

    return ($title);

}

sub toXLS {

    my ($data)             = shift;
    my ($is_array_of_hash) = shift;
    my ($sheet)            = shift;
    my ($report_type)      = shift;
    my ($filename)         = shift;

    use C4::Context;
    use Spreadsheet::WriteExcel;
    use C4::AR::Filtros;

    my $context     = new C4::Context;
    my $reports_dir = $context->config('reports_dir');

    $sheet = $sheet || C4::AR::Filtros::i18n('Resultado');
    $filename =
      $filename
      ? ( $report_type . "_" . $filename )
      : ( titleByUser( 'xls', $report_type ) );

    my $path      = $reports_dir . '/' . $filename;

    C4::AR::Debug::debug($path);
    
    my $workbook  = Spreadsheet::WriteExcel->new($path);
    
    die "Problems creating new Excel file: $!" unless defined $workbook;

    my $worksheet = $workbook->add_worksheet($sheet);
    my $format    = $workbook->add_format();
    my $col;
    my $row;

    $worksheet->set_column( 0, 3, 20 );
    $worksheet->set_column( 1, 3, 20 );
    $worksheet->set_column( 4, 5, 20 );
    $worksheet->set_column( 7, 7, 20 );

    #Escribo los column titles :)

    my $header = $workbook->add_format();
    $header->set_font('Verdana');
    $header->set_align('top');
    $header->set_bold();
    $header->set_size(12);
    $header->set_color('blue');

    if ( !$is_array_of_hash ) {
        if ( scalar(@$data) ) {
            my $campos = $data->[0]->getCamposAsArray;
            my $x      = 0;

            foreach my $campo (@$campos) {
                $worksheet->write( 0, $x++, $campo, $header );
            }

            #FIN column titles
            $row = 1;
            foreach my $dato (@$data) {
                my $campos = $dato->getCamposAsArray;
                $col = 0;
                foreach my $campo (@$campos) {
                    $worksheet->write( $row, $col,
                        Encode::decode_utf8( $dato->{$campo} ), $format );
                    $col++;
                }
                $row++;
            }
        }
    }
    else {

        my $x = 0;

        my $hash_temp = $data->[0];
        foreach my $key ( keys(%$hash_temp) ) {
            $worksheet->write( 0, $x++, $key, $header );
        }

        #FIN column titles
        $row = 1;
        foreach my $hash (@$data) {
            $col = 0;
            foreach my $key ( keys %$hash ) {
                $worksheet->write( $row, $col++,
                    Encode::decode_utf8( $hash->{$key} ), $format );
            }
            $row++;
        }
    }

    return ( $path, $filename );
}

sub getBusquedasOPAC {

    my ( $params, $limit, $offset ) = @_;

    my $total       = $params->{'total'};
    my $registrados = $params->{'registrados'};
    my $tipo_socio  = $params->{'tipo_socio'};
    my $f_inicio    = $params->{'f_inicio'};
    my $f_fin       = $params->{'f_fin'};

    my $dateformat = C4::Date::get_date_format();
    my @filtros;

    use C4::Modelo::RepHistorialBusqueda::Manager;

    if ( !$total ) {
        if ($registrados) {
            push( @filtros, ( 'busqueda.socio.nro_socio' => { ne => undef } ) );
        }
        else {
            push( @filtros, ( 'busqueda.nro_socio' => { eq => undef } ) );
        }
        if (   ( C4::AR::Utilidades::validateString($tipo_socio) )
            && ($registrados) )
        {
            push( @filtros,
            
#           FIXME: ver si anda! cambiado 16/05 porque ahora no esta mas el cod_categoria, esta el id. 
#               ( 'usr_socio.cod_categoria' => { eq => $tipo_socio } ) );

                ( 'usr_socio.id_categoria' => { eq => $tipo_socio } ) );
        }
        if ( C4::AR::Utilidades::validateString($f_inicio) ) {
            push(
                @filtros,
                (
                    fecha => {
                        eq => format_date_in_iso( $f_inicio, $dateformat ),
                        gt => format_date_in_iso( $f_inicio, $dateformat )
                    }
                )
            );
        }
        if ( C4::AR::Utilidades::validateString($f_fin) ) {
            push(
                @filtros,
                (
                    fecha => {
                        eq => format_date_in_iso( $f_fin, $dateformat ),
                        lt => format_date_in_iso( $f_fin, $dateformat )
                    }
                )
            );
        }

    }

    my ($rep_busqueda);

    if ( ( $limit == 0 ) && ( $offset == 0 ) ) {

        ($rep_busqueda) =
          C4::Modelo::RepHistorialBusqueda::Manager->get_rep_historial_busqueda(
            query => \@filtros,
            require_objects =>
              [ 'busqueda', 'busqueda.socio', 'busqueda.socio.persona' ],
            select => [ '*', 'busqueda.*' ],
          );
    }
    else {

        ($rep_busqueda) =
          C4::Modelo::RepHistorialBusqueda::Manager->get_rep_historial_busqueda(
            query => \@filtros,
            require_objects =>
              [ 'busqueda', 'busqueda.socio', 'busqueda.socio.persona' ],
            limit  => $limit,
            offset => $offset,
            select => [ '*', 'busqueda.*' ],
          );
    }

    my ($rep_busqueda_count) =
      C4::Modelo::RepHistorialBusqueda::Manager
      ->get_rep_historial_busqueda_count(
        query           => \@filtros,
        require_objects => [ 'busqueda', 'busqueda.socio', 'busqueda.socio.persona' ],
        
      );
    return ( $rep_busqueda_count, $rep_busqueda );
}

sub registroDeUsuarios {

    my ( $params, $limit, $offset, $total ) = @_;

    my $anio      = $params->{'year'};

    my $categoria = $params->{'category'};
    my $ui        = $params->{'ui'};
    my $name_from = $params->{'name_from'};
    my $name_to   = $params->{'name_to'};

    my $dateformat       = C4::Date::get_date_format();
    my $anio_fecha_start = "01/01/" . $anio;
    my $anio_fecha_end   = "12/31/" . $anio;
    my @filtros;

    use C4::Modelo::UsrSocio::Manager;

    if ($categoria) {
    
#       FIXME: ver si anda! cambiado 16/05 porque ahora no esta mas el cod_categoria, esta el id. 
#       push( @filtros, ( 'cod_categoria' => { eq => $categoria } ) );

        push( @filtros, ( 'id_categoria' => { eq => $categoria } ) );
    }
    if ($ui) {
        push( @filtros, ( 'id_ui' => { eq => $ui } ) );
    }
    if ( ( C4::AR::Utilidades::validateString($name_to) ) ) {
        push( @filtros,
            ( 'persona.apellido' => { like => $name_to.'%', lt => $name_to } ) );
    }
    if ( ( C4::AR::Utilidades::validateString($name_from) ) ) {
        push( @filtros,
            ( 'persona.apellido' => { like => $name_from.'%', gt => $name_from } ) );
    }
    if ( ($anio) && ( $anio =~ /^-?[\.|\d]*\Z/ ) ) {
        push(
            @filtros,
            (
                'fecha_alta' =>
                  { eq => $anio_fecha_start, gt => $anio_fecha_start }
            )
        );
        push(
            @filtros,
            (
                'fecha_alta' => { eq => $anio_fecha_end, lt => $anio_fecha_end }
            )
        );
    }

    my ($rep_busqueda);
    if ( ( ( $limit == 0 ) && ( $offset == 0 ) ) || ($total) ) {
        ($rep_busqueda) = C4::Modelo::UsrSocio::Manager->get_usr_socio(
            query           => \@filtros,
            require_objects => ['persona', 'categoria'],
            select          => [ '*', 'persona.*' ],
        );
    }
    else {

        ($rep_busqueda) = C4::Modelo::UsrSocio::Manager->get_usr_socio(
            query           => \@filtros,
            require_objects => ['persona', 'categoria'],
            select          => [ '*', 'persona.*' ],
            limit           => $limit,
            offset          => $offset,
        );
    }

    my ($rep_busqueda_count) =
      C4::Modelo::UsrSocio::Manager->get_usr_socio_count(
        query           => \@filtros,
        require_objects => ['persona', 'categoria'],
      );
      
      
    return ( $rep_busqueda_count, $rep_busqueda );

}

sub reporteDisponibilidad{
    my ($params) = @_;

    C4::AR::Utilidades::printHASH($params);

    my $ui=         $params->{'ui'};
    my $disponibilidad=     $params->{'disponibilidad'};
    my $estado=         $params->{'estado'};


    my $ini    = $params->{'ini'} || 0;
    my $cantR  = $params->{'cantR'} || 1;

    my $catRegistroMarcN3  = C4::Modelo::CatRegistroMarcN3->new();
    my $db = $catRegistroMarcN3->db; 

    my @filtros;

    if ($ui ne ""){
        push (@filtros, ("marc_record"    => { like   => '%@'.$ui.'%'}));
    }

    if ($estado ne ""){
        push (@filtros, ("marc_record"    => { like   => '%@'.$estado.'%'}));
    }

    if ($disponibilidad ne "" && $disponibilidad ne "SIN SELECCIONAR" ){
        push (@filtros, ("marc_record"    => { like   => '%@'.$disponibilidad.'%'}));
    } 

    # if ($fecha_ini ne "" && $fecha_fin ne ""){
    #         $fecha_ini= C4::Date::format_date($fecha_ini,"iso")."00:00:00";
    #         $fecha_fin= C4::Date::format_date($fecha_fin,"iso")." 23:59:59";
    #         push(@filtros, and => [ 'timestamp' => { gt => $fecha_ini, eq => $fecha_ini },
    #                                 'timestamp' => { lt => $fecha_fin, eq => $fecha_fin} ] ); 
    # } elsif($fecha_ini ne ""){
    #         $fecha_ini= C4::Date::format_date($fecha_ini,"iso")."00:00:00";
    #         push (@filtros, ('timestamp' => { gt => $fecha_ini, eq => $fecha_ini }));

    # } elsif($fecha_fin ne ""){
    #         $fecha_fin= C4::Date::format_date($fecha_fin,"iso")." 23:59:59";
    #         push (@filtros, ('timestamp' => { lt => $fecha_fin, eq => $fecha_fin }));
    #     }

    my $cant = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count(   
                                                                        db  => $db,
                                                                        query => \@filtros, 
                                                                        require_objects => ['nivel2'],
                                        );


    my $disp_array_ref;

    if ($params->{'exportar'}){
            $disp_array_ref= C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(   
                                                                        db  => $db,
                                                                        query => \@filtros, 
                                                                        require_objects => ['nivel2'],
            );

    } else {
       
                                  
            $disp_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(   
                                                                                    db  => $db,
                                                                                    limit => $cantR,
                                                                                    offset => $ini,
                                                                                    query => \@filtros, 
                                                                                    require_objects => ['nivel2'],
            );


    }

    
    return ($disp_array_ref ,$cant);


}

sub reporteColecciones{
        my ($params)    = @_;

        my $tipo_doc    = $params->{'item_type'};
        my $ui          = $params->{'ui'};

        my $fecha_ini   = $params->{'fecha_ini'};
        my $fecha_fin   = $params->{'fecha_fin'};

        my $ini         = $params->{'ini'} || 0;
        my $cantR       = $params->{'cantR'} || 1;

        my $nro_socio   = $params->{'nro_socio'}; 

        my $catRegistroMarcN3   = C4::Modelo::CatRegistroMarcN3->new();  
        my $db = $catRegistroMarcN3->db;
        
        my @filtros;

        if ($tipo_doc ne "" && $tipo_doc ne "ALL"){
            push (@filtros, ("t2.marc_record"    => { like   => '%acat_ref_tipo_nivel3@'.$tipo_doc.'%'}));
        } 

        if ($nro_socio ne ""){

            my ($socio) = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);

            if ($socio){
                push( @filtros, ( 'created_by' => { eq => $socio->getId_socio() } ) );
            }
        } 

        if ($params->{'nivel_biblio'} ne ""){
            my $niv_biblio= C4::Modelo::RefNivelBibliografico->new();
            my $niv_biblio_object = $niv_biblio->getObjetoById($params->{'nivel_biblio'});
            my $niv_biblio_code = $niv_biblio_object->getCode();

            push (@filtros, ("t2.marc_record"    => { like   => '%bref_nivel_bibliografico@'.$niv_biblio_code.'%'}));
        } 

        if ($ui ne ""){
            push (@filtros, ("t1.marc_record"    => { like   => '%@'.$ui.'%'}));
        }

        if ($fecha_ini ne "" && $fecha_fin ne ""){
            $fecha_ini= C4::Date::format_date_hour($fecha_ini,"iso");
            $fecha_fin= C4::Date::format_date_hour($fecha_fin,"iso");
            push(@filtros, and => [ 'created_at' => { gt => $fecha_ini, eq => $fecha_ini },
                                    'created_at' => { lt => $fecha_fin, eq => $fecha_fin} ] ); 
        } elsif($fecha_ini ne ""){
            $fecha_ini= C4::Date::format_date_hour($fecha_ini,"iso");
            push (@filtros, ('created_at' => { gt => $fecha_ini, eq => $fecha_ini }));

        } elsif($fecha_fin ne ""){
            $fecha_fin= C4::Date::format_date_hour($fecha_fin,"iso");
            push (@filtros, ('created_at' => { lt => $fecha_fin, eq => $fecha_fin }));
        }

        my $nivel3_array_ref_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count(   
                                                                        db  => $db,
                                                                        query => \@filtros, 
                                                                        require_objects => ['nivel2'],
                                        );


        my $nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(   
                                                                        db  => $db,
                                                                        limit => $cantR,
                                                                        offset => $ini,
                                                                        query => \@filtros, 
                                                                        require_objects => ['nivel2'],
                                        );

        # Hago la consulta de nuevo sin paginar para recuperar el total del niveles 1 y 2.   

        my $nivel3_array_ref_completo = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(   
                                                                        db  => $db,
                                                                        query => \@filtros, 
                                                                        require_objects => ['nivel2'],
                                        );

        my %n1;
        my %n2;

        foreach my $n3 (@$nivel3_array_ref_completo){
            $n1{$n3->id1}='';
            $n2{$n3->id2}='';
        }

    
        my $cant_n1 = scalar keys %n1;
        my $cant_n2 = scalar keys %n2;

        return ($nivel3_array_ref, $nivel3_array_ref_completo ,$nivel3_array_ref_count, $cant_n1, $cant_n2);
 }


sub reporteEstantesVirtuales{
    my ($params) = @_;

        my $estante=         $params->{'estante'};

        my $ini    = $params->{'ini'} || 0;
        my $cantR  = $params->{'cantR'} || 1;

        my $subEstantes = C4::AR::Estantes::getSubEstantes($estante);

        # return ($subEstantes, scalar(@$subEstantes));


        my %estantes;
       
        my %ids3;

        
        foreach my $estante (@$subEstantes){
        

            my $cantNiv1 = 0;
            my $cantNiv2 = 0;
            my $cantNiv3 = 0;
          
            my $noDisponibles = 0;
            my $cantSala = 0;
            my $cantPrestamo = 0;
            
          
            my %info_estante;
            my %ids1;
            my $contenido = $estante->contenido;

            $cantNiv2 = scalar(@$contenido);
            if ($contenido){
                foreach my $c (@$contenido){

                    my $niv1= $c->nivel2->nivel1;
                    
                    if($c->nivel2 && $c->nivel2->nivel1){
                        
                        # C4::AR::Nivel1::getNivel1FromId2($c->id2); 
                        if (!$ids1{$niv1->id}){
                            $ids1{$niv1->id}= 1;
                            my $niveles3 = C4::AR::Nivel3::getNivel3FromId1($niv1->id);

                            $cantNiv3 = $cantNiv3 + scalar(@$niveles3); 
                            #C4::AR::Nivel3::cantNiveles3FromId1($niv1->id);
                            
                            foreach my $n3 (@$niveles3){
                                
                                my $prestado  = 0;
                                if($n3->estaPrestado()){
                                    $prestado=1;
                                }
                                my $reservado = 0;

                                if($n3->estaReservado()){
                                    $reservado=1;
                                }

                                if ( ($prestado + $reservado) ==  0 ) {
                                    
                                   
                                
                                    if ($n3->esParaSala()) {
                                        $cantSala = $cantSala + 1;

                                    } else {
                                        $cantPrestamo = $cantPrestamo + 1;
                                    }
                                    
                                } else {
                                    $noDisponibles ++;
                                }
                            }                       
                        }
                    
                    }
                    # my ($detalle_disp,$arreglo) = C4::AR::Nivel3::detalleDisponibilidadNivel3($c->id2);
                    # # $noDisponibles = $noDisponibles + $detalle_disp->{""};
                    # $cantSala = $cantSala + $detalle_disp->{"cantParaSala"};
                    # $cantPrestamo = $cantPrestamo + $detalle_disp->{"cantParaPrestamo"};
                     $cantNiv1 = $cantNiv1 + scalar keys %ids1;
                } 
            }

            $info_estante{"nombreEstante"} = $estante->estante;
            $info_estante{"niveles1"} = $cantNiv1;
            $info_estante{"niveles2"} = $cantNiv2;
            $info_estante{"niveles3"} = $cantNiv3;
            $info_estante{"cantPrestamo"} = $cantPrestamo;
            $info_estante{"cantSala"} = $cantSala;
            $info_estante{"noDisponibles"} = $noDisponibles;
            $estantes{$estante->id} = \%info_estante;
        }
        
        return (\%estantes, scalar keys %estantes);
        
        
}


sub reporteRegistrosNoIndexados{

    use C4::Modelo::CatRegistroMarcN1;
    use C4::Modelo::CatRegistroMarcN1::Manager;

    my @filtros;
    my @resultsarray;
    my $params;
    my $db = C4::Modelo::DB::AutoBase1->new_or_cached;
    
    my $sth = $db->dbh->prepare('SELECT id FROM cat_registro_marc_n1 WHERE id NOT IN (SELECT id FROM indice_busqueda)');

    $sth->execute();
    @resultsarray = $sth->fetchrow_array();

    my @id1_array;

    foreach my $id1 (@resultsarray){
        my %hash_temp = {};
        $hash_temp{'id1'} = $id1;

        push (@id1_array, \%hash_temp);
    }

    my ($total_found_paginado, $result) = C4::AR::Busquedas::armarInfoNivel1($params, @id1_array);

    return ( scalar(@$result),$result );
}

sub estantesVirtuales {

    my ( $id_estante ) = @_;

    use C4::Modelo::CatEstante;
    use C4::Modelo::CatEstante::Manager;
    use C4::Modelo::CatContenidoEstante;
    use C4::Modelo::CatContenidoEstante::Manager;

    my @filtros;
    my $resultsarray;
    
    push( @filtros, ( id => { eq => $id_estante } ) );
    
    $resultsarray = C4::Modelo::CatEstante::Manager->get_cat_estante(
                            query   => \@filtros,
                            
    );

    return ( $resultsarray );

}

sub getBusquedasDeUsuario {

    my ( $datos_busqueda, $ini, $cantR ) = @_;


    my $limit_pref          = C4::AR::Preferencias::getValorPreferencia('paginas') || 10;
    $cantR                  = $cantR || $limit_pref;
    my $nro_socio           = $datos_busqueda->{'usuario'};
    my $categoria           = ($datos_busqueda->{'categoria'})?C4::AR::Referencias::getCategoryCodeById($datos_busqueda->{'categoria'})->getCategory_code:"";
    my $interfaz            = $datos_busqueda->{'interfaz'};
    my $valor               = $datos_busqueda->{'valor'};
    my $fecha_inicio        = $datos_busqueda->{'fecha_inicio'};
    my $fecha_fin           = $datos_busqueda->{'fecha_fin'};
    my $statistics          = $datos_busqueda->{'statistics'};
    my $orden               = $datos_busqueda->{'orden'};


    my @filtros;
    my $resultsarray;

    my @filtro;
    
    if ($nro_socio){
         push(@filtro,('nro_socio' => {eq  => $nro_socio }));
    }
    if ($categoria){
         push(@filtro,('busqueda.categoria_socio' =>  {eq => $categoria} ));
    }
  
    if ($interfaz ne "Ambas" ){     
             push(@filtro,('tipo' => { eq => $interfaz}));
    }   

    if ($valor){
        push(@filtro, ('valor'  =>  { like => '%'.$valor.'%'}));
    }
   
    if ($fecha_inicio ne '' && $fecha_fin ne ''){
        $fecha_inicio= C4::Date::format_date_hour($fecha_inicio,"iso");
        $fecha_fin= C4::Date::format_date_hour($fecha_fin,"iso");
        push( @filtro, and => [ 'busqueda.fecha' => { gt => $fecha_inicio, eq => $fecha_inicio },
                                'busqueda.fecha' => { lt => $fecha_fin, eq => $fecha_fin} ] ); 
    }

     push( @filtros,( and => [@filtro] ));
#     if ($statistics){
# 
#     }

    my $resultsarray = C4::Modelo::RepHistorialBusqueda::Manager->get_rep_historial_busqueda( 
                                                                      query   => \@filtros,
                                                                      limit   => $cantR,
                                                                      offset  => $ini,
                                                                      require_objects => ['busqueda'],
                                                                      with_objects => [],
                                                                      select       => ['busqueda.*','rep_historial_busqueda.*'],
                                                                      # sort_by => $orden,
                                                                      sort_by => "busqueda.fecha DESC",
                                                          );


    my $all_results = C4::Modelo::RepHistorialBusqueda::Manager->get_rep_historial_busqueda( 
                                                                      query   => \@filtros,           
                                                                      require_objects => ['busqueda'],
                                                                      with_objects => [],
                                                                      select       => ['busqueda.*','rep_historial_busqueda.*'],
                                                                      sort_by => "busqueda.fecha DESC",
                                                                      # sort_by => $orden,
                                                          );

   
    my ($rep_busqueda_count) = C4::Modelo::RepHistorialBusqueda::Manager->get_rep_historial_busqueda_count(
                                                                              query   => \@filtros,
                                                                              require_objects => ['busqueda'],
                                                                              with_objects => [],
                                                              
                                                                            );
                                                                            

    return ($resultsarray, $rep_busqueda_count, $all_results);

}

=item
    Funcion que genera el reporte de circulacion general
=cut
sub getReporteCirculacionGeneral{

    my ($data)          = @_;
    my $categoria       = $data->{'categoriaSocio'};
    my $tipoPrestamo    = C4::AR::Utilidades::trim($data->{'tipoPrestamo'});
    my $fecha_inicio    = $data->{'fecha_inicio'};
    my $fecha_fin       = $data->{'fecha_fin'};
    my $statistics      = $data->{'statistics'};
    my $orden           = $data->{'orden'};
    my $sentido         = $data->{'asc'};
    my $responsable     = $data->{'nroSocio'};
    my $tipo_documento  = $data->{'tipo_documento'};

    my @filtros;

    if ( C4::AR::Utilidades::validateString($tipoPrestamo) && $tipoPrestamo ne "SIN SELECCIONAR" && $tipo_documento ne "ALL" ) {
        push(@filtros, ('tipo_prestamo_ref.id_tipo_prestamo' =>  {eq => $tipoPrestamo} ));
    }

    if ( C4::AR::Utilidades::validateString($categoria) ) {
        push(@filtros, ('socio.id_categoria' =>  {eq => $categoria} ));
    }

    if ( C4::AR::Utilidades::validateString($responsable) ) {
        push(@filtros, ('responsable_ref.nro_socio' =>  {eq => $responsable} ));
    }

    my $desde = C4::AR::Filtros::i18n('Desde');
    my $hasta = C4::AR::Filtros::i18n('Hasta');

    if ($fecha_inicio && ($fecha_inicio ne $desde) && $fecha_fin && ($fecha_fin ne $hasta)) {
        $fecha_inicio   = C4::Date::format_date($fecha_inicio, "iso");
        $fecha_fin      = C4::Date::format_date($fecha_fin, "iso");

        push( @filtros, and => [ 'fecha' => { ge => $fecha_inicio },
                                'fecha' => { le => $fecha_fin } ] ); 
    }

    if($tipo_documento ne "" && $tipo_documento ne "ALL"){
        push(@filtros, ('nivel2.marc_record' => {like => '%cat_ref_tipo_nivel3@'.$tipo_documento.'%'}));
    }


    # cantidad de ejemplares prestados (<> id3)
    my $total_ejemplares_array = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion( 
                                                                      query             => \@filtros,
                                                                      require_objects   => [ 'nivel3', 'nivel2', 'socio', 'tipo_prestamo_ref', 'responsable_ref' ],
                                                                      select            => ['id3'],
                                                                      distinct          => 1,
                                                        );



    # cantidad de socios (<> nro_socio)
    my $cant_nro_socio = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion( 
                                                                      query             => \@filtros,
                                                                      require_objects   => ['nivel3', 'nivel2', 'socio', 'tipo_prestamo_ref', 'responsable_ref' ],
                                                                      select            => ['nro_socio'],
                                                                      distinct          => 1,
                                                        );


    # cantidad de devoluciones 
    my @filtros_tmp = @filtros;
    push(@filtros_tmp, ('tipo_operacion' =>  {eq => 'DEVOLUCION'} ));
    my $cant_devoluciones = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion( 
                                                                      query             => \@filtros_tmp,
                                                                      require_objects   => [ 'nivel3', 'nivel2', 'socio', 'tipo_prestamo_ref', 'responsable_ref' ],
                                                                      select            => ['tipo_operacion'],
                                                        );

    # cantidad de renovaciones
    my @filtros_tmp = @filtros;
    push(@filtros_tmp, ('tipo_operacion' =>  {eq => 'RENOVACION'} ));
    my $cant_renovaciones = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion( 
                                                                      query             => \@filtros_tmp,
                                                                      require_objects   => [ 'nivel3', 'nivel2', 'socio', 'tipo_prestamo_ref', 'responsable_ref' ],
                                                                      select            => ['tipo_operacion'],
                                                        );

    # # cantidad de domiciliarios
    # my @filtros_tmp = @filtros;
    # push(@filtros_tmp, ('tipo_prestamo' =>  {eq => 'DO'} ));
    # my $cant_domiciliario = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion( 
    #                                                                   query             => \@filtros_tmp,
    #                                                                   require_objects   => [ 'nivel3','socio', 'tipo_prestamo_ref', 'responsable_ref' ],
    #                                                                   select            => ['tipo_prestamo'],
                                                                    
    #                                                     );



    # cant for paginator
    my $ejemplaresArrayCant = scalar(@$total_ejemplares_array);

    # totals, to be shown at the bottom of the page
    my %data_hash;   

    $data_hash{'cantidad_usuarios'}      = scalar(@$cant_nro_socio);
    $data_hash{'cantidad_devoluciones'}  = scalar(@$cant_devoluciones);
    $data_hash{'cantidad_renovaciones'}  = scalar(@$cant_renovaciones);
    # $data_hash{'cantidad_domiciliario'}  = scalar(@$cant_domiciliario);

    return ($ejemplaresArrayCant, \%data_hash);
}

=item
    Funcion que busca las reservas en circulacion
=cut
sub getReservasCirculacion {

    my ( $datos_busqueda, $para_exportar , $ini, $cantR ) = @_;


    my $limit_pref      = C4::AR::Preferencias::getValorPreferencia('paginas') || 10;
    $cantR              = $cantR || $limit_pref;
 
    my $categoria       = $datos_busqueda->{'categoriaSocio'};
    my $tipoDoc         = $datos_busqueda->{'tipoDoc'};
    my $titulo          = $datos_busqueda->{'titulo'};
    my $autor           = $datos_busqueda->{'autor'};
    my $estadoReserva   = $datos_busqueda->{'estadoReserva'};
    my $fecha_inicio    = $datos_busqueda->{'fecha_inicio'};
    my $fecha_fin       = $datos_busqueda->{'fecha_fin'};
    my $signatura       = $datos_busqueda->{'signatura'};
    my $orden           = $datos_busqueda->{'orden'};

    my @filtros;
    my $resultsarray;

#    my @filtro;
    C4::AR::Debug::debug("Reportes => tipo => ".$tipoDoc);

    #OK
    if ($categoria){
         push(@filtros,('socio.id_categoria' =>  {eq => $categoria} ));
    }
    
    #OK, forkeado el nombre de la tabla
    if ($tipoDoc){
         push(@filtros, ('cat_registro_marc_n2.marc_record' =>  { like => '%cat_ref_tipo_nivel3%'.$tipoDoc.'%'} ));
    }
    
    #OK, forkeado el nombre de la tabla
    if ($titulo){
         push(@filtros, ('indice_busqueda.titulo' =>  { like => '%'.$titulo.'%'} ));
    } 

    if ($autor){
         push(@filtros, ('indice_busqueda.autor' =>  { like => '%'.$autor.'%'} ));
    }     

    if ($signatura){
         push(@filtros, ('cat_registro_marc_n3.signatura' =>  {like => '%'.$signatura.'%'} ));
    }  
    
    #OK, ver cuando se relaciona con $tipoReserva
    
    if ($estadoReserva ne "TODAS"){
        if($estadoReserva eq "RESERVA"){         
            push( @filtros, ('tipo_operacion'   => {  eq => 'RESERVA' })); 
                                    
        } elsif($estadoReserva eq "ASIGNACION"){         
            push( @filtros, ('tipo_operacion'   => {  eq => 'ASIGNACION' })); 
                                    
        } elsif($estadoReserva eq "CANCELACION"){ 
            push( @filtros, and => [
                                    'tipo_operacion'   => { eq => 'CANCELACION' },
                                    'responsable'  => { ne => 'sistema'}
                                    ]);
                                    
        } elsif($estadoReserva eq "CANCELACION SISTEMA"){ 
            push( @filtros, and => [
                                    'tipo_operacion'   => { eq => 'CANCELACION' }, 
                                    'responsable'  => { eq => 'sistema'}
                                    ]); 

        } elsif($estadoReserva eq "ESPERA"){ 
            push( @filtros, ('tipo_operacion' => { eq => 'ESPERA' })); 
        }

    } else {
        push( @filtros, and => [ 'tipo_operacion'   => { ne => 'PRESTAMO' },  
                                'tipo_operacion'    => { ne => 'DEVOLUCION'},
                                'tipo_operacion'    => { ne => 'RENOVACION'}, 
                                'tipo_operacion'    => { ne => 'NOTIFICACION'}]); 
    }

    my $desde = C4::AR::Filtros::i18n('Desde');
    my $hasta = C4::AR::Filtros::i18n('Hasta');

    if ($fecha_inicio && $fecha_fin && $fecha_inicio ne $desde && $fecha_fin ne $hasta) {

        $fecha_inicio   = C4::Date::format_date($fecha_inicio, "iso");
        $fecha_fin      = C4::Date::format_date($fecha_fin, "iso");

        push( @filtros, and => ['fecha' => { ge => $fecha_inicio },
                                'fecha' => { le => $fecha_fin } ] ); 
    }

    my $resultsArray;
    
    if ($para_exportar) {
        # Todos los resultados para exportar
        $resultsArray = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion( 
                                                                      query   => \@filtros,
                                                                      with_objects   => ['socio', 'nivel1', 'nivel1.IndiceBusqueda', 'nivel2', 'nivel3'],
                                                                      sort_by           => $orden
                                                        );
    }else{
        # Resultados para el paginador
        $resultsArray = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion( 
                                                                      query   => \@filtros,
                                                                      limit   => $cantR,
                                                                      offset  => $ini,
                                                                      with_objects   => ['socio', 'nivel1', 'nivel1.IndiceBusqueda', 'nivel2', 'nivel3'],
                                                                      sort_by           => $orden
                                                        );    
    }
    # Cantidad total
    my ($rep_busqueda_count) = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion_count(
                                                                            query   => \@filtros,
                                                                            with_objects => ['socio', 'nivel1', 'nivel1.IndiceBusqueda', 'nivel2', 'nivel3']
                                                              
                                                                            );



    return ($resultsArray, $rep_busqueda_count);

}

sub reporteGenEtiquetasPorRangoFechas{
    my ($params, $session, $ini, $cantR) = @_;

    my @datos_array;
    my @filtros;
    my $dateformat  = C4::Date::get_date_format();
    my $f_ini       = format_date_in_iso($params->{'fecha_ini'},$dateformat);
    my $f_fin       = format_date_in_iso($params->{'fecha_fin'},$dateformat);

    push(@filtros, ( created_at   => { eq => $f_ini, gt => $f_ini } ) );
    push(@filtros, ( created_at   => { eq => $f_fin, lt => $f_fin } ) );

    my $cat_registro_marc_n3_array = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
                                                                query           => \@filtros,
                                                                limit           => $cantR,
                                                                offset          => $ini,
                                                            );

    my $cat_registro_marc_n3_array_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count(
                                                                query           => \@filtros
                                                            );

    foreach my $hash (@$cat_registro_marc_n3_array){
        my %hash_temp = {};

        $hash_temp{'nivel3'}   = $hash;

        push (@datos_array, \%hash_temp);
    }

    return ($cat_registro_marc_n3_array_count, \@datos_array);  
}

sub reporteGenEtiquetasPorRangoBarcode{
    my ($params, $session, $ini, $cantR) = @_;

    my @datos_array;
    my @filtros;

    push(@filtros, ( codigo_barra   => { eq => $params->{'codBarra1'}, gt => $params->{'codBarra1'} } ) );
    push(@filtros, ( codigo_barra   => { eq => $params->{'codBarra2'}, lt => $params->{'codBarra2'} } ) );

    my $cat_registro_marc_n3_array = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
                                                                query           => \@filtros,
                                                                limit           => $cantR,
                                                                offset          => $ini,
                                                                with_objects    => ['nivel1', 'nivel2'],
                                                            );

    my $cat_registro_marc_n3_array_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count(
                                                                query           => \@filtros,
                                                                with_objects    => ['nivel1', 'nivel2'],
                                                            );


    foreach my $hash (@$cat_registro_marc_n3_array){
        my %hash_temp = {};

        $hash_temp{'nivel3'}  = $hash;

        push (@datos_array, \%hash_temp);
    }

    return ($cat_registro_marc_n3_array_count, \@datos_array);  
}


sub reporteGenEtiquetasPorRangoSignatura{
    my ($params, $session, $ini, $cantR) = @_;

    my @datos_array;
    my @filtros;

    push(@filtros, ( signatura   => { eq => $params->{'signatura1'}, gt => $params->{'signatura1'} } ) );
    push(@filtros, ( signatura   => { eq => $params->{'signatura2'}, lt => $params->{'signatura2'} } ) );

    my $cat_registro_marc_n3_array = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
                                                                query           => \@filtros,
                                                                limit           => $cantR,
                                                                offset          => $ini,
                                                                with_objects    => ['nivel1', 'nivel2'],
                                                            );

    my $cat_registro_marc_n3_array_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count(
                                                                query           => \@filtros,
                                                                with_objects    => ['nivel1', 'nivel2'],
                                                            );


    foreach my $hash (@$cat_registro_marc_n3_array){
        my %hash_temp = {};

        $hash_temp{'nivel3'}  = $hash;

        push (@datos_array, \%hash_temp);
    }

    return ($cat_registro_marc_n3_array_count, \@datos_array);  
}

sub reporteGenEtiquetas{
    my ($params, $session) = @_;

    use Sphinx::Search;
    use Text::Unaccent;
    
    my $only_sphinx     = $params->{'only_sphinx'};
    my $sphinx          = Sphinx::Search->new();
    
     
    $sphinx->SetLimits($params->{'ini'}, C4::AR::Preferencias::getValorPreferencia('paginas'));  


    my $query   = '';
    my $tipo    = 'SPH_MATCH_EXTENDED';
    my $orden   = $params->{'orden'} || 'titulo';
    my $sentido_orden   = $params->{'sentido_orden'};
    my $keyword;
   
    if($params->{'titulo'} ne ""){
        $keyword = unac_string('utf8',$params->{'titulo'});
        $query .= ' @titulo "'.$keyword;
        $query .= "*";
        $query .= '"';     
    }

    if($params->{'autor'} ne ""){
        $keyword = unac_string('utf8',$params->{'autor'});
        $query .= ' @autor "'.$keyword;
        $query .= "*";
        $query .='"';

    }

    if( $params->{'codBarra1'} ne "") {
        $query .= ' @string "'.'barcode%'.$sphinx->EscapeString($params->{'codBarra'}).'*"';
    }

    if ($params->{'signatura1'}){
        $query .= ' @string "'."signatura%".$sphinx->EscapeString($params->{'signatura'}).'*"';
    }
    
    C4::AR::Debug::debug("Reportes => query string => ".$query);

    my $tipo_match = C4::AR::Utilidades::getSphinxMatchMode($tipo);

    $sphinx->SetMatchMode($tipo_match);
    
    $sphinx->SetEncoders(\&Encode::encode_utf8, \&Encode::decode_utf8);

    # NOTA: sphinx necesita el string decode_utf8
   
    my $index_to_use = C4::AR::Preferencias::getValorPreferencia("nombre_indice_sphinx") || 'test1';

    my $results = $sphinx->Query($query, $index_to_use);

    my @datos;
    my $matches = $results->{'matches'};

    my $total_found = $results->{'total_found'};
    # $params->{'total_found'} = $total_found;

    C4::AR::Debug::debug("total_found: ".$total_found);
    C4::AR::Debug::debug("Reportes.pm => LAST ERROR: ".$sphinx->GetLastError());
    C4::AR::Debug::debug("MATCH_MODE => ".$tipo);
    
    foreach my $hash (@$matches){
        my %hash_temp = {};
        my $cat_registro_marc_n3_array  = C4::AR::Nivel3::getNivel3FromId1($hash->{'doc'});
        $hash_temp{'nivel2_array'}      = C4::AR::Nivel2::getNivel2FromId1($hash->{'doc'});
        $hash_temp{'nivel3_array'}      = $cat_registro_marc_n3_array;

        foreach my $hash (@$cat_registro_marc_n3_array){
            my %hash_temp = {};

            $hash_temp{'nivel3'}   = $hash;

            push (@datos, \%hash_temp);
        }

    }  

    return ($total_found, \@datos);
}

sub reporteGenerarEtiquetas{
    my ($params, $session, $ini, $cantR) = @_;

    if( (C4::AR::Utilidades::trim($params->{'signatura1'}) ne "") && (C4::AR::Utilidades::trim($params->{'signatura2'}) ne "") ){
        reporteGenEtiquetasPorRangoSignatura($params, $session, $ini, $cantR);
    }
    elsif( (C4::AR::Utilidades::trim($params->{'codBarra1'}) ne "") && (C4::AR::Utilidades::trim($params->{'codBarra2'}) ne "") ){
        reporteGenEtiquetasPorRangoBarcode($params, $session, $ini, $cantR);
    } elsif( ($params->{'fecha_ini'} ne "") && ($params->{'fecha_fin'} ne "") ){
        reporteGenEtiquetasPorRangoFechas($params, $session, $ini, $cantR);
    } else {
        reporteGenEtiquetas($params, $session);       
    }

}

sub reportToPDF{
    my ($datos, $cantidad, $headers) = @_;

    my $reporte = {
                      destination        => "/home/dan/my_fantastic_report.pdf",
                      paper              => "A4",
                      orientation        => "portrait",
#                     template           => '/home/dan/my_page_template.pdf',
                      font_list          => [ "Verdana" ],
                      default_font       => "Verdana",
                      default_font_size  => "10",
                      info               => {
                                                Author      => "Meran",
#                                                 Keywords    => "Fantastic, Amazing, Superb",
#                                                 Subject     => "Stuff",
                                                Title       => "Reporte"
                                            }

    };

    my $pdf = PDF::ReportWriter->new($reporte);
    my @campos;
    my %hash_campo;    

    foreach my $campo (keys %$headers) {
            %hash_campo =  {
                      name               => $campo,                               # 'Date' will appear in field headers
                      percent            => 35,                                   # The percentage of X-space the cell will occupy
                      align              => "centre",                             # Content will be centred
                      colour             => "blue",                               # Text will be blue
                      font_size          => 12,                                   # Override the default_font_size with '12' for this cell
                      header_colour      => "white"                               # Field headers will be rendered in white
             };
            
            push(@campos, \%hash_campo);
   }
   my $page = 1;
   my $data = {

                background              => {                                  # Set up a default background for all cells ...
                                                border      => "grey"          # ... a grey border
                                            },
                fields                  => @campos,
                page                    => $page,
                data_array              => $datos,
                headings                => {                                  # This is where we set up field header properties ( not a perfect idea, I know )
                                                background  => {
                                                                  shape     => "box",
                                                                  colour    => "darkgrey"
                                                              }
                                            }

    };

    $pdf->render_data( $data );
    C4::AR::PdfGenerator::imprimirFinal($pdf );
#     $pdf->save;


}

sub exportarReporte {
      my ( $params ) = @_;
  
      my $datos= $params->{'datos'};
      my $cantidad_datos = $params->{'cantidad_datos'};
      my $headers= $params->{'headers'};
      my $formato_exportacion= $params->{'formato_exportacion'};

      if ($formato_exportacion eq "PDF"){
#           LLAMA A LA FUNCION QUE GENERA EL PDF
            reportToPDF($datos,  $cantidad_datos, $headers);
      } elsif  ($formato_exportacion eq "XLS")  {
           
        
      } else {
#          LLAMA A LA FUNCION QUE GENERA EL GRAFICO

      }
      

}


END { }    # module clean-up code here (global destructor)

1;
__END__
