package C4::AR::Estadisticas;

#
#Este modulo sera el encargado del manejo de estadisticas sobre los prestamos
#,reservas, devoluciones y todo tipo de consulta sobre el uso de la biblioteca
#
#

use strict;
require Exporter;
use C4::Date;
use C4::AR::Busquedas;


use vars qw(@EXPORT @ISA);

@ISA=qw(Exporter);

@EXPORT=qw(
	usuarios
	historicoPrestamos
	cantidadRetrasados
	renovacionesDiarias
	prestamos
	reservas
	reservasEdicion
	cantUsuarios
	registroActividadesDiarias
	registroEntreFechas
	armarPaginas
	armarPaginasPorRenglones
	cantidadRenglones
	prestamosAnual
	cantRegDiarias
	cantRegFechas
	cantidadAnaliticas
	disponibilidad
	itemtypesReport
	levelsReport
	availYear
	getuser
	estadisticasGenerales
	cantidadUsuariosPrestamos
	cantidadUsuariosReservas
	cantidadUsuariosRenovados
	historicoDeBusqueda
	historicoCirculacion
	insertarNotaHistCirc
	userCategReport
	historicoSanciones
	historialReservas
	signaturamax
	signaturamin
	listaDeEjemplares
    listadoDeInventorio
    getMaxBarcode
    getMinBarcode
    getMinBarcodeLike
    getMaxBarcodeLike
    barcodesPorTipo
    actualizarNotaHistoricoCirculacion
);
sub actualizarNotaHistoricoCirculacion{

    my ($params) = @_;
    my $id_historico = $params->{'id_historico'};
    my $historico = C4::Modelo::RepHistorialCirculacion->new(id => $id_historico);
    eval{
        $historico->load();
        $historico->setNota($params->{'nota'});
        $historico->save();
    };
    if ($@){
        return (0);
    }
    return ($historico);
}

sub barcodesPorTipo{
    my ($branch) = @_;
    my $clase='par';
    my @results;
    my $row;

    $row->{'tipo'}='TODOS';
    $row->{'minimo'}= &getMinBarcode($branch);
    $row->{'maximo'}= &getMaxBarcode($branch);

   if (($row->{'minimo'} ne '') or ($row->{'maximo'} ne '')){
      push @results,$row 
   }

    my $cat_ref_tipo_nivel3 = C4::Modelo::CatRefTipoNivel3::Manager->get_cat_ref_tipo_nivel3(
                                                                                          select => ['id_tipo_doc'],
                                                                                       );

   foreach my $it (@$cat_ref_tipo_nivel3) {
      my $row;
      my $id_tipo_doc = $it->{'id_tipo_doc'};

      $row->{'tipo'}=  $id_tipo_doc;

      my $inicio=$branch."-".$it->{'id_tipo_doc'}."-%";

      $row->{'minimo'} = C4::AR::Estadisticas::getMinBarcodeLike($branch,$inicio);

      $row->{'maximo'} = C4::AR::Estadisticas::getMaxBarcodeLike($branch,$inicio);

      if (($row->{'minimo'} ne '') or ($row->{'maximo'} ne ''))  {
         push @results,$row 
      }
   }
   return @results;
}


sub getMinYMaxBarcode{
    my ($params_hash_ref) = @_;


    my @filtros;
    my @cat_nivel3_result;
    my @info_array;;

    my $cat_nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( 
                                                                                            query => \@filtros,
                                                                          );

    my $cant = scalar(@$cat_nivel3_array_ref);

    for(my $i=0; $i < $cant; $i++){

        my %hash_info;
        my $barcode_temp = $cat_nivel3_array_ref->[$i]->getBarcode();

        if($barcode_temp ne ""){

            $hash_info{'value'}   = $barcode_temp;
            push(@info_array, \%hash_info);
        }
    }

    @cat_nivel3_result = sort { $a->{'value'} cmp $b->{'value'} } @info_array;

#     @cat_nivel3_result = C4::AR::Utilidades::sortHASHString();

#     for(my $i=0; $i < scalar(@cat_nivel3_result); $i++){
#       C4::AR::Debug::debug("hash de signatura_topografica => ".@cat_nivel3_result[$i]->{'value'}); 
#     }

    my $barcode_min = @cat_nivel3_result[1]->{'value'};
    my $barcode_max = @cat_nivel3_result[scalar(@cat_nivel3_result) - 1]->{'value'};

#     C4::AR::Debug::debug("min => ".$signatura_min); 
#     C4::AR::Debug::debug("max => ".$signatura_max);

    return ($barcode_min, $barcode_max);
}


sub getMinYMaxSignaturaTopografica{
    my ($params_hash_ref) = @_;


    my @filtros;
    my @cat_nivel3_result;
    my @info_array;;

    my $cat_nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( 
                                                                                            query => \@filtros,
                                                                          );

    my $cant = scalar(@$cat_nivel3_array_ref);

    for(my $i=0; $i < $cant; $i++){

        my %hash_info;
        my $signatura_temp = $cat_nivel3_array_ref->[$i]->getSignatura_topografica();

        if($signatura_temp ne ""){

            $hash_info{'value'}   = $signatura_temp;
            push(@info_array, \%hash_info);
        }
    }

    @cat_nivel3_result = sort { $a->{'value'} cmp $b->{'value'} } @info_array;

#     @cat_nivel3_result = C4::AR::Utilidades::sortHASHString();

#     for(my $i=0; $i < scalar(@cat_nivel3_result); $i++){
#       C4::AR::Debug::debug("hash de signatura_topografica => ".@cat_nivel3_result[$i]->{'value'}); 
#     }

    my $signatura_min = @cat_nivel3_result[1]->{'value'};
    my $signatura_max = @cat_nivel3_result[scalar(@cat_nivel3_result) - 1]->{'value'};

#     C4::AR::Debug::debug("min => ".$signatura_min); 
#     C4::AR::Debug::debug("max => ".$signatura_max);

    return ($signatura_min, $signatura_max);
}


# sub busquedaBetweenSigTop{
# 
#     my ($params) = @_;
# 
#     use Sphinx::Search;
#     
#     my $sphinx  = Sphinx::Search->new();
#     my $query   = '';
#     my $tipo    = 'SPH_MATCH_EXTENDED';
#     my $orden   = $params->{'orden'};
# #     my $min= $params->{'desde_signatura'};
# #     my $max= $params->{'hasta_signatura'};
#     
#     my $min= $params->{'desde_barcode'};
#     my $max= $params->{'hasta_barcode'};
#     
#     $query .= '@string '.'barcode% '.'>= '.$min.'&'.' <= '.$max;
#    
# #     $sphinx->SetLimits($params->{'ini'}, $params->{'cantR'});
#     $sphinx->SetEncoders(\&Encode::encode_utf8, \&Encode::decode_utf8);
# #     $sphinx->SetIDRange($min, $max);
#     
#     # NOTA: sphinx necesita el string decode_utf8
#     
# #     $sphinx->SetFilterRange('string', $min, $max);
#     my $results = $sphinx->Query($query);
# 
#       C4::AR::Debug::debug("QUERY".$query);
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




# TODO ver si se puede utilizar el sphix para no procesar todos los ejemplares

sub listarItemsDeInventorioPorBarcode{
    my ($params_hash_ref) = @_;


    my @filtros;
    my @cat_nivel3_result;
    my @info_reporte;
    my $orden = $params_hash_ref->{'sort'} || 'barcode';

    my $cat_nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( 
                                                                                            query => \@filtros,
#               require_objects     => ['nivel2','nivel1'],
#               select              => ['cat_registro_marc_n2.*','cat_registro_marc_n1.*'],
                                                                              );



    my $cant            = scalar(@$cat_nivel3_array_ref);
    my $cant_total      = 0;
    my $barcode         = C4::AR::Utilidades::trim($params_hash_ref->{'barcode'});
    my $desde_barcode   = C4::AR::Utilidades::trim($params_hash_ref->{'desde_barcode'});
    my $hasta_barcode   = C4::AR::Utilidades::trim($params_hash_ref->{'hasta_barcode'});

    for(my $i=0; $i < $cant; $i++){
#         C4::AR::Debug::debug("barcode => ".$cat_nivel3_array_ref->[$i]->getBarcode());

        my %hash_info;

        $hash_info{'nro_inventario'}          = $cat_nivel3_array_ref->[$i]->getBarcode();
        $hash_info{'signatura_topografica'}   = $cat_nivel3_array_ref->[$i]->getSignatura_topografica();
        $hash_info{'autor'}                   = $cat_nivel3_array_ref->[$i]->nivel2->nivel1->getAutor();
        $hash_info{'titulo'}                  = $cat_nivel3_array_ref->[$i]->nivel2->nivel1->getTitulo();
        $hash_info{'edicion'}                 = $cat_nivel3_array_ref->[$i]->nivel2->getEdicion();
# TODO falta implementar
#         $hash_info{'edicion'}                 = $cat_nivel3_array_ref->[$i]->nivel2->getVolumen();
        $hash_info{'editor'}                  = $cat_nivel3_array_ref->[$i]->nivel2->getEditor();
        $hash_info{'anio_publicacion'}        = $cat_nivel3_array_ref->[$i]->nivel2->getAnio_publicacion();
        $hash_info{'ui'}                      = $cat_nivel3_array_ref->[$i]->getId_ui_poseedora();


        if ($barcode ne "" && $cat_nivel3_array_ref->[$i]->getBarcode() =~ m/^$barcode/i) {

# TODO esto esta feooooooo despues lo acomodo
            if($params_hash_ref->{'id_ui'} ne "" && $cat_nivel3_array_ref->[$i]->getId_ui_poseedora() eq $params_hash_ref->{'id_ui'}){

                push(@info_reporte, \%hash_info);
                push(@cat_nivel3_result, $cat_nivel3_array_ref->[$i]);
                $cant_total++;
            }

            if($params_hash_ref->{'id_ui'} eq ""){
                push(@info_reporte, \%hash_info);
                push(@cat_nivel3_result, $cat_nivel3_array_ref->[$i]);
                $cant_total++;
            }
        } 
    

        if (($desde_barcode ne "")&&($cat_nivel3_array_ref->[$i]->getBarcode() ge $desde_barcode) && 
            ($hasta_barcode ne "")&&($cat_nivel3_array_ref->[$i]->getBarcode() le $hasta_barcode)) {

            if($params_hash_ref->{'id_ui'} ne "" && $cat_nivel3_array_ref->[$i]->getId_ui_poseedora() eq $params_hash_ref->{'id_ui'}){
                push(@info_reporte, \%hash_info);
                push(@cat_nivel3_result, $cat_nivel3_array_ref->[$i]);
                $cant_total++;
            }

            if($params_hash_ref->{'id_ui'} eq ""){

                push(@info_reporte, \%hash_info);
                push(@cat_nivel3_result, $cat_nivel3_array_ref->[$i]);
                $cant_total++;
            }
        }
    }#END for(my $i=0; $i < $cant; $i++)

    @cat_nivel3_result = sort { $a->{$orden} cmp $b->{$orden} } @info_reporte;

    $params_hash_ref->{'cant_total'}    = $cant_total;
    @cat_nivel3_result                  = C4::AR::Utilidades::paginarArrayResult($params_hash_ref, @cat_nivel3_result);


    return ($cant_total, \@cat_nivel3_result, \@info_reporte);
}





# TODO DEPRECATED
# sub getMaxBarcode {
#    my ($branch) = @_;
#    use C4::Modelo::CatRegistroMarcN3::Manager;
#    my $max = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
#                                                          select => ['MAX(t1.barcode) as barcode'],
#                                                          );
#    return ($max->[0]->barcode);
# }

# TODO DEPRECATED
# sub getMinBarcode {
#    my ($branch) = @_;
#    use C4::Modelo::CatRegistroMarcN3::Manager;
#    my $min = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
#                                                          select => ['MIN(t1.barcode) as barcode'],
#                                                          );
#    return ($min->[0]->barcode);
# }

sub getMinBarcodeLike {
   my ($branch,$part_barcode) = @_;
   use C4::Modelo::CatRegistroMarcN3::Manager;
   my $min = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
                                                         query => [ barcode => { like => $part_barcode } ],
                                                         select => ['MIN(t1.barcode) as barcode'],
                                                         );
   return ($min->[0]->barcode);
}

sub getMaxBarcodeLike {
   my ($branch,$part_barcode) = @_;
   use C4::Modelo::CatRegistroMarcN3::Manager;
   my $max = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
                                                         query => [ barcode => { like => $part_barcode } ],
                                                         select => ['MAX(t1.barcode) as barcode'],
                                                         );
   return ($max->[0]->barcode);
}

sub listadoDeInventorio{

    my ($params_obj)=@_;

    use C4::Modelo::CatRegistroMarcN3::Manager;
    my @filtros;

    push (@filtros,(barcode => {eq => $params_obj->{'minBarcode'},
                                gt => $params_obj->{'minBarcode'},
                                }));
    push (@filtros,(barcode => {eq => $params_obj->{'maxBarcode'},
                                lt => $params_obj->{'maxBarcode'},
                                }));
#     push (@filtros,(id_ui_origen => {eq => $params_obj->{'id_ui_origen'}}));
    my $inventorio = 0;
    my $inventorio_count = 0;

    eval{
        $inventorio_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count(
                                                                        query => \@filtros,
                                                                        require_objects => ['nivel2','nivel1','nivel1.cat_autor'],
                                                                        );

        $inventorio = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
                                                                        query => \@filtros,
                                                                        require_objects => ['nivel2','nivel1','nivel1.cat_autor'],
                                                                        sort_by => ['nivel1.titulo'],
                                                                        limit => $params_obj->{'cantR'},
                                                                        offset => $params_obj->{'ini'},
                                                                        );
    };

    return ($inventorio_count,$inventorio);
}

sub historicoDeBusqueda{
   my ($params_obj)=@_;

   my $dateformat = C4::Date::get_date_format();
   my @filtros;

   if ($params_obj->{'fechaIni'} ne ""){
      push(@filtros, ( 'busqueda.fecha' => {       eq => format_date_in_iso($params_obj->{'fechaIni'},$dateformat),
                                                   gt => format_date_in_iso($params_obj->{'fechaIni'},$dateformat),
                                 }
                      ) );
   }

   if ($params_obj->{'fechaFin'} ne ""){
      push(@filtros, ( 'busqueda.fecha' => {       eq => format_date_in_iso($params_obj->{'fechaFin'},$dateformat), 
                                                   lt => format_date_in_iso($params_obj->{'fechaFin'},$dateformat), 
                                }
                     ) );
   }

   if($params_obj->{'catUsuarios'} ne "SIN SELECCIONAR"){
   
#   FIXME: ver si anda! cambiado el 16/05 porque no esta mas el cod_categoria en usr_socio, esta el id_categoria
#      push(@filtros, ( 'busqueda.socio.cod_categoria' => { eq=> $params_obj->{'catUsuarios'}, }) );

        push(@filtros, ( 'busqueda.socio.categoria.getCategory_code' => { eq => $params_obj->{'catUsuarios'}, }) );
   }

   use C4::Modelo::RepHistorialBusqueda::Manager;

   my $busquedas_count = C4::Modelo::RepHistorialBusqueda::Manager->get_rep_historial_busqueda_count(
                                                                                          query => \@filtros,
#                                                                                           with_objects => ['busqueda','busqueda.socio'],
                                                                                     );


   my $busquedas = C4::Modelo::RepHistorialBusqueda::Manager->get_rep_historial_busqueda(
                                                                                query => \@filtros,
                                                                                with_objects => ['busqueda','busqueda.socio'],
                                                                                limit   => $params_obj->{'cantR'},
                                                                                offset  => $params_obj->{'ini'},
                                                                                sorty_by => $params_obj->{'orden'},
                                                                    );

   return($busquedas_count,$busquedas);

}

sub historicoPrestamos{
   #Se realiza un Historial de Prestamos, con los siguientes datos:
   #Apellido y Nombre, DNI,Categoria del Usuario, Tipo de Prestamo, Codigo de Barras, 
   #Fecha de Prestamo, Fecha de Devolucion, Tipo de Item
   
   my ($params_obj)=@_;

   my $dateformat = C4::Date::get_date_format();

   my @filtros;

  
   my $prestamos_count = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo_count(
                                                                        query => \@filtros,
                                                                        require_objects => ['nivel3','socio','ui','ui_prestamo'],
                                                                    ); 

   my $prestamos = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                        query => \@filtros,
                                                                        require_objects => ['nivel3','socio','ui','ui_prestamo','tipo'],
                                                                        limit   => $params_obj->{'cantR'},
                                                                        offset  => $params_obj->{'ini'},
                                                                     ); 

   return($prestamos_count,$prestamos);
}


sub prestamosAnual{

    my ($params)=@_;
    my @filtros;

    use C4::Modelo::CircPrestamo::Manager;

    push ( @filtros, ('fecha_prestamo' => { like => $params->{'year'}.'%' }));

    my $prestamos_anual_count = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo_count(
                                                                                query => \@filtros,
                                                                                group_by => ['month(fecha_prestamo)'],
                                                                                require_objects => ['nivel3','socio','tipo','ui','ui_prestamo'],
                                                                               );

    my $prestamos_anual = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                                query => \@filtros,
                                                                                group_by => ['month(fecha_prestamo)'],
                                                                                select => ['*','COUNT(*) AS agregacion_temp'],
                                                                                require_objects => ['nivel3','socio','tipo','ui','ui_prestamo','tipo'],
                                                                               );

    push ( @filtros, ('fecha_devolucion' => {ne => undef} ));

    my $prestamos_anual_devueltos = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                                query => \@filtros,
                                                                                group_by => ['month(fecha_prestamo)'],
                                                                                select => ['*','COUNT(*) AS agregacion_temp'],
                                                                                require_objects => ['nivel3','socio','tipo','ui','ui_prestamo','tipo'],
                                                                               );

    return ($prestamos_anual_count,$prestamos_anual);

}

# sub prestamosAnual{
#     my ($branch,$year)=@_;
#     my $dbh = C4::Context->dbh;
# 	my @results;
# 	my $query ="SELECT month( date_due ) AS mes, count( * ) AS cantidad,SUM( renewals ) AS 
# 			   renovaciones, issuecode
# 		    FROM  circ_prestamo 
# 		    WHERE year( date_due ) = ? 
# 		    GROUP BY month( date_due ), issuecode";
# 
# 	my $sth=$dbh->prepare($query);
#         $sth->execute($year);
# 	while (my $data=$sth->fetchrow_hashref){
# 		$data->{'mes'}=&mesString($data->{'mes'});
# 		push(@results,$data);
#         	};
# 	$query ="SELECT count( * ) AS devoluciones
#                  FROM  circ_prestamo 
#                  WHERE year( date_due ) = ? and returndate is not null
#                  GROUP BY month( date_due ), issuecode";
# 	my $sth=$dbh->prepare($query);
#         $sth->execute($year);
# 	my $i=0;
# 	while (my $data=$sth->fetchrow_hashref){
# 		@results[$i]->{'devoluciones'}=$data->{'devoluciones'};
# 		$i++;
# 		};
# 
# 	return(@results);
# }

#
##Ejemplares perdidos del branch que le paso por parametro
sub disponibilidad{
   my ($params_obj)=@_;
   use C4::Modelo::CatHistoricoDisponibilidad::Manager;
   my $dateformat = C4::Date::get_date_format();
   my $dates='';
   my @filtros;

   if (($params_obj->{'fechaInicio'} ne '') && ($params_obj->{'fechaInicio'} ne '')){
      push(@filtros, ( fecha => {      eq=> format_date_in_iso($params_obj->{'fechaInicio'},$dateformat), 
                                       gt => format_date_in_iso($params_obj->{'fechaInicio'},$dateformat), 
                                 }
                      ) );
      
      push(@filtros, ( fecha => {      eq=> format_date_in_iso($params_obj->{'fechaFin'},$dateformat), 
                                       lt => format_date_in_iso($params_obj->{'fechaFin'},$dateformat), 
                                }
                     ) );
   }
    
    if (substr($params_obj->{'ui'},0,3) ne "SIN"){
        push (@filtros,( id_ui => { eq => $params_obj->{'ui'}.'%'}));
    }

   push(@filtros, ( tipo_prestamo => { eq => $params_obj->{'disponibilidad'} } ) );

   my $det_disponibilidad = C4::Modelo::CatHistoricoDisponibilidad::Manager->get_cat_historico_disponibilidad(
                                                                                                          query => \@filtros,
                                                                                                          distinct => 1,
                                                                                                          require_objects => ['nivel3'],
                                                                                                          limit => $params_obj->{'cantR'},
                                                                                                          offset => $params_obj->{'ini'},
                                                                                                          sorty_by => $params_obj->{'orden'},
                                                                                                         );




   return (scalar(@$det_disponibilidad),$det_disponibilidad);
}


#Cantidad de renglones seteado en los parametros del sistema para ver por cada pagina
sub cantidadRenglones{
        my $dbh = C4::Context->dbh;
        my $query="select value
		   from pref_preferencia_sistema
                   where variable='renglones'";
        my $sth=$dbh->prepare($query);
	$sth->execute();
	return($sth->fetchrow_array);
}

#
#Esta funcion recibe un numero que equivale a la cantidad de tuplas que devuelve cualquier consulta
# y en base a eso arma el array con la cantidad de paginas que tiene que quedar como respuesta
# Paginador
sub armarPaginas{
	my ($cant,$actual)=@_;
	my $renglones = cantidadRenglones();
	my $paginas = 0;
	if ($renglones != 0){
		$paginas= $cant % $renglones;}
	if  ($paginas == 0){
        	$paginas= $cant /$renglones;}
	else {$paginas= (($cant - $paginas)/$renglones) +1};
	my @numeros=();
	for (my $i=1; ($paginas >1 and $i <= $paginas) ; $i++ ) {
		 push @numeros, { number => $i, actual => ($i!=$actual)}
	};
	return(@numeros);
}

sub armarPaginasPorRenglones {
	my ($cant,$actual,$renglones)=@_;
	my $paginas = 0;
	if ($renglones != 0){
		$paginas= $cant % $renglones;}
	if  ($paginas == 0){
        	$paginas= $cant /$renglones;}
	else {$paginas= (($cant - $paginas)/$renglones) +1};
	my @numeros=();
	for (my $i=1; ($paginas >1 and $i <= $paginas) ; $i++ ) {
		 push @numeros, { number => $i, actual => ($i!=$actual)}
	};
	return(@numeros);
}

# sub insertarNota{
# 	my ($id,$nota)=@_;
#         my $dbh = C4::Context->dbh;
#         my $query="update  rep_registro_modificacion set nota=?
# 		   where idModificacion=?";
#         my $sth=$dbh->prepare($query);
#         $sth->execute($nota,$id);
# }

sub cantRegFechas{
	my ($chkfecha,$fechaInicio,$fechaFin,$tipo,$operacion,$chkuser,$chknum,$user,$numDesde,$numHasta)=@_;
        my $dbh = C4::Context->dbh;
	my @bind;
        my $query ="SELECT  count(*)
        	    FROM rep_registro_modificacion INNER JOIN borrowers ON
		   (rep_registro_modificacion.responsable=borrowers.cardnumber) ";
	my $where = "";
	
	if ($chkfecha ne "false"){
		$where = "WHERE";
		$query.= $where." (fecha>=?) AND (fecha<=?)";
		push(@bind,$fechaInicio);
		push(@bind,$fechaFin);
	}

	if ($operacion ne ''){
		if ($where eq ''){
			$where = "WHERE";
			$query.= $where." operacion=?";
		}
		else {$query.= " AND operacion=?";}
		push(@bind,$operacion);
	}

	if ($tipo ne ''){
		if ($where eq ''){
			$where = "WHERE";
			$query.= $where." tipo=?";
		}
		else {$query.= " AND tipo=?";}
		push(@bind,$tipo);
	}

	if ($chkuser ne "false"){
		if ($where eq ''){
			$where = "WHERE";
			$query.= $where." responsable=?";
		}
		else {$query.= " AND responsable=?";}
		push(@bind,$user);
	}
	
	if ($chknum ne "false"){
		if ($where eq ''){
			$where = "WHERE";
			$query.= $where." numero >= ? AND numero <= ?";
		}
		else {$query.= " AND numero >= ? AND numero <= ?";}
		push(@bind,$numDesde);
		push(@bind,$numHasta);
	}

	my $sth=$dbh->prepare($query);
        $sth->execute(@bind);
        return($sth->fetchrow_array);


}


sub registroEntreFechas{
    my ($params_obj) = @_;
    
    my @filtros;
    
    use C4::Modelo::RepRegistroModificacion::Manager;
    
    if ($params_obj->{'chkfecha'} ne "false"){
        push(@filtros, ( fecha => {     eq => $params_obj->{'fechaInicio'}, 
                                        gt => $params_obj->{'fechaInicio'}, 
                                    }
                        ) );
    
        push(@filtros, ( fecha => {     eq => $params_obj->{'fechaFin'},
                                        lt => $params_obj->{'fechaFin'}  
                                    }
                        ) );
    }
    
    C4::AR::Debug::debug($params_obj->{'tipo'});
    if ($params_obj->{'operacion'} ne ''){
        push(@filtros, ( operacion => { eq => $params_obj->{'operacion'} }) );
    }
    
    if ($params_obj->{'user'} ne "-1"){
        push(@filtros, ( responsable => { eq => $params_obj->{'user'} }) );
    }

    if ($params_obj->{'nivel'} ne ''){
        push(@filtros, ( tipo => { eq => $params_obj->{'nivel'} }) );
    }
    
    my $registros_count = C4::Modelo::RepRegistroModificacion::Manager->get_rep_registro_modificacion_count(
                                                                        query               => \@filtros,
                                                                        require_objects     => ['socio_responsable'],
                                                                );

    my $rep_registro_modificacion_array_ref = C4::Modelo::RepRegistroModificacion::Manager->get_rep_registro_modificacion(
                                    query               => \@filtros,
                                    sorty_by            => $params_obj->{'orden'},
                                    limit               => $params_obj->{'cantR'},
                                    offset              => $params_obj->{'fin'},
                                    require_objects     => ['socio_responsable','socio_responsable.persona'],
                                    select              => ['rep_registro_modificacion.*','socio_responsable.*','usr_persona.*']
                );


    return ($registros_count,$rep_registro_modificacion_array_ref);
}

=item
sub cantRegDiarias{
   my ($today)=@_;
        my $dbh = C4::Context->dbh;
        my $query ="SELECT  count(*)
             FROM modificaciones INNER JOIN borrowers ON
         (modificaciones.responsable=borrowers.cardnumber) 
                    WHERE fecha='$today'";
        my $sth=$dbh->prepare($query);
        $sth->execute();
        return($sth->fetchrow_array);
}

sub registroActividadesDiarias{
   my ($orden,$fecha,$ini,$cantR)=@_;
        my $dbh = C4::Context->dbh;
        my $query="SELECT operacion,fecha,responsable,numero,tipo,surname,firstname
         FROM modificaciones INNER JOIN borrowers ON
         (modificaciones.responsable=borrowers.cardnumber) 
                   WHERE (fecha=?)
         ORDER BY (?)
         limit $ini,$cantR";
        my $sth=$dbh->prepare($query);
        $sth->execute($fecha,$orden);
   my @results;
        while (my $data=$sth->fetchrow_hashref){
      $data->{'fecha'}=format_date($data->{'fecha'});
      $data->{'nomCompleto'}=$data->{'surname'}.", ".$data->{'firstname'};
                push(@results,$data);
        }
        return (@results);
}
=cut


sub cantidadRetrasados{
        my ($branch)=@_; 
	my $dbh = C4::Context->dbh;
	my @results;
	my $query ="Select * 
	              From  circ_prestamo inner join borrowers on ( circ_prestamo.borrowernumber=borrowers.borrowernumber)
        	      Where (returndate is NULL and  circ_prestamo.branchcode = ? ) ";
	my $sth=$dbh->prepare($query);
	$sth->execute($branch);
	while (my $data=$sth->fetchrow_hashref){
                push(@results,$data);
        }
        return (@results);

}

#
#Renovaciones realizadas por socios al dia de hoy
#
sub renovacionesDiarias{
        my ($branch)=@_; 
	my $dbh = C4::Context->dbh;
	my @results;
	my $query ="select *
  		    from  circ_prestamo inner join borrowers on ( circ_prestamo.borrowernumber=borrowers.borrowernumber)
		    where (returnDate is NULL and  circ_prestamo.branchcode=? and renewals >= 1 )";
	my $sth=$dbh->prepare($query);
	$sth->execute($branch);
	while (my $data=$sth->fetchrow_hashref){
                push(@results,$data);
        }
        return (@results);
}

#
#Prestamos realizados en una fecha dada
#
sub prestamosEnUnaFecha{
	my ($branch,$fecha)=@_;
        my $dbh = C4::Context->dbh;
        my @results;
	my $query ="select *
		    from  circ_prestamo inner join borrowers on ( circ_prestamo.borrowernumber=borrowers.borrowernumber)
		    where ( circ_prestamo.date_due=? and  circ_prestamo.branchcode = ?)";
        my $sth=$dbh->prepare($query);
        $sth->execute($fecha,$branch);
	while (my $data=$sth->fetchrow_hashref){
                push(@results,$data);
        }
        return (@results);
}

#
#Devoluciones que se tienen que hacer en una fecha dada
#

sub devolucionesParaFecha{
	my ($branch,$fecha)=@_;
        my $dbh = C4::Context->dbh;
	my @results;
        my $query ="select *
                    from  circ_prestamo inner join borrowers on ( circ_prestamo.borrowernumber=borrowers.borrowernumber)
		    where ( circ_prestamo.returndate=? and  circ_prestamo.branchcode=?) ";
        my $sth=$dbh->prepare($query);
        $sth->execute($fecha,$branch);
	while (my $data=$sth->fetchrow_hashref){
                push(@results,$data);
        }
        return (@results);
}

#Historial de prestamos realizados por un usuario 
                                                                                                                             
sub historialUsuario{
        my ($id,$branch)=@_;
        my $dbh = C4::Context->dbh;
        my $query ="select  *
                    from  circ_prestamo inner join borrowers on ( circ_prestamo.borrowernumber=borrowers.borrowernumber)
		    where borrowers.borrowernumber=? and  circ_prestamo.branchcode=?";
        my $sth=$dbh->prepare($query);
        $sth->execute($id,$branch);
	return($sth->fechtrow_hashref);
}


#Usuarios de un branch dado 
#Damian - 31/05/2007 - Se agrego para difereciar usuarios que usan y no usan la biblioteca
sub usuarios{
        my ($branch,$orden,$ini,$fin,$anio,$usos,$categ,@chck)=@_;
	my $dbh = C4::Context->dbh;
	my $dateformat = C4::Date::get_date_format();
  	my @results;
	my @bind;
	my @bind2;
	my $queryCant ="SELECT count( * ) AS cantidad
                    FROM borrowers b
                    WHERE branchcode=? ";

        my $query ="SELECT  b.phone,b.emailaddress,b.dateenrolled,c.description as categoria ,
		    b.firstname,b.surname,b.streetaddress,b.cardnumber,b.city,b.borrowernumber
                    FROM borrowers b inner join usr_ref_categoria_socio c on (b.categorycode = c.categorycode)
 		    WHERE b.branchcode=? ";
	my $where="";
	push(@bind,$branch);

	my $query2 = "SELECT * FROM  circ_prestamo i WHERE b.borrowernumber = i.borrowernumber ";
	my $exists = "";
	for (my $i=0; $i < scalar(@chck); $i++){
		if($chck[$i] eq "CAT"){
			$where.=" AND b.categorycode= ?";
			if($exists eq ""){$exists = " AND EXISTS (";}
			push(@bind,$categ);
		}
		elsif($chck[$i] eq "AN"){
			$query2 = $query2 ." AND year( date_due )= ?";
			$exists = " AND EXISTS (";
			push(@bind2,$anio);
		}
		elsif($chck[$i] eq "USO"){
			if($usos eq "NI"){$exists = " AND NOT EXISTS (";}
			else{$exists = " AND EXISTS (";}
		}
	}
	my $finCons= " ORDER BY ($orden) LIMIT $ini,$fin";
	if ( $exists eq ""){
		$query.=$finCons;
	}
	else{
		$queryCant.=$where.$exists.$query2.")";
		$query.=$where.$exists.$query2.") GROUP BY b.borrowernumber ".$finCons;
	}

        my $sth=$dbh->prepare($queryCant);
        $sth->execute(@bind,@bind2);
	my $cantidad=$sth->fetchrow;
	
	$sth=$dbh->prepare($query);
        $sth->execute(@bind,@bind2);
	while (my $data=$sth->fetchrow_hashref){
		if ($data->{'phone'} eq "" ){$data->{'phone'}='-' };
		if ($data->{'emailaddress'} eq "" ){
					$data->{'emailaddress'}='-';
					$data->{'ok'}=1;
				};
		$data->{'dateenrolled'}=format_date($data->{'dateenrolled'},$dateformat);
		$data->{'city'}=C4::AR::Busquedas::getNombreLocalidad($data->{'city'});
                push(@results,$data);
        }
        return ($cantidad,@results);
}


# Verifica que una fecha este entre otras 2 
sub estaEnteFechas {
   my ($begindate,$enddate,$vencimiento)=@_;

  if (($begindate eq '')or($enddate eq '')or($vencimiento eq '')){ return 1;} # Si alguna de las fechas viene vacia se devuelve 1
  else {
		# Se hacen las comapraciones
		my $flag1=Date::Manip::Date_Cmp($begindate,$vencimiento);
		my $flag2=Date::Manip::Date_Cmp($vencimiento,$enddate);	
		if (($flag1 le 0) and ($flag2 le 0)) {return 1;}
		#
	}
  return 0;
}

sub prestamos{

         my ($params_obj)=@_;
         my @results;
         my $dateformat = C4::Date::get_date_format();
         my @filtros;

         if ($params_obj->{'fechaIni'} ne ""){
            push(@filtros, ( 'fecha_prestamo' => {       eq=> format_date_in_iso($params_obj->{'fechaIni'},$dateformat), 
                                                         gt => format_date_in_iso($params_obj->{'fechaIni'},$dateformat), 
                                       }
                           ) );
         }

         if ($params_obj->{'fechaIni'} ne ""){
            push(@filtros, ( 'fecha_prestamo' => {       eq=> format_date_in_iso($params_obj->{'fechaFin'},$dateformat), 
                                                         lt => format_date_in_iso($params_obj->{'fechaFin'},$dateformat), 
                                    }
                           ) );
         }

         if($params_obj->{'id_ui'} ne "SIN SELECCIONAR"){
            push(@filtros, ( id_ui_origen => { eq=> $params_obj->{'id_ui'}, }) );
         }


         my $prestamos = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                             query => \@filtros,
                                                                             require_objects => ['socio','nivel3'],
                                                                             );
         my @datearr = localtime(time);
         my $hoy =(1900+$datearr[5])."-".($datearr[4]+1)."-".$datearr[3];
         my @results;
         foreach my $prestamo (@$prestamos){
            my $dateformat = C4::Date::get_date_format();
            $prestamo->{'vencimiento'}=$prestamo->getFecha_vencimiento_formateada();
            #Se filtra por Fechas de Vencimiento 
            if ( estaEnteFechas(($params_obj->{'fechaIni'},($params_obj->{'fechaFin'},$prestamo->getFecha_vencimiento_formateada))) ) {
              #Se filtra por Fechas de Vencimiento 
               if ($prestamo->socio->persona->getTelefono eq "" ){
                  $prestamo->socio->persona->setTelefono('-');
               }

               if (!($prestamo->socio->persona->getEmail)){
                        $prestamo->socio->persona->setEmail('-');
                        $prestamo->{'ok'}=1;
               }

               if (!($prestamo->getFecha_devolucion)){
                  $prestamo->setFecha_devolucion('-');
               }
               else{
                  $prestamo->setFecha_devolucion(C4::Date::format_date($prestamo->getFecha_devolucion,$dateformat));
               }

               $prestamo->setFecha_prestamo(C4::Date::format_date($prestamo->getFecha_prestamo,$dateformat));;

            if ( $params_obj->{'estado'} eq "TO" ){
                  push (@results,$prestamo);
            }
            elsif ( $params_obj->{'estado'} eq "VE" ){ 
                  if ($prestamo->estaVencido()){
                        push (@results,$prestamo);
                  }
            } else{
                     if (!$prestamo->estaVencido()){
                        push (@results,$prestamo);
                  }
            }
         }
      }#foreach

#       # Da el ORDEN al arreglo
#        if (($orden ne "vencimiento") and ($orden ne "date_due")) {
#        #ordeno alfabeticamente
#           my @sorted = sort { $a->{$orden} cmp $b->{$orden} } @results;
#           @results=@sorted;
#        }
#        else
#        {#ordeno Fechas
#           my @sorted = sort { Date::Manip::Date_Cmp($a->{$orden},$b->{$orden}) } @results;
#           @results=@sorted;
#        }
      #
         my $cantReg=scalar(@results);
      #Se chequean si se quieren devolver todos
         if(($cantReg > $params_obj->{'fin'})&&($params_obj->{'fin'} ne "todos")){
            my $cantFila=($params_obj->{'cantR'}-1+($params_obj->{'ini'}) );
            my @results2;
            if($cantReg < $cantFila ){
               @results2=@results[($params_obj->{'ini'})..($params_obj->{'cantR'}) ];
            }
            else{
               @results2=@results[$params_obj->{'ini'}..$params_obj->{'cantR'}-1+$params_obj->{'ini'}];
            }

            return($cantReg,\@results2);
         }
            else{
              return ($cantReg,\@results);
         }
}

sub reservas{

    my ($id_ui,$orden,$ini,$cantR,$tipo)=@_;
    my $dateformat = C4::Date::get_date_format();
    my @filtros;
    my @results;
    my $reservaTemp = C4::Modelo::CircReserva->new();
    my $ordenAux    = $reservaTemp->sortByString($orden);
    
    push (@filtros, ( id_ui => { eq => $id_ui}) );
    
    if($tipo eq "GR"){
        push (@filtros, ( estado => { eq => 'G'}) );

    
    }
    elsif($tipo eq "EJ"){
        push (@filtros, ( estado => { eq => 'E'}) );
    }
    else{
        push (@filtros,( or   => [   
                                                estado => { eq => 'E'},
                                                estado => { eq => 'G'}  
                                            ]));
    }
    
    my $reservas_count = C4::Modelo::CircReserva::Manager->get_circ_reserva_count(   query => \@filtros,
                                                                                );
    
    my $reservas = C4::Modelo::CircReserva::Manager->get_circ_reserva(      query => \@filtros,
                                                                            sort_by => $ordenAux,
                                                                            limit => $cantR,
                                                                            offset => $ini,
                                                                            with_objects => ['socio','nivel3','nivel3.nivel2'],
    );
    
    return ($reservas_count,$reservas);
}

sub reservasEdicion{

    my ($id_ui,$ini,$cantR,$tipo,$id2)=@_;
    my $dateformat = C4::Date::get_date_format();
    my @filtros;
    my @results;

    my $ordenAux    = 'timestamp ASC';

    $ordenAux    = 'id_reserva DESC';
    
    push (@filtros, ( id_ui => { eq => $id_ui}) );
    push (@filtros, ( id2 => { eq => $id2}) );
    
    if($tipo eq "GR"){
        push (@filtros, ( estado => { eq => 'G'}) );
        push (@filtros, ( id3 => { eq => undef}) );
    
    }
    else{
        push (@filtros, ( estado => { eq => 'E'}) );
        push (@filtros, ( id3 => { ne => undef}) );
    }
    
    my $reservas_count = C4::Modelo::CircReserva::Manager->get_circ_reserva_count(   query => \@filtros,
                                                                                );
    
    my $reservas = C4::Modelo::CircReserva::Manager->get_circ_reserva(      query => \@filtros,
                                                                            sort_by => $ordenAux,
                                                                            with_objects => ['socio','nivel3','nivel3.nivel2'],
    );
    
    return ($reservas_count,$reservas);
}

sub cantidadAnaliticas{
        my $dbh = C4::Context->dbh;
        my @results;
        my $query ="SELECT count( * ) AS cantidad
                    FROM cat_analitica";
        my $sth=$dbh->prepare($query);
        $sth->execute();
        while (my $data=$sth->fetchrow_hashref){
                push(@results,$data);
        }
        return (@results);
}


sub tiposDeItem_reporte{
      my ($id_ui)=@_;
      my @filtros;
      push (@filtros, ( id_ui_poseedora => { eq => $id_ui}) );

      my $tipos_item = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
                                                                        query => \@filtros,  
                                                                        select => ['nivel2.*','COUNT(tipo_documento) AS agregacion_temp'],
                                                                        group_by => ['tipo_documento'],
                                                                        with_objects => ['nivel2'],

                                                                     );
      my $tipos_item_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count(
                                                                        query => \@filtros,  
                                                                        with_objects => ['nivel2'],

                                                                     );

      return ($tipos_item_count,$tipos_item);
}

sub reporteNiveles{
      my ($id_ui)=@_;
        

#       my $query="SELECT ref_nivel_bibliografico.description, COUNT( ref_nivel_bibliografico.description ) AS cant
# 		FROM ref_nivel_bibliografico
# 		LEFT JOIN cat_nivel2 n2 ON bibliolevel.code = n2.nivel_bibliografico
# 		INNER JOIN cat_nivel3 n3 ON n2.id2 = n3.id2
# 		WHERE holdingbranch = ?
# 		GROUP BY ref_nivel_bibliografico.description";

      my @filtros;

      push (@filtros, ( id_ui_poseedora => { eq => $id_ui}) );

      my $niveles = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
                                                                     query => \@filtros,
                                                                     select => ['*','COUNT(nivel_bibliografico) AS agregacion_temp'],
                                                                     group_by => ['nivel_bibliografico'],
                                                                     sort_by => ['ref_nivel_bibliografico.description'],
                                                                     with_objects => ['nivel2.ref_nivel_bibliografico'],
                                                                  );

      return (scalar(@$niveles),$niveles);
}

sub disponibilidadAnio {

    my ($id_ui,$ini,$fin)=@_;
    my @filtros;
    my $dateformat = C4::Date::get_date_format();
    use C4::Modelo::CatHistoricoDisponibilidad::Manager;
#       my $query="SELECT month( date )  AS mes, year( date )  AS year, avail, count( avail )  AS cantidad
#       FROM cat_detalle_disponibilidad
#       WHERE branch =  ?  AND date BETWEEN ? AND  ?
#       GROUP  BY year( date ) , month( date )  ORDER  BY month( date ) , year( date )";

   push (@filtros, ( id_ui => { eq => $id_ui}) );

   if ($ini ne ""){
      push(@filtros, ( 'fecha' => {       eq=> format_date_in_iso($ini,$dateformat), 
                                          gt => format_date_in_iso($ini,$dateformat), 
                                  }
                      ) );
   }
   if ($fin ne ""){
      push(@filtros, ( 'fecha' => {       eq=> format_date_in_iso($fin,$dateformat), 
                                          lt => format_date_in_iso($fin,$dateformat), 
                                  }
                     ) );
   }

   my $detalle_disponibilidad =
                     C4::Modelo::CatHistoricoDisponibilidad::Manager->get_cat_historico_disponibilidad(
                                                                                                query => \@filtros,
                                                                                                select => [ 'detalle',
                                                                                                            'YEAR(fecha) AS anio_agregacion',  
                                                                                                            'MONTH(fecha) AS mes_agregacion',
                                                                                                            'COUNT(detalle) AS agregacion_temp'],
                                                                                                group_by => ['YEAR(fecha), MONTH(fecha)'],
                                                                                                sort_by => ['MONTH(fecha), YEAR(fecha)'],
                                                                                                  );
   return (scalar(@$detalle_disponibilidad),$detalle_disponibilidad);
}

#Damian - 11/04/2007 - Para buscar a los usuarios que administran el sistema.
sub getuser{
	#my ($branch)=@_;
	my $dbh = C4::Context->dbh;
        my $query="SELECT surname, firstname,borrowernumber,cardnumber FROM borrowers ";
	   $query.="WHERE flags IS NOT NULL AND flags <> 0 ";
	my $sth=$dbh->prepare($query);
        $sth->execute();
	my %results;
	while (my $data=$sth->fetchrow_hashref){
		$data->{'nomCompleto'}=$data->{'surname'}.','.$data->{'firstname'};
		$results{$data->{'cardnumber'}}= $data;
	}
	return(\%results);
}

#Damian - 04/05/2007 - Para buscar la cantidad de prestamos de cada tipo (estadisticas generales).
sub estadisticasGenerales{
   my ($params_obj)=@_;
   my @filtros;
   
   if ($params_obj->{'chkfecha'} ne "false"){
      push(@filtros, ( fecha => {      eq => $params_obj->{'fechaInicio'}, 
                                       gt => $params_obj->{'fechaInicio'}, 
                                 }
                        ) );

      push(@filtros, ( fecha => {      eq => $params_obj->{'fechaFin'},
                                       lt => $params_obj->{'fechaFin'},
                                 }
                     ) );
   }
   my @filtros_temp;
   my $loop=scalar($params_obj->{'chck_array'});
   my @loop_array = $params_obj->{'chck_array'};
   if ($loop>0){
      my @filtros_temp;
      for (my $i=0; $i<$loop-1; $i++){
          push (@filtros_temp, (tipo_prestamo => { eq=>@loop_array[$i] }));
      }
      push (@filtros,@filtros_temp);
   }
   my $prestamos = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                     query => \@filtros,
                                                                     select => ['*','SUM(renovaciones) AS agregacion_temp'],
                                                                     group_by => ['tipo_prestamo',],

                                                                    );
   my $domiTotal=0;
   #my $noRenovados;
   my $devueltos;
   my $renovados;
   my $sala;
   my $foto;
   my $especial;


#FIXME que es esto????????????????????????????????????????????????????????????
=item
   while (my $data=$sth->fetchrow_hashref){
      if($data->{'issuecode'} eq 'DO'){
         if($data->{'renewals'}!=0){
            $renovados=$data->{'cant'};
         }
         $domiTotal=$domiTotal + $data->{'cant'};
      }
      elsif($data->{'issuecode'} eq 'SA'){
         $sala=$data->{'cant'};
      }
      elsif($data->{'issuecode'} eq 'FO'){
         $foto=$data->{'cant'};
      }
      else{
         $especial=$data->{'cant'};
      }
   }
=cut
if ($prestamos->[0]){
   $domiTotal = $especial = $prestamos->[0]->agregacion_temp; #ARREGLO TEMPORAL POR EL FIXME DE ARRIBA
}
#******Para saber cuantos libros se devolvieron***********
   if($domiTotal){
      if ($params_obj->{'chkfecha'} ne "false"){

         push(@filtros, ( fecha => {      eq => $params_obj->{'fechaInicio'}, 
                                          gt => $params_obj->{'fechaInicio'}, 
                                    }
                           ) );

         push(@filtros, ( fecha => {      eq => $params_obj->{'fechaFin'},
                                          lt => $params_obj->{'fechaFin'},
                                    }
                        ) );
      }
      push(@filtros, ( tipo_prestamo => { eq => 'DO'},));
      my $prestamos_domiciliarios = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                                          query => \@filtros,
                                                                                          group_by => ['tipo_prestamo',],
                                                                                       );
#       $devueltos=$data->{'devueltos'};
   }else {
            $domiTotal="";
         } # Si no es una busqueda por domiciliario para que no muestre 0 en el tmpl


    return ($domiTotal,$renovados,$devueltos,$sala,$foto,$especial); 
}


sub cantidadUsuariosPrestamos{
   my ($fechaInicio, $fechaFin, $chkfecha)=@_;
   my $dbh = C4::Context->dbh;
        my $query="SELECT nro_socio FROM  circ_prestamo ";
   my @bind;
   if ($chkfecha ne "false"){
      $query.=" WHERE (fecha_prestamo >=?) AND (fecha_prestamo <=?)";
      push(@bind,$fechaInicio);
      push(@bind,$fechaFin);
   }
   $query .=" GROUP BY nro_socio";

   my $sth=$dbh->prepare($query);
        $sth->execute(@bind);
   my $cant;
   if($sth->rows()!=0){
      $cant=$sth->rows();
   }

return ($cant);
}

sub cantidadUsuariosRenovados{
   my ($fechaInicio, $fechaFin, $chkfecha)=@_;
   my $dbh = C4::Context->dbh;
        my $query="SELECT nro_socio FROM  circ_prestamo WHERE renovaciones <> 0 ";
   my @bind;
   if ($chkfecha ne "false"){
      $query.=" AND (fecha_prestamo >=?) AND (fecha_prestamo <=?)";
      push(@bind,$fechaInicio);
      push(@bind,$fechaFin);
   }
   $query .=" GROUP BY nro_socio";

   my $sth=$dbh->prepare($query);
        $sth->execute(@bind);
   my $cant;
   if($sth->rows()!=0){
      $cant=$sth->rows();
   }

return ($cant);
}

sub cantidadUsuariosReservas{
   my ($fechaInicio, $fechaFin, $chkfecha)=@_;
   my $dbh = C4::Context->dbh;
        my $query="SELECT nro_socio FROM circ_reserva ";
   my @bind;
   if ($chkfecha ne "false"){
      $query.=" WHERE (fecha_reserva >=?) AND (fecha_reserva <=?)";
      push(@bind,$fechaInicio);
      push(@bind,$fechaFin);
   }
   $query .=" GROUP BY nro_socio";

   my $sth=$dbh->prepare($query);
        $sth->execute(@bind);
   my $cant;
   if($sth->rows()!=0){
      $cant=$sth->rows();
   }

return ($cant);
}

sub historialReservas {
  my ($bornum,$ini,$cantR)=@_;
 
  # RE HACER, ESTA DEPRECATED
  return (0,0);
}

sub historicoCirculacion{

    my ($params)=@_;
    use C4::Modelo::RepHistorialCirculacion::Manager;
    my @filtros;

    if ( $params->{'chkfecha'} ){
        push( @filtros,(fecha =>{eq => $params->{'fechaIni'}, gt => $params->{'fechaIni'}}) );
        push( @filtros,(fecha =>{eq => $params->{'fechaFin'}, lt => $params->{'fechaFin'}}) );
    }
    if ( $params->{'socio'} ){
        push( @filtros, (nro_socio => {eq => $params->{'socio'}} ) );
    }
    if( $params->{'tipoOperacion'} ne '-1' ){
        push( @filtros, (tipo_operacion => { eq => $params->{'tipoOperacion'}}) );
    }

    if( $params->{'tipoPrestamo'} ){
        push( @filtros, (tipo_prestamo => {eq => $params->{'tipoPrestamo'}}) );
    }

    if( $params->{'id3'} ){
        push( @filtros , (id3 => {eq => $params->{'id3'}}) );
    }

    my $orden = $params->{'orden'} || 'fecha',

    my $cantidad_registros = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion_count(
                                                                                                            query => \@filtros,
                                                                                                            require_objects => ['nivel1',
                                                                                                                                'nivel2',
                                                                                                                                'nivel3',
                                                                                                                                'socio',
#                                                                                                                                 'responsable',
                                                                                                                                'tipo_prestamo_ref',
                                                                                                                               ],
                                                                                                           );
    my $historicoCirculacion = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion(
                                                                                                            query => \@filtros,
                                                                                                            offset => $params->{'ini'},
                                                                                                            limit => $params->{'cantR'},
                                                                                                            sort_by => $orden,
                                                                                                            require_objects => ['nivel1',
                                                                                                                                'nivel2',
                                                                                                                                'nivel3',
                                                                                                                                'socio',
#                                                                                                                                 'responsable',
                                                                                                                                'tipo_prestamo_ref',
                                                                                                                               ],
                                                                                                           );
    return ($cantidad_registros,$historicoCirculacion);
}

sub historicoSanciones{
    my ($params_obj)=@_;
    use C4::Modelo::RepHistorialSancion::Manager;
    my @filtros;
    my @results;

    if ($params_obj->{'fechaIni'} ne ''){
        push (@filtros, ( fecha => {  eq => $params_obj->{'fechaIni'},
                                        gt => $params_obj->{'fechaIni'} }) );
    }
     
    if ($params_obj->{'fechaFin'} ne ''){   
        push (@filtros, ( fecha => {  eq => $params_obj->{'fechaFin'},
                                        lt => $params_obj->{'fechaFin'} }) );
    }
    
    if ( ($params_obj->{'socio'}) && ($params_obj->{'socio'} ne '-1') ){
        push (@filtros, ( responsable => { eq => $params_obj->{'socio'} },) );
    }
    
    if( ($params_obj->{'tipoOperacion'}) && ($params_obj->{'tipoOperacion'} ne '-1') ){
        push (@filtros, ( tipo_operacion => { eq => $params_obj->{'tipoOperacion'} },) );
    }
    # FIXME de donde saco el tipo de prestao
=item
    if ( ($params_obj->{'tipoPrestamo'}) && ($params_obj->{'tipoPrestamo'} ne '-1') ){
        push (@filtros, ( 'circ_tipo_sancion.tipo_operacion' => { eq => $params_obj->{'tipoPrestamo'} },) );
    }
=cut


    my $sanciones_count = C4::Modelo::RepHistorialSancion::Manager->get_rep_historial_sancion_count(
                                                                                query => \@filtros,
                                                                                #FIXME falta circ_tipo_sancion
                                                                                with_objects => ['usr_responsable','usr_nro_socio'],
                                                                            );
    
    my $sanciones_array_ref = C4::Modelo::RepHistorialSancion::Manager->get_rep_historial_sancion(
                                                                                query => \@filtros,
                                                                                #FIXME falta circ_tipo_sancion
                                                                                with_objects => ['usr_responsable','usr_nro_socio'],
                                                                                sorty_by => $params_obj->{'orden'},
                                                                                limit => $params_obj->{'cantR'},
                                                                                offset => $params_obj->{'ini'},
                                                                            );
    return ($sanciones_count,$sanciones_array_ref);
}


sub tipoDeOperacion(){
	my ($tipo)=@_;
	if($tipo eq "issue"){$tipo="Prestamo";}
	elsif($tipo eq "return"){$tipo="Devoluci&oacute;n";}
	elsif($tipo eq "cancel"){$tipo="Cancelaci&oacute;n";}
	elsif($tipo eq "notification"){$tipo="Notificaci&oacute;n (Vto. Reserva)";}
	elsif($tipo eq "queue"){$tipo="R. en Espera";}
	elsif($tipo eq "reserve"){$tipo="Reservado";}
	elsif($tipo eq "renew"){$tipo="Renovado";}
	elsif($tipo eq "reminder"){$tipo="Notificaci&oacute;n (Vto. Pr&eacute;stamo)";}
	elsif($tipo eq "Insert"){$tipo="Agregado";}	
	elsif($tipo eq "Delete"){$tipo="Borrado";}
	return $tipo;
}

sub userCategReport{
	my ($id_ui)=@_;
#         my $query=" SELECT categorycode, count( categorycode ) as cant FROM borrowers WHERE branchcode = ? GROUP BY categorycode  ";
   my @filtros;
   use C4::Modelo::UsrSocio::Manager;
   push (@filtros, ( id_ui => { eq => $id_ui },) );
   
#   FIXME: ver si anda! cambiado el 16/05 porque no esta mas cod_categoria en usr_socio, esta id_categoria
   my $socios = C4::Modelo::UsrSocio::Manager->get_usr_socio(
                                                               query => \@filtros,
                                                               select => ['*','COUNT(id_categoria) AS agregacion_temp'],
                                                               group_by => ['id_categoria'],
                                                               require_objects => ['categoria','ui'],
                                                            );
#  	my $clase='par';
# 	my $catcode;
# 	my $i=0;
# 	my %indices;
#         while (my $data=$sth->fetchrow_hashref){
# 	        if ($clase eq 'par') {$clase='impar'} else {$clase='par'};
# 		      $catcode=$data->{'categorycode'};
# 		      $indices{$catcode}=$i;
# 		      $results[$i]->{'reales'}=$data->{'cant'};
# 		      $results[$i]->{'categoria'}=C4::AR::Busquedas::getborrowercategory($data->{'categorycode'});
# 		      $results[$i]->{'clase'}=$clase;
# 		      $i++;
#         }
# 
# 	my $query=" SELECT categorycode, count( categorycode ) as cant FROM persons WHERE branchcode = ? AND borrowernumber IS NULL GROUP BY categorycode  ";
# 	$sth=$dbh->prepare($query);
#         $sth->execute($branch);
# 	while (my $data=$sth->fetchrow_hashref){
# 		$catcode=$data->{'categorycode'};
# 		if (not exists($indices{$catcode})){
# 			if ($clase eq 'par') {$clase='impar'} else {$clase='par'};
# 			$results[$i]->{'reales'}=0;
# 			$results[$i]->{'potenciales'}=$data->{'cant'};
# 			$results[$i]->{'categoria'}=C4::AR::Busquedas::getborrowercategory($data->{'categorycode'});
# 			$results[$i]->{'clase'}=$clase;
# 			$i++;
# 		}
# 		else{
# 			$results[$indices{$catcode}]->{'potenciales'}=$data->{'cant'};
# 		}
# 	}
         return (scalar(@$socios),$socios);
}

=item
SE USA EN EL REPORTE Generar Etiquetas
=cut
sub signaturamax {
 my ($branch) = @_;
	my $dbh = C4::Context->dbh;
	my $sth = $dbh->prepare("SELECT MAX(signatura_topografica) AS max FROM cat_nivel3 WHERE signatura_topografica IS NOT NULL AND signatura_topografica <> '' AND homebranch = ?");
	$sth->execute($branch);
	my $res= ($sth->fetchrow_hashref)->{'max'};
	return $res;
}

=item
SE USA EN EL REPORTE Generar Etiquetas
=cut
sub signaturamin {
 my ($branch) = @_;
	my $dbh = C4::Context->dbh;
	my $sth = $dbh->prepare("SELECT MIN(signatura_topografica) AS min FROM cat_nivel3 WHERE signatura_topografica IS NOT NULL AND signatura_topografica <> '' AND homebranch = ?");
	$sth->execute($branch);
	my $res= ($sth->fetchrow_hashref)->{'min'};
	return $res;
	}


sub listaDeEjemplares {
# FIXME falta el tema de paginar cuando es pdf (o sea, no hay que paginar)
    my ($params) = @_;

    my $id_ui=  $params->{'id_ui'} || C4::AR::Preferencias::getValorPreferencia('defaultUI');

    my @filtros;

    if (C4::AR::Utilidades::validateString($params->{'sig_top_begin'})){
        push (@filtros,( signatura_topografica => { like => $params->{'sig_top_begin'}.'%'}));
    }
    else {
        if ((C4::AR::Utilidades::validateString($params->{'inv_desde'})) & (C4::AR::Utilidades::validateString($params->{'inv_hasta'})) ){
            push (@filtros,(barcode => {eq => $params->{'inv_desde'},
                                        gt => $params->{'inv_desde'},
                                        }));
            push (@filtros,(barcode => {eq => $params->{'inv_hasta'},
                                        lt => $params->{'inv_hasta'},
                                        }));
        }
        if ( (C4::AR::Utilidades::validateString($params->{'sig_top_desde'})) and (C4::AR::Utilidades::validateString($params->{'sig_top_hasta'})) ){
                push (@filtros,(signatura_topografica => {eq => $params->{'sig_top_desde'},
                                            gt => $params->{'sig_top_desde'},
                                            }));
                push (@filtros,(signatura_topografica => {eq => $params->{'sig_top_hasta'},
                                            lt => $params->{'sig_top_hasta'},
                                            }));
        }
    }

    if (substr($params->{'id_ui'},0,3) ne "SIN"){
        push (@filtros,( id_ui_origen => { eq => $params->{'id_ui'}.'%'}));
    }

    my $results_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count( query => \@filtros,
                                                                              require_objects => ['nivel2','nivel1'],
                                                                    );
    my $results;

    if ($params->{'accion'} ne "pdf"){
        $results = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( query => \@filtros,
                                                                      limit => $params->{'cantR'},
                                                                      offset => $params->{'ini'},
                                                                      require_objects => ['nivel2','nivel1'],
                                                                     );
    }else{
        $results = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( query => \@filtros,
                                                                      require_objects => ['nivel2','nivel1'],
                                                                    );
    }

    return ($results_count,$results);
}

END { }       # module clean-up code here (global destructor)

1;
__END__
