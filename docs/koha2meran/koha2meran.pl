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

use utf8;
use lib "/usr/share/meran/dev/intranet/modules/";
#use C4::Output;  
#use C4::AR::Auth;
use C4::Context;
use CGI::Session;
use CGI;

#use Rose::DB;

use MARC::Record;
use Digest::SHA  qw(sha1 sha1_hex sha1_base64 sha256_base64 );

#use C4::AR::Sphinx;
#use C4::AR::PortadasRegistros;
#use C4::Modelo::UsrSocio;
#use C4::Modelo::UsrSocio::Manager;

my @N1;
my @N2;
my @N3;
my $autor;
my @ids1=();
my @valores1=();
my @ids2=();
my @valores2=();
my @ids3=();
my @valores3=();
my $id1;
my $id2;
my $tipoDocN2;
my $id3;

##Otras Tablas que se fusionan##
my $subject;
my $subtitle;
my $isbn;
my $publisher;
my $additionalauthor;
###############################

my $dbh = C4::Context->dbh;

print "INICIO \n";
my $tt1 = time();

 print "Creando tablas necesarias \n";
     crearTablasNecesarias();
 
 print "Creando nuevas referencias \n";
     crearNuevasReferencias();

 print "Modificando ciudades \n";
    modificarCiudades();

 print "Agregando ciudades \n";
    agregarCiudades();
 
# #################
 print "Procesando los 3 niveles (va a tardar!!! ...MUCHO!!! mas de lo que te imaginas) \n";
 my $st1 = time();
    procesarV2_V3();
 my $end1 = time();
 my $tardo1=($end1 - $st1);
 print "AL FIN TERMINO!!! Tardo $tardo1 segundos !!!\n";
# #################

 print "Renombrando tablas \n";
   renombrarTablas();
 print "Quitando tablas de mas \n";
  quitarTablasDeMas();
 print "Hasheando passwords \n";
  hashearPasswords();
 print "Limpiamos las tablas de circulacion \n";
# limpiarCirculacion();
 print "Referencias de usuarios en circulacion \n";
 my $st2 = time();
   repararReferenciasDeUsuarios();
 my $end2 = time();
 my $tardo2=($end2 - $st2);
 print "AL FIN TERMINARON LOS USUARIOS!!! Tardo $tardo2 segundos !!!\n";
 
 print "Relacion usuario-persona \n";
   crearRelacionUsuarioPersona();
 print "Creando nuevas claves foraneas \n";
   crearClaves();
 print "Creando la estructura MARC \n";
 crearEstructuraMarc();
 print "Traducción Estructura MARC \n";
   traduccionEstructuraMarc();
 print "Agregando preferencias del sistema \n";
   agregarPreferenciasDelSistema();
 #print "Dando permisos a los usuarios \n";
  # dandoPermisosUsuarios();
 print "Procesando Analíticas \n";
  procesarAnaliticas();
 print "Cambiar codificación a UTF8 \n";
  pasarBaseUTF8();

 print "Actualiar hasta el final \n";
   actualizarMeran();
   
print "FIN!!! \n";
my $tt2 = time();
print "\n GRACIAS DICO!!! \n";

my $tardo2=($tt2 - $tt1);
my $min= $tardo2/60;
my $hour= $min/60;
print "AL FIN TERMINO TODO!!! Tardo $tardo2 segundos !!! que son $min minutos !!! o mejor $hour horas !!!\n";

#-----------------------------------------------------------------------------------------------------------------------------------#-----------------------------------------------------------------------------------------------------------------------------------#-----------------------------------------------------------------------------------------------------------------------------------#-----------------------------------------------------------------FUNCIONES---------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------#-----------------------------------------------------------------------------------------------------------------------------------#-----------------------------------------------------------------------------------------------------------------------------------
    sub buscarLocalidad
    { my ($localidad) = @_;

      my $loc1=$dbh->prepare("SELECT id  FROM localidades where nombre = ? ;");
         $loc1->execute($localidad);
      my $id=$loc1->fetchrow;
        $loc1->finish();

      unless ($id){
	#la agrego si no existe
	my $loc2=$dbh->prepare("INSERT INTO localidades (`LOCALIDAD`, `NOMBRE`, DPTO_PARTIDO, `DDN`) VALUES ('9999', ?, '9999', '');");
        $loc2->execute($localidad);
        $loc2->finish();

      my $loc3=$dbh->prepare("SELECT id  FROM localidades where nombre = ? ;");
         $loc3->execute($localidad);
         $id=$loc3->fetchrow;
        $loc3->finish();
	}

	return $id;
    }

    sub buscarLocalidadDesdeId
    { my ($idlocalidad) = @_;
      if($idlocalidad){
      my $loc=$dbh->prepare("SELECT id  FROM ref_localidad where localidad = ? ;");
         $loc->execute($idlocalidad);
      my $id=$loc->fetchrow;
        $loc->finish();
      return $id;}
      else {
        return '';
      }
    }

    sub buscarReferenciaColaborador
    { my ($tipo) = @_;
        #No existe aún la tabla de referencias y el campo en Koha no está normalizado!
        #Se recata los que se pueden
        if($tipo eq 'rev.') { return 'rev';}
        if(($tipo eq 'ed.')||($tipo eq 'ed')||($tipo eq 'Editor')) { return 'edt';}
        if(($tipo eq 'dir.')||($tipo eq 'dir. y  re')||($tipo eq 'director')) { return 'drt';}
        if($tipo eq 'tr.') { return 'trl';}
        if($tipo eq 'pref.') { return 'prf';}
        if($tipo eq 'il.')   { return 'ill';}
        if(($tipo eq 'com.')||($tipo eq 'comp.')) { return 'com';}
        #indefinido!!
        return 'oth';
    }
    
    
	sub procesarV2_V3 
	{

	my $cant_biblios=$dbh->prepare("SELECT count(*) as cantidad FROM biblio ;");
	$cant_biblios->execute();
	my $cantidad=$cant_biblios->fetchrow;
	my $registro=1;
	print "Se van a procesar $cantidad registros \n";


	
	my $biblios=$dbh->prepare("SELECT * FROM biblio ;");
	$biblios->execute();

	#Obtengo los campos del nivel 1
	my $campos_n1=$dbh->prepare("SELECT * FROM cat_pref_mapeo_koha_marc where tabla='biblio';");
	$campos_n1->execute();
	while (my $n1=$campos_n1->fetchrow_hashref) {
	push (@N1,$n1);
	}
	$campos_n1->finish();

	#Obtengo los campos del nivel 2
	my $campos_n2=$dbh->prepare("SELECT * FROM cat_pref_mapeo_koha_marc where tabla='biblioitems';");
	$campos_n2->execute();
	while (my $n2=$campos_n2->fetchrow_hashref) {
	push (@N2,$n2);	
	}
	$campos_n2->finish();

	#Obtengo los campos del nivel 3
	my $campos_n3=$dbh->prepare("SELECT * FROM cat_pref_mapeo_koha_marc where tabla='items';");
	$campos_n3->execute();
	while (my $n3=$campos_n3->fetchrow_hashref) {
	push (@N3,$n3);
	}
	$campos_n3->finish();

	####################################Otras Tablas#######################################
	my $kohaToMARC1=$dbh->prepare("SELECT * FROM cat_pref_mapeo_koha_marc where tabla='bibliosubject';");
	$kohaToMARC1->execute();
	$subject=$kohaToMARC1->fetchrow_hashref;
	$kohaToMARC1->finish();

	my $kohaToMARC2=$dbh->prepare("SELECT * FROM cat_pref_mapeo_koha_marc where tabla='bibliosubtitle';");
	$kohaToMARC2->execute();
	$subtitle=$kohaToMARC2->fetchrow_hashref;
	$kohaToMARC2->finish();

	my $kohaToMARC3=$dbh->prepare("SELECT * FROM cat_pref_mapeo_koha_marc where tabla='additionalauthors';");
	$kohaToMARC3->execute();
	$additionalauthor=$kohaToMARC3->fetchrow_hashref;
	$kohaToMARC3->finish();

	my $kohaToMARC4=$dbh->prepare("SELECT * FROM cat_pref_mapeo_koha_marc where tabla='publisher';");
	$kohaToMARC4->execute();
	$publisher=$kohaToMARC4->fetchrow_hashref;
	$kohaToMARC4->finish();

	my $kohaToMARC5=$dbh->prepare("SELECT * FROM cat_pref_mapeo_koha_marc where tabla='isbns';");
	$kohaToMARC5->execute();
	$isbn=$kohaToMARC5->fetchrow_hashref;
	$kohaToMARC5->finish();


	my $kohaToMARC6=$dbh->prepare("SELECT * FROM cat_pref_mapeo_koha_marc where tabla='colaboradores';");
	$kohaToMARC6->execute();
	$colaborador=$kohaToMARC6->fetchrow_hashref;
	$kohaToMARC6->finish();
    
	###############################################################################

	while (my $biblio=$biblios->fetchrow_hashref ) {
	
	my $porcentaje= int (($registro * 100) / $cantidad );
 	print "Procesando registro: $registro de $cantidad ($porcentaje%) \r";



#---------------------------------------NIVEL1---------------------------------------#


	foreach (@N1) {
		my $dn1;
		$dn1->{'campo'}=$_->{'campo'};
		$dn1->{'subcampo'}=$_->{'subcampo'};
		if($_->{'campoTabla'} eq 'author'){ 
		      $dn1->{'valor'}='cat_autor@'.$biblio->{$_->{'campoTabla'}}; 
		  }
		  else { $dn1->{'valor'}=$biblio->{$_->{'campoTabla'}};}

		$dn1->{'simple'}=1;
		if (($dn1->{'valor'} ne '') && ($dn1->{'valor'} ne null)){push(@ids1,$dn1);}
	}

	###########################OTRAS TABLA biblio##########################
	# subject
	my $temas=$dbh->prepare("SELECT * FROM bibliosubject where biblionumber= ?;");
	$temas->execute($biblio->{'biblionumber'});

	while (my $biblosubject=$temas->fetchrow_hashref ) {
	    my $dn1tema;
	    $dn1tema->{'campo'}=$subject->{'campo'};
	    $dn1tema->{'subcampo'}=$subject->{'subcampo'};
	    $dn1tema->{'simple'}=1;
	    $dn1tema->{'valor'}='cat_tema@'.$biblosubject->{$subject->{'campoTabla'}};
	    push(@ids1,$dn1tema);
	}
	$temas->finish();

	# subtitle
	my $subtitulos=$dbh->prepare("SELECT * FROM bibliosubtitle where biblionumber= ?;");
	$subtitulos->execute($biblio->{'biblionumber'});

	while (my $biblosubtitle=$subtitulos->fetchrow_hashref ) {
	  my $dn1sub;
	  $dn1sub->{'campo'}=$subtitle->{'campo'};
	  $dn1sub->{'subcampo'}=$subtitle->{'subcampo'};
	  $dn1sub->{'simple'}=1;
	  $dn1sub->{'valor'}=$biblosubtitle->{$subtitle->{'campoTabla'}};
	  push(@ids1,$dn1sub);
	}
	$subtitulos->finish();

	# additionalauthor
	
	my $additionalauthors=$dbh->prepare("SELECT * FROM additionalauthors where id1= ?;");
	$additionalauthors->execute($biblio->{'biblionumber'});
	while (my $aauthors=$additionalauthors->fetchrow_hashref ) {
	  my $dn1add;
	  $dn1add->{'campo'}=$additionalauthor->{'campo'};
	  $dn1add->{'subcampo'}=$additionalauthor->{'subcampo'};
	  $dn1add->{'simple'}=1;
	  $dn1add->{'valor'}='cat_autor@'.$aauthors->{$additionalauthor->{'campoTabla'}};
	  push(@ids1,$dn1add);
	}
	$additionalauthors->finish();


	# colaboradores
	
	my $colaboradores=$dbh->prepare("SELECT * FROM colaboradores where id1= ?;");
	$colaboradores->execute($biblio->{'biblionumber'});
	while (my $colabs=$colaboradores->fetchrow_hashref ) {
	  my $dn1col;
	  $dn1col->{'campo'}=$colaborador->{'campo'};
	  $dn1col->{'subcampo'}=$colaborador->{'subcampo'};
	  $dn1col->{'simple'}=1;
	  $dn1col->{'valor'}='cat_autor@'.$colabs->{$colaborador->{'campoTabla'}};
      
      #print "COLABORADOR NUEVO!!! ".$dn1col->{'valor'}."\n";
      
	  push(@ids1,$dn1col);
    #Y la referencia?? =>> 700 e
    
      my $dn1colref;
	  $dn1colref->{'campo'}='700';
	  $dn1colref->{'subcampo'}='e';
	  $dn1colref->{'simple'}=1;
      my $tipo_colaborador= buscarReferenciaColaborador($colabs->{'tipo'});
      
      if ($tipo_colaborador){
        $dn1colref->{'valor'}='ref_colaborador@'.$tipo_colaborador;
        #print "REFERENCIA COLABORADOR!!! ".$dn1colref->{'valor'}."\n";
        push(@ids1,$dn1colref);
      }

        
	}
	$colaboradores->finish();

	#########################################################################
	my($error,$codMsg);
	&guardaNivel1MARC($biblio->{'biblionumber'},\@ids1);

#---------------------------------------FIN NIVEL1---------------------------------------#	

#---------------------------------------NIVEL2---------------------------------------#
	my $biblioitems=$dbh->prepare("SELECT * FROM biblioitems where biblionumber= ?;");
	$biblioitems->execute($biblio->{'biblionumber'});
	while (my $biblioitem=$biblioitems->fetchrow_hashref ) {
	foreach (@N2) {
		my $dn2;
		$dn2->{'campo'}=$_->{'campo'};
		$dn2->{'subcampo'}=$_->{'subcampo'};

        if($_->{'campoTabla'} eq 'itemtype'){ $dn2->{'valor'}='cat_ref_tipo_nivel3@'.$biblioitem->{$_->{'campoTabla'}}; }
        elsif($_->{'campoTabla'} eq 'idLanguage'){ $dn2->{'valor'}='ref_idioma@'.$biblioitem->{$_->{'campoTabla'}}; }
        elsif($_->{'campoTabla'} eq 'volume'){ 
			#Hay que ver si se trata de una revista (863 a) o de otra cosa (440 v) y queda como está
			$dn2->{'valor'}='ref_idioma@'.$biblioitem->{$_->{'campoTabla'}}; 
			if($biblioitem->{'itemtype'} eq 'REV'){
				$dn2->{'campo'}='863';
				$dn2->{'subcampo'}='a';
			}
			$dn2->{'valor'}=$biblioitem->{$_->{'campoTabla'}}; 
		}
		elsif($_->{'campoTabla'} eq 'publicationyear'){ 
			#Hay que ver si se trata de una revista (863 i) o de otra cosa (260 c) y queda como está
			$dn2->{'valor'}='ref_idioma@'.$biblioitem->{$_->{'campoTabla'}}; 
			if($biblioitem->{'itemtype'} eq 'REV'){
				$dn2->{'campo'}='863';
				$dn2->{'subcampo'}='i';
			}
			$dn2->{'valor'}=$biblioitem->{$_->{'campoTabla'}}; 
		}
        elsif($_->{'campoTabla'} eq 'idCountry'){ $dn2->{'valor'}='ref_pais@'.$biblioitem->{$_->{'campoTabla'}}; } # LA Localidad pasa como texto
        elsif($_->{'campoTabla'} eq 'place'){ #Esto no se puede pasar sin buscar la referencia
                      my $idLocalidad= buscarLocalidad($biblioitem->{$_->{'campoTabla'}});
                       if($idLocalidad){
			    $dn2->{'valor'}='ref_localidad@'.$idLocalidad; 
		       } else {
			    $dn2->{'valor'}=$biblioitem->{$_->{'campoTabla'}};
		      }
        }
        elsif($_->{'campoTabla'} eq 'idSupport'){ $dn2->{'valor'}='ref_soporte@'.$biblioitem->{$_->{'campoTabla'}}; }
        elsif($_->{'campoTabla'} eq 'classification'){ $dn2->{'valor'}='ref_nivel_bibliografico@'.$biblioitem->{$_->{'campoTabla'}}; }
          else { $dn2->{'valor'}=$biblioitem->{$_->{'campoTabla'}}; }

		$dn2->{'simple'}=1;
		if (($dn2->{'valor'} ne '') && ($dn2->{'valor'} ne null)){push(@ids2,$dn2);}
	}
	
	###########################OTRAS TABLAS biblioitem##########################
	# publisher
	
	my $sth15=$dbh->prepare("SELECT * FROM publisher where biblioitemnumber= ?;");
	$sth15->execute($biblioitem->{'biblioitemnumber'});
	while (my $pub=$sth15->fetchrow_hashref ) {
		my $dn2;
		$dn2->{'campo'}=$publisher->{'campo'};
		$dn2->{'subcampo'}=$publisher->{'subcampo'};
		$dn2->{'simple'}=1;
		$dn2->{'valor'}=$pub->{$publisher->{'campoTabla'}};
		push(@ids2,$dn2);
	}
	$sth15->finish();
	
	# isbn

	my $sth16=$dbh->prepare("SELECT * FROM isbns where biblioitemnumber= ?;");
	$sth16->execute($biblioitem->{'biblioitemnumber'});

	while (my $is =$sth16->fetchrow_hashref ) {
		my $dn2;
		$dn2->{'campo'}=$isbn->{'campo'};
		$dn2->{'subcampo'}=$isbn->{'subcampo'};
		$dn2->{'simple'}=1;
		$dn2->{'valor'}=$is->{$isbn->{'campoTabla'}};
		push(@ids2,$dn2);
	}

	$sth16->finish();
	########################################################################

    &guardaNivel2MARC($biblio->{'biblionumber'},$biblioitem->{'biblioitemnumber'},\@ids2);

#ACA HAY QUE PROCESAR LAS ANALITICAS DE ESTE NIVEL 2!!!!!!!!!!!!!!!!!!!!!!!!!!!!


#

#---------------------------------------NIVEL3---------------------------------------#	

	my $items=$dbh->prepare("SELECT * FROM items where biblioitemnumber= ?;");
	$items->execute($biblioitem->{'biblioitemnumber'});
	while (my $item=$items->fetchrow_hashref ) {
	foreach (@N3) {
		my $dn3;
		$dn3->{'campo'}=$_->{'campo'};
		$dn3->{'subcampo'}=$_->{'subcampo'};

		my $val='';

        if($_->{'campoTabla'} eq 'notforloan'){   
	    my $disponibilidad = getDisponibilidad($item->{$_->{'campoTabla'}}) || 'CIRC0001'; # Para sala por defecto.
	    $val='ref_disponibilidad@'.$disponibilidad;
	}
        elsif($_->{'campoTabla'} eq 'homebranch'){$val='pref_unidad_informacion@'.$item->{$_->{'campoTabla'}}; }
        elsif($_->{'campoTabla'} eq 'wthdrawn'){ 
                                            if ($item->{$_->{'campoTabla'}}){
                                                     # Si no es 0 va con el valor original
							  my $estado = getEstado($item->{$_->{'campoTabla'}}) || 'STATE000'; #Si no se encuentra la disponibilidad, de baja.
                                                          $val='ref_estado@'.$estado;
                                                    }
                                                    else {
                                                     # Si es 0, está disponible, va con el nuevo estado que es STATE002
                                                          $val='ref_estado@STATE002';
                                                    } #Esta disponible ==> STATE002
                                                 }
        elsif($_->{'campoTabla'} eq 'holdingbranch'){ $val='pref_unidad_informacion@'.$item->{$_->{'campoTabla'}}; }
          else { $val=$item->{$_->{'campoTabla'}}; }


		$dn3->{'valor'}=$val;
		$dn3->{'simple'}=1;
		if (($dn3->{'valor'} ne '') && ($dn3->{'valor'} ne null)){push(@ids3,$dn3);}
	}
	
	&guardaNivel3MARC($biblio->{'biblionumber'},$biblioitem->{'biblioitemnumber'},$item->{'itemnumber'},\@ids3);


	@ids3=();
	@valores3=();	
	}
	$items->finish();
#---------------------------------------FIN NIVEL3---------------------------------------#	
	@ids2=();
	@valores2=();
	}
	$biblioitems->finish();
#---------------------------------------FIN NIVEL2---------------------------------------#
	@ids1=();
	@valores1=();
	$registro++;    
 }
    $biblios->finish();
#---------------------------------------FIN NIVEL1---------------------------------------#

	}

	sub crearNuevasReferencias
	{
	#########################################################################
	#			NUEVAS REFERENCIAS!!!!!				#
	#########################################################################
	
	#Nivel 1#

	my $col=$dbh->prepare("ALTER TABLE `colaboradores` CHANGE biblionumber `id1` INT( 11 ) NOT NULL FIRST ;");
   	$col->execute();

    my $adaut=$dbh->prepare("ALTER TABLE additionalauthors CHANGE biblionumber `id1` INT( 11 ) NOT NULL FIRST ;");
    $adaut->execute();

	#Nivel 2#
	my $banalysis=$dbh->prepare("ALTER TABLE `biblioanalysis` CHANGE biblionumber `id1` INT( 11 ) NOT NULL FIRST , 
					CHANGE biblioitemnumber `id2` INT( 11 ) NOT NULL AFTER `id1` ;");
	$banalysis->execute();
	my $reserves=$dbh->prepare("ALTER TABLE `reserves` CHANGE biblioitemnumber `id2` INT( 11 ) NOT NULL FIRST , 
					CHANGE itemnumber `id3` INT( 11 ) NULL AFTER `id2` ;");
	$reserves->execute();
	my $estantes=$dbh->prepare("ALTER TABLE `shelfcontents` CHANGE biblioitemnumber `id2` INT( 11 ) NOT NULL FIRST ;");
	$estantes->execute();
	#Nivel 3#
	my $av1=$dbh->prepare("ALTER TABLE `availability` CHANGE item `id3` INT( 11 ) NOT NULL FIRST ;");
	$av1->execute();

	my $hi1=$dbh->prepare("ALTER TABLE `historicIssues` CHANGE itemnumber `id3` INT( 11 ) NOT NULL FIRST ;");
	$hi1->execute();

	my $hc1=$dbh->prepare("ALTER TABLE `historicCirculation` CHANGE biblionumber `id1` INT( 11 ) NOT NULL AFTER `id` ,
		CHANGE biblioitemnumber `id2` INT( 11 ) NOT NULL AFTER `id1` ,
		CHANGE itemnumber `id3` INT( 11 ) NOT NULL AFTER `id2` ;");
	$hc1->execute();

	my $is1=$dbh->prepare("ALTER TABLE `issues` CHANGE itemnumber `id3` INT( 11 ) NOT NULL FIRST ;");
	$is1->execute();
	#Los 3 Niveles#
	my $mod=$dbh->prepare("ALTER TABLE `modificaciones` CHANGE numero `id` INT( 11 ) NOT NULL AFTER idModificacion ;");
	$mod->execute();

    my $loc1=  $dbh->prepare("ALTER TABLE localidades DROP PRIMARY KEY;");
    $loc1->execute();
    my $loc2=  $dbh->prepare("ALTER TABLE localidades ADD `id` INT NOT NULL AUTO_INCREMENT FIRST ,ADD PRIMARY KEY ( id );");
    $loc2->execute();
	#########################################################################
	#			FIN NUEVAS REFERENCIAS!!!!!			#
	#########################################################################
	}

	sub crearTablasNecesarias 
	{
	#########################################################################
	#			CREAR TABLAS NECESARIAS!!!			#
	#########################################################################

    my $dropear=$dbh->prepare("DROP TABLE IF EXISTS `cat_registro_marc_n3` ,`cat_registro_marc_n2`, `cat_registro_marc_n1`;");
    $dropear->execute();
    
    aplicarSQL("tablasNuevas.sql");

}


    sub renombrarTablas
    {
    #########################################################################
    #           Renombramos tablas!!!             #
    #########################################################################
        my %hash = ();
        $hash{ 'biblioanalysis' } = 'cat_analitica';
        $hash{ 'autores' } = 'cat_autor';
        $hash{ 'analyticalauthors' } = 'cat_autor_analitica';
        $hash{ 'colaboradores' } = 'cat_colaborador';
        $hash{ 'shelfcontents' } = 'cat_contenido_estante';
        $hash{ 'publisher' } = 'cat_editorial';
        $hash{ 'bookshelf' } = 'cat_estante';
        $hash{ 'availability' } = 'cat_historico_disponibilidad';
        $hash{ 'referenciaColaboradores' } = 'cat_ref_colaborador';
        $hash{ 'itemtypes' } = 'cat_ref_tipo_nivel3';
        $hash{ 'temas' } = 'cat_tema';
        $hash{ 'analyticalsubject' } = 'cat_tema_analitica';
        $hash{ 'issues' } = 'circ_prestamo';
        $hash{ 'issuetypes' } = 'circ_ref_tipo_prestamo';
        $hash{ 'sanctionrules' } = 'circ_regla_sancion';
        $hash{ 'sanctiontypesrules' } = 'circ_regla_tipo_sancion';
        $hash{ 'reserves' } = 'circ_reserva';
        $hash{ 'sanctions' } = 'circ_sancion';
        $hash{ 'sanctionissuetypes' } = 'circ_tipo_prestamo_sancion';
        $hash{ 'sanctiontypes' } = 'circ_tipo_sancion';
        $hash{ 'branchcategories' } = 'pref_categoria_unidad_informacion';
        $hash{ 'feriados' } = 'pref_feriado';
        $hash{ 'iso2709' } = 'pref_iso2709';
        $hash{ 'stopwords' } = 'pref_palabra_frecuente';
        $hash{ 'systempreferences' } = 'pref_preferencia_sistema';
        $hash{ 'branchrelations' } = 'pref_relacion_unidad_informacion';
        $hash{ 'branches' } = 'pref_unidad_informacion';
        $hash{ 'authorised_values' } = 'pref_valor_autorizado';
        $hash{ 'dptos_partidos' } = 'ref_dpto_partido';
        $hash{ 'languages' } = 'ref_idioma';
        $hash{ 'localidades' } = 'ref_localidad';
        $hash{ 'bibliolevel' } = 'ref_nivel_bibliografico';
        $hash{ 'countries' } = 'ref_pais';
        $hash{ 'provincias' } = 'ref_provincia';
        $hash{ 'supports' } = 'ref_soporte';
        $hash{ 'historicCirculation' } = 'rep_historial_circulacion';
        $hash{ 'historicIssues' } = 'rep_historial_prestamo';
        $hash{ 'historicSanctions' } = 'rep_historial_sancion';
        $hash{ 'modificaciones' } = 'rep_registro_modificacion';
        $hash{ 'persons' } = 'usr_persona';
        $hash{ 'borrowers' } = 'usr_socio';
        $hash{ 'deletedborrowers' } = 'usr_socio_borrado';
        $hash{ 'historialBusqueda' } = 'rep_historial_busqueda';
        $hash{ 'busquedas' } = 'rep_busqueda';
        $hash{ 'sessions' } = 'sist_sesion';
        $hash{ 'userflags' } = 'usr_permiso';

        foreach my $llave (keys %hash){
            my $rename=$dbh->prepare("RENAME TABLE ".$llave." TO ".$hash{$llave}."; ");
            $rename->execute();
        } 

### Despues de renombrar hay que alterarlas 

   aplicarSQL("ultimosUpdates.sql");

    }

    sub quitarTablasDeMas 
    {
    #########################################################################
    #           QUITAR TABLAS DE MAS!!!             #
    #########################################################################
    my @drops = ('accountlines', 'accountoffsets', 'aqbookfund', 'aqbooksellers', 'aqbudget', 'aqorderbreakdown', 'aqorderdelivery', 'aqorders', 
                  'biblio', 'biblioitems', 'bibliothesaurus', 'borexp', 'branchtransfers', 'catalogueentry', 'categoryitem', 'currency', 'defaultbiblioitem', 
                  'deletedbiblio', 'deletedbiblioitems', 'deleteditems', 'ethnicity', 'isbns', 'isomarc', 'items', 'itemsprices', 'marcrecorddone', 
                  'marc_biblio', 'marc_blob_subfield', 'marc_breeding', 'marc_subfield_structure', 'marc_subfield_table', 'marc_tag_structure', 'marc_word', 
                  'printers', 'relationISO', 'reserveconstraints', 'statistics', 'virtual_itemtypes', 'virtual_request', 'websites', 'z3950queue', 
                  'z3950results', 'z3950servers', 'uploadedmarc','generic_report_joins','generic_report_tables','tablasDeReferencias','tablasDeReferenciasInfo',
                  'additionalauthors','bibliosubtitle','bibliosubject','sessionqueries','analyticalkeyword','keyword','unavailable','users','categories','stopwords');

      foreach $tabla (@drops) {
        my $drop=$dbh->prepare(" DROP TABLE ".$tabla." ;");
        $drop->execute();
      }

  }

  sub crearRelacionUsuarioPersona    
  {

#Default ui
    my $q_ui=$dbh->prepare("SELECT value FROM pref_preferencia_sistema where variable ='defaultbranch';");
    $q_ui->execute();
    my $ui=$q_ui->fetchrow || 'DEO';


# Le agrega el id_persona a usr_socio 
    my $usuarios=$dbh->prepare("SELECT * FROM usr_socio;");
    $usuarios->execute();

    while (my $usuario=$usuarios->fetchrow_hashref) {
        my $persona=$dbh->prepare("SELECT id_persona FROM usr_persona WHERE  nro_documento= ? ;");
        $persona->execute($usuario->{'documentnumber'});
        my $id_persona=$persona->fetchrow;
        

        if (!$id_persona) {
             #No existe la persona HAY QUE CREARLA!!!
        my $nueva_persona=$dbh->prepare("INSERT into usr_persona (nro_documento,tipo_documento,apellido,nombre,titulo,
                                        otros_nombres,iniciales,calle,barrio,ciudad,telefono,email,fax,msg_texto,
                                        alt_calle,alt_barrio,alt_ciudad,alt_telefono,nacimiento,sexo,
                                        telefono_laboral,es_socio,cumple_condicion,legajo) 
                                        values (?,?,?,?,?,
                                                ?,?,?,?,?,?,?,?,?,
                                                ?,?,?,?,?,?,
                                                ?,'1','1','');");
        $nueva_persona->execute($usuario->{'documentnumber'},$usuario->{'documenttype'},$usuario->{'surname'},$usuario->{'firstname'},$usuario->{'title'},
                                $usuario->{'othernames'},$usuario->{'initials'},$usuario->{'streetaddress'},$usuario->{'suburb'},buscarLocalidadDesdeId($usuario->{'city'}),$usuario->{'phone'},$usuario->{'emailaddress'},$usuario->{'faxnumber'},$usuario->{'textmessaging'},
                                $usuario->{'altstreetaddress'},$usuario->{'altsuburb'},buscarLocalidadDesdeId($usuario->{'altcity'}),$usuario->{'altphone'},$usuario->{'dateofbirth'},$usuario->{'sex'}, 
                                $usuario->{'phoneday'});
        
        $persona->execute($usuario->{'documentnumber'});
        $id_persona=$persona->fetchrow;

          }
            my $upuspr=$dbh->prepare(" UPDATE usr_socio SET id_persona = ? WHERE nro_socio= ? ;");
            $upuspr->execute($id_persona,$usuario->{'nro_socio'});
     
            #seteamos que es socio
            my $persocio=$dbh->prepare(" UPDATE usr_persona SET es_socio='1' WHERE id_persona= ? ;");
            $persocio->execute($id_persona);
    }

#Limpiamos usr_socio
       my $limpiando_usr= "ALTER TABLE `usr_socio`  DROP documentnumber  , DROP `documenttype`,  DROP `surname`,  DROP `firstname`,  DROP `title`,  DROP `othernames`,
        DROP `initials`,  DROP `streetaddress`,  DROP `suburb`,  DROP `city`,  DROP `phone`,  DROP `emailaddress`,  DROP `faxnumber`,
        DROP `textmessaging`,  DROP `altstreetaddress`,  DROP `altsuburb`,  DROP `altcity`,  DROP `altphone`,  DROP `dateofbirth`,  
        DROP `gonenoaddress`,  DROP `lost`,  DROP `debarred`,  DROP `studentnumber`,  DROP `school`,  DROP `contactname`,
        DROP `borrowernotes`,  DROP `guarantor`,  DROP `area`,  DROP `ethnicity`,  DROP `ethnotes`,  DROP `sex`,  DROP `altnotes`,
        DROP `altrelationship`,  DROP `streetcity`,  DROP `phoneday`,  DROP `preferredcont`,  DROP `physstreet`,  DROP `homezipcode`,
        DROP `zipcode`,  DROP `userid`;";

        my $droppr=$dbh->prepare($limpiando_usr);
         $droppr->execute();



#pasamos a todos a estudiante

 my $estudiantes=$dbh->prepare("UPDATE `usr_socio` SET credential_type ='estudiante'  WHERE credential_type ='';");
    $estudiantes->execute();

 my $supervacas=$dbh->prepare("UPDATE `usr_socio` SET credential_type ='superLibrarian'  WHERE is_super_user =1;");
    $supervacas->execute();
        
#Agregamos KOHAADMIN!!!

 my $kohaadmin_persona="INSERT INTO `usr_persona` (`version_documento`, `nro_documento`, `tipo_documento`, `apellido`, `nombre`, `titulo`, `otros_nombres`, `iniciales`, `calle`, `barrio`, `ciudad`, `telefono`, `email`, `fax`, `msg_texto`, `alt_calle`, `alt_barrio`, `alt_ciudad`, `alt_telefono`, `nacimiento`, `fecha_alta`, `legajo`, `sexo`, `telefono_laboral`, `cumple_condicion`, `es_socio`) VALUES
('P', '1000000', 'DNI', 'kohaadmin', 'kohaadmin', NULL, NULL, 'DGR', '007', NULL, '16648', '', '', NULL, NULL, NULL, NULL, '', NULL, '2009-12-23', NULL, '007', NULL, NULL, 0, 1);";
 my $kp=$dbh->prepare($kohaadmin_persona);
    $kp->execute();
 my $personaka=$dbh->prepare("SELECT id_persona FROM usr_persona WHERE  nro_documento= ? ;");
    $personaka->execute('1000000');
 my $id_persona_kohaadmin=$personaka->fetchrow;

my $kohaadmin_socio="INSERT INTO `usr_socio` (`id_persona`, `nro_socio`, `id_ui`, `cod_categoria`, `fecha_alta`, `expira`, `flags`, `password`, `last_login`, `last_change_password`, `change_password`, `cumple_requisito`, `nombre_apellido_autorizado`, `dni_autorizado`, `telefono_autorizado`, `is_super_user`, `credential_type`, `id_estado`, `activo`, `agregacion_temp`) VALUES
(?, 'kohaadmin', ? , 'ES', NULL, NULL, 1, 'a1q8oyiSjO02w1vpPlwscK+kQdDDbolevtC2ZsZX1Uc', '2010-01-13 00:00:00', '2009-12-13', 0, '0000-00-00', '', '', '', 1, 'superLibrarian', 46, '1', 'id_persona');";
 my $ks=$dbh->prepare($kohaadmin_socio);
    $ks->execute($id_persona_kohaadmin,$ui);


#habilitamos los socios

 my $act=$dbh->prepare("UPDATE `usr_socio` SET id_estado =20, activo =1 WHERE id_estado =0;");
    $act->execute();

#Agregamos los socios de las personas no habilitadas!!! 

    my $persona=$dbh->prepare("SELECT * FROM usr_persona;");
    $persona->execute();

    while (my $p=$persona->fetchrow_hashref) {
      if(!$p->{'es_socio'}){
           my $usu_0=$dbh->prepare("INSERT INTO usr_socio (id_persona,nro_socio,id_ui,cod_categoria,flags,change_password,is_super_user,id_estado,activo) VALUES
                ( ? , ? ,?,'ES', 0, 1, 0, 20, 0);");
             $usu_0->execute($p->{'id_persona'},$p->{'nro_documento'},$ui);
      }

    }

  }

  sub hashearPasswords    
  {
  #Re Hasear Pass con sha256
    my $usuarios=$dbh->prepare("SELECT * FROM usr_socio;");
    $usuarios->execute();
    while (my $usuario=$usuarios->fetchrow_hashref) {
      if($usuario->{'password'}){
          my $upus=$dbh->prepare(" UPDATE usr_socio SET password='".sha256_base64($usuario->{'password'})."' WHERE nro_socio='". $usuario->{'nro_socio'} ."' ;");
          $upus->execute();
      }
    }
  }

    sub pasarTodoAInnodb 
    {
    #########################################################################
    #           PASAR TODO A INNODB             #
    #########################################################################
    #hay que quitar algunos fulltext que no soporta Innodb
    #my $fulltext=$dbh->prepare("ALTER TABLE `biblioanalysis` DROP INDEX `resumen`");
    #$fulltext->execute();

    my @innodbs = ('analyticalauthors','analyticalsubject','authorised_values','autores','availability','biblioanalysis','bibliolevel','bookshelf','borrowers','branchcategories','branches','branchrelations','busquedas','categories','colaboradores','countries','deletedborrowers','dptos_partidos','feriados','generic_report_joins','generic_report_tables','historialBusqueda','historicCirculation','historicIssues','historicSanctions','iso2709','issues','issuetypes','itemtypes','languages','localidades','marc_subfield_structure','marc_tag_structure','modificaciones','persons','provincias','referenciaColaboradores','reserves','sanctionissuetypes','sanctionrules','sanctions','sanctiontypes','sanctiontypesrules','sessionqueries','sessions','shelfcontents','stopwords','supports','systempreferences','tablasDeReferencias','tablasDeReferenciasInfo','temas','unavailable','uploadedmarc','userflags','users','z3950queue','z3950results','z3950servers');
    
    foreach $tabla (@innodbs)
    {
    my $innodb=$dbh->prepare("ALTER TABLE $tabla ENGINE = innodb;");
    $innodb->execute();
    }
    }
    sub crearClaves 
    {
    #########################################################################
    #           CREAR CLAVES FORANEAS               #
    #########################################################################
    aplicarSQL("clavesForaneas.sql");
    }

    sub agregarPreferenciasDelSistema 
    {
    #########################################################################
    #           PREFERENCIAS DEL SISTEMA            #
    #########################################################################
    aplicarSQL("preferenciasSistema.sql");
    }

    sub properName {
    my ($title)=@_;

    # split the string and place it into an array
    my @title = split / /, $title;
    # now let’s iterate through the array
    foreach (@title) {
      $_ = lc;
      $_ = ucfirst;
    }
    # convert the array to a space-delimited string
    $title = join(" ", @title);
    return  $title;
    }

    sub modificarCiudades
    {
    #########################################################################
    #           CIUDADES en mayuscula a properName         #
    #########################################################################
      my $localidades=$dbh->prepare("SELECT * FROM localidades;");
      $localidades->execute();
      while (my $localidad=$localidades->fetchrow_hashref) {
	    my $uploc=$dbh->prepare(" UPDATE localidades SET NOMBRE='".properName($localidad->{'NOMBRE'})."', NOMBRE_ABREVIADO ='".properName($localidad->{'NOMBRE_ABREVIADO'})."' where id = '".$localidad->{'id'}."';");
	    $uploc->execute();
	}
    }

    sub agregarCiudades
    {
    #########################################################################
    #           CIUDADES          #
    #########################################################################
    aplicarSQL("ciudades.sql");
    }

=item
guardaNivel1MARC
Guarda los campos del nivel 1 en un MARC RECORD.
=cut

sub guardaNivel1MARC {
    my ($biblionumber, $nivel1)=@_;

    my $marc = MARC::Record->new();

    foreach my $obj(@$nivel1){
        my $campo=$obj->{'campo'};
        my $subcampo=$obj->{'subcampo'};

        if ($obj->{'simple'}){
            my $valor=$obj->{'valor'};
            if ($valor ne ''){
                    #Puede ser repetible y contener varios
                    my @fields = $marc->field($campo);
                    
                    my $added=0;
                    foreach my $field(@fields){
                        #Existe el campo
                        if (! $field->subfield($subcampo)){ 
                            #NO Existe el subcampo se agrega
                            $field->add_subfields( $subcampo => $valor );
                            $added=1;
                        }
                     }

                    if (!$added){ #No pudo ser agregado se crea un campo nuevo
                        $field = MARC::Field->new($campo,'','',$subcampo => $valor);
                        $marc->append_fields($field);
                    }
                }
       }
       else {
            my $arr=$obj->{'valor'};
             foreach my $valor (@$arr){
                if ($valor ne ''){
                        #Puede ser repetible y contener varios
                        my @fields = $marc->field($campo);
                        
                        my $added=0;
                        foreach my $field(@fields){
                            #Existe el campo
                            if (! $field->subfield($subcampo)){ 
                                #NO Existe el subcampo se agrega
                                $field->add_subfields( $subcampo => $valor );
                                $added=1;
                            }
                         }

                        if (!$added){ #No pudo ser agregado se crea un campo nuevo
                            $field = MARC::Field->new($campo,'','',$subcampo => $valor);
                            $marc->append_fields($field);
                        }
                    }
            }
        }
    }

    my $reg_marc_1 =$dbh->prepare("INSERT INTO cat_registro_marc_n1 (marc_record,id) VALUES (?,?) ");
       $reg_marc_1->execute($marc->as_usmarc,$biblionumber);
}




=item
guardaNivel2MARC
Guarda los campos del nivel 2 en un MARC RECORD.
=cut

sub guardaNivel2MARC {
    my ($biblionumber,$biblioitemnumber, $nivel2)=@_;

    my $marc = MARC::Record->new();

    foreach my $obj(@$nivel2){
        my $campo=$obj->{'campo'};
        my $subcampo=$obj->{'subcampo'};

        if ($obj->{'simple'}){
            my $valor=$obj->{'valor'};
             
            if ($valor ne ''){
                    #Puede ser repetible y contener varios
                    my @fields = $marc->field($campo);
                    
                    my $added=0;
                    foreach my $field(@fields){
                        #Existe el campo
                        if (! $field->subfield($subcampo)){ 
                            #NO Existe el subcampo se agrega
                            $field->add_subfields( $subcampo => $valor );
                            $added=1;
                        }
                     }

                    if (!$added){ #No pudo ser agregado se crea un campo nuevo
                        $field = MARC::Field->new($campo,'','',$subcampo => $valor);
                        $marc->append_fields($field);
                    }
            }
                
       }
       else {
            my $arr=$obj->{'valor'};
             foreach my $valor (@$arr){
                if ($valor ne ''){
                        #Puede ser repetible y contener varios
                        my @fields = $marc->field($campo);
                        
                        my $added=0;
                        foreach my $field(@fields){
                            #Existe el campo
                            if (! $field->subfield($subcampo)){ 
                                #NO Existe el subcampo se agrega
                                $field->add_subfields( $subcampo => $valor );
                                $added=1;
                            }
                         }

                        if (!$added){ #No pudo ser agregado se crea un campo nuevo
                            $field = MARC::Field->new($campo,'','',$subcampo => $valor);
                            $marc->append_fields($field);
                        }
                    }
            }
        }
    }
    my $reg_marc_2 =$dbh->prepare("INSERT INTO cat_registro_marc_n2 (marc_record,id1,id) VALUES (?,?,?) ");
       $reg_marc_2->execute($marc->as_usmarc,$biblionumber,$biblioitemnumber);

}


=item
guardaNivel3MARC
Guarda los campos del nivel 2 en un MARC RECORD.
=cut

sub guardaNivel3MARC {
    my ($biblionumber,$biblioitemnumber,$itemnumber,$nivel3)=@_;

    my $marc = MARC::Record->new();

    foreach my $obj(@$nivel3){
        my $campo=$obj->{'campo'};
        my $subcampo=$obj->{'subcampo'};

        if ($obj->{'simple'}){
            my $valor=$obj->{'valor'};
            if ($valor ne ''){
                    #Puede ser repetible y contener varios
                    my @fields = $marc->field($campo);
                    
                    my $added=0;
                    foreach my $field(@fields){
                        #Existe el campo
                        if (! $field->subfield($subcampo)){ 
                            #NO Existe el subcampo se agrega
                            $field->add_subfields( $subcampo => $valor );
                            $added=1;
                        }
                     }

                    if (!$added){ #No pudo ser agregado se crea un campo nuevo
                        $field = MARC::Field->new($campo,'','',$subcampo => $valor);
                        $marc->append_fields($field);
                    }
                }
       }
       else {
            my $arr=$obj->{'valor'};
             foreach my $valor (@$arr){
                if ($valor ne ''){
                        #Puede ser repetible y contener varios
                        my @fields = $marc->field($campo);
                        
                        my $added=0;
                        foreach my $field(@fields){
                            #Existe el campo
                            if (! $field->subfield($subcampo)){ 
                                #NO Existe el subcampo se agrega
                                $field->add_subfields( $subcampo => $valor );
                                $added=1;
                            }
                         }

                        if (!$added){ #No pudo ser agregado se crea un campo nuevo
                            $field = MARC::Field->new($campo,'','',$subcampo => $valor);
                            $marc->append_fields($field);
                        }
                    }
            }
        }
    }

    if(trim($marc->subfield("995","f"))){ #SIN CODIGO DE BARRAS NO SE PUEDE AGREGAR
	my $reg_marc_3 =$dbh->prepare("INSERT INTO cat_registro_marc_n3 (marc_record,id1,id2,id,codigo_barra,signatura) VALUES (?,?,?,?,?,?	)");
	my $codigo=trim($marc->subfield("995","f"));
	my $signatura=trim($marc->subfield("995","t")) || "Signatura ".$itemnumber;# LA SIGNATURA ES OBLIGATORIA!!!
       $reg_marc_3->execute($marc->as_usmarc,$biblionumber,$biblioitemnumber,$itemnumber,$codigo,$signatura);
    }
}


    #########################################################################
    #           ESTRUCTURA CATALOGACION                                     #
    #########################################################################
  sub crearEstructuraMarc {

        aplicarSQL("estructuraMARC.sql");

    }

sub traduccionEstructuraMarc {

        aplicarSQL("traduccionBibliaMARC.sql");

    }

    ###########################################################################################################
    #                                    REPARARAR REFERENCIAS SOCIO                                          #
    #           En todos lados se utiliza nro_socio pero en koha hay tablas que tienen id_socio               #
    #                                           circ_reserva                                                  #
    #                                           circ_prestamo                                                 #
    #                                           circ_sancion                                                  #
    #                                         rep_historial_circulacion                                       #
    #                                          rep_historial_sancion                                          #
    #                                          rep_historial_prestamo                                         #
    ###########################################################################################################

  sub repararReferenciasDeUsuarios {


    my $cant_usr=$dbh->prepare("SELECT count(*) as cantidad FROM usr_socio ;");
    $cant_usr->execute();
    my $cantidad=$cant_usr->fetchrow;
    my $num_usuario=1;
    print "Se van a procesar $cantidad usuarios \n";


    my @refusrs = ('circ_reserva','circ_prestamo','circ_sancion','rep_historial_circulacion','rep_historial_sancion','rep_historial_prestamo');
    

    my $usuarios=$dbh->prepare("SELECT * FROM usr_socio;");
    $usuarios->execute();

    while (my $usuario=$usuarios->fetchrow_hashref) {

    my $porcentaje= int (($num_usuario * 100) / $cantidad );
    print "Procesando usuario: $num_usuario de $cantidad ($porcentaje%) \r";

        foreach $tabla (@refusrs)
      {
            my $refusuario=$dbh->prepare("UPDATE $tabla  SET nro_socio='".$usuario->{'nro_socio'}."' WHERE borrowernumber='". $usuario->{'id_socio'} ."' ;");
            $refusuario->execute();
      
	    if (($tabla eq 'rep_historial_circulacion')||($tabla eq 'rep_historial_sancion')){
	      #Estas tablas tienen responsable
		my $refresponsable=$dbh->prepare("UPDATE $tabla  SET responsable='".$usuario->{'nro_socio'}."' WHERE responsable='". $usuario->{'id_socio'} ."' ;");
		$refresponsable->execute();
	    }

      }

    $num_usuario++;
    }

    #LIMPIAMOS!!!
    foreach $tabla (@refusrs)
    {
      my $refusr=$dbh->prepare("ALTER TABLE $tabla DROP borrowernumber;");
      $refusr->execute();

      my $refclean=$dbh->prepare("DELETE FROM $tabla WHERE nro_socio='0' OR nro_socio='';");
      $refclean->execute();

	    if(($tabla eq 'rep_historial_sancion')||($tabla eq 'rep_historial_circulacion')){
	      #Estas tablas tienen responsable (ponemos al usuario)
	      my $refclean2=$dbh->prepare("UPDATE $tabla SET responsable=nro_socio WHERE responsable=0 OR responsable='';");
	      $refclean2->execute();
	    }
    }

	#Se agregan las referencias a los prestamos viejos!!
	
	  my $refprestamos=$dbh->prepare("INSERT INTO rep_historial_prestamo (id3,nro_socio,tipo_prestamo,fecha_prestamo,id_ui_origen,id_ui_prestamo,fecha_devolucion,fecha_ultima_renovacion,renovaciones,timestamp,agregacion_temp)
									SELECT id3,nro_socio,tipo_prestamo,NULL,id_ui as id_ui_origen,id_ui as id_ui_prestamo,fecha as fecha_devolucion,NULL,0,NOW(),NULL
									FROM `rep_historial_circulacion` WHERE (`tipo_operacion` = 'devolucion' or `tipo_operacion` = 'return') ;");
     $refprestamos->execute();
      
      #Responsables que no existen mas      
       my $refresponsables=$dbh->prepare("UPDATE `rep_historial_circulacion` SET responsable='kohaadmin' WHERE responsable not in (select nro_socio from usr_socio);");
       $refresponsables->execute();
            
    }


#### Se limpian las tablas de circulacion ####

  sub limpiarCirculacion {

        aplicarSQL("limpiarCirculacion.sql");


 #Ahora limpiamos reservas y prestamos sin id_ui
 #Default ui
    my $q_ui=$dbh->prepare("SELECT value FROM pref_preferencia_sistema where variable ='defaultbranch';");
    $q_ui->execute();
    my $ui=$q_ui->fetchrow || 'DEO';


    my $q1=$dbh->prepare("UPDATE circ_reserva SET id_ui = ? WHERE id_ui = '';");
    $q1->execute($ui);

    my $q2=$dbh->prepare("UPDATE circ_prestamo SET id_ui_origen = ? WHERE id_ui_origen = '';");
    $q2->execute($ui);

    my $q3=$dbh->prepare("UPDATE circ_prestamo SET id_ui_prestamo = ? WHERE id_ui_prestamo = '';");
    $q3->execute($ui);
    }

    #########################################################################
    #           GRACIAS!!!!!!!!!!               #
    #########################################################################

  sub aplicarSQL {
    my ($sql)=@_;

    my $PASSWD = C4::Context->config("pass");
    my $USER = C4::Context->config("user");
    my $BASE = C4::Context->config("database");

    system("mysql -f --default-character-set=utf8 $BASE -u$USER -p$PASSWD < $sql ") == 0 or print "Fallo el sql ".$sql." \n";

    }

  sub getEstado {
    my ($id)=@_;

    my $q_estado=$dbh->prepare("SELECT codigo FROM ref_estado where id = ? ;");
    $q_estado->execute($id);
    my $estado=$q_estado->fetchrow;
    return $estado;
    }

  sub getDisponibilidad {
    my ($id)=@_;
    my $q_disp=$dbh->prepare("SELECT codigo FROM ref_disponibilidad where id = ? ;");
    $q_disp->execute($id);
    my $disp=$q_disp->fetchrow;
    return $disp;
    }

sub trim{
    my ($string) = @_;

    $string =~ s/^\s+//;
    $string =~ s/\s+$//;

    return $string;
}

sub dandoPermisosUsuarios {
# PERDI AUN NO TENGO ROSE :( :(
#     my  $socios = C4::Modelo::UsrSocio::Manager->get_usr_socio();
#         foreach my $socio (@$socios){
# 	  my $flag = $socio->getFlags;
# 	  if ($flag){
# 	    #Si tiene flags seteados NO es un estudiante
# 	     if($flag % 2){
# 		#Da 1 entonces era IMPAR => tenia el 1er bit en 1 => es SUPERLIBRARIAN
# 		$socio->convertirEnSuperLibrarian;
#   	     }else{
# 		#Da 0 entonces era PAR => tenia el 1er bit en 0 => NO es SUPERLIBRARIAN
# 		$socio->convertirEnLibrarian;
# 	     }
# 	  }else{
# 	    #Si NO tiene flags seteados es un estudiante
# 	    $socio->convertirEnEstudiante;
# 	  }
#         }
}


    ###########################################################################################################
    #		                                 PROCESAR ANALITICAS                                          #
    #           Hay que agregar las anliticas como registros nuevos con su relación al registro padre.        #
    #                                           cat_analitica                                                 #
    #                                           cat_autor_analitica                                           #
    #                                           cat_tema_analitica                                            #
    # TABLA: cat_analitica
    #
    # id1
    # id2 => RELACIÓN
    # analyticaltitle =>N1 245 a
    # analyticalunititle =>N1 245 b
    # parts => N2 300 a
    # timestamp
    # analyticalnumber
    # classification => ??? es la signatura SE USA?
    # resumen => N1 520 a
    # url => N2 856 u
    #
    # TABLA: cat_autor_analitica
    #
    # analyticalnumber 
    # author => id autor => N1 100 a
    #
    # TABLA: cat_tema_analitica
    # analyticalnumber
    # subject => cat_tema => N1 650 a
    ###########################################################################################################

sub procesarAnaliticas {

	my $cant_analiticas=$dbh->prepare("SELECT count(*) as cantidad FROM cat_analitica ;");
	$cant_analiticas->execute();
	my $cantidad=$cant_analiticas->fetchrow;
	my $registro=1;
	print "Se van a procesar $cantidad analiticas \n";
	my $analiticas=$dbh->prepare("SELECT * FROM cat_analitica ;");
	$analiticas->execute();
	while (my $analitica = $analiticas->fetchrow_hashref ) {
	
		my $porcentaje= int (($registro * 100) / $cantidad );
 		print "Procesando registro: $registro de $cantidad ($porcentaje%) \r";

	#---------------------------------------NIVEL1---------------------------------------#
		my @analitica_n1=();
		my @analitica_n2=();

		my $an1;
        	$an1->{'campo'}='245';
        	$an1->{'subcampo'}='a';
        	$an1->{'valor'}=$analitica->{'analyticaltitle'};
                $an1->{'simple'}=1;
                if (($an1->{'valor'} ne '') && ($an1->{'valor'} ne null)){push(@analitica_n1,$an1);}

                my $an2;
                $an2->{'campo'}='245';
                $an2->{'subcampo'}='b';
                $an2->{'valor'}=$analitica->{'analyticalunititle'};
                $an2->{'simple'}=1;
                if (($an2->{'valor'} ne '') && ($an2->{'valor'} ne null)){push(@analitica_n1,$an2);}

                my $an3;
                $an3->{'campo'}='520';
                $an3->{'subcampo'}='a';
                $an3->{'valor'}=$analitica->{'resumen'};
                $an3->{'simple'}=1;
		if (($an3->{'valor'} ne '') && ($an3->{'valor'} ne null)){push(@analitica_n1,$an3);}

		##########################TEMAS##########################
		# cat_tema_analitica
		my $temas=$dbh->prepare("SELECT * FROM cat_tema_analitica where analyticalnumber = ?;");
		$temas->execute($analitica->{'analyticalnumber'});

		while (my $tema_analitica=$temas->fetchrow_hashref ) {

		    my $dn1tema;
		    $dn1tema->{'campo'}='650';
		    $dn1tema->{'subcampo'}='a';

			#FIXME HAY QUE BUSCAR EL TEMA Y OBTENER EL ID O AGREGAR UNO NUEVO!!
			my $tema_final='';
			my $tt=$dbh->prepare("SELECT * FROM cat_tema where nombre = ?;");
			$tt->execute($tema_analitica->{'subject'});
			$tema_final=$tt->fetchrow_hashref;

			if(!$tema_final){
			#Hay que agregar el tema nueva
# 			    print "TEMA NUEVO ".$tema_analitica->{'subject'}." \n";
			    my $tn=$dbh->prepare("INSERT INTO cat_tema (nombre) VALUES (?);");
			    $tn->execute($tema_analitica->{'subject'});
			    
			    my $tt2=$dbh->prepare("SELECT * FROM cat_tema where nombre = ?;");
			    $tt2->execute($tema_analitica->{'subject'});
			    $tema_final=$tt2->fetchrow_hashref;
			}

		    $dn1tema->{'simple'}=1;
		    $dn1tema->{'valor'}='cat_tema@'.$tema_final->{'id'};
		    push(@analitica_n1,$dn1tema);
		}

		$temas->finish();
		##########################AUTORES##########################
		# cat_autor_analitica
		
		my $autores_analiticas=$dbh->prepare("SELECT * FROM cat_autor_analitica where analyticalnumber = ?;");
		$autores_analiticas->execute($analitica->{'analyticalnumber'});
        
        #Debe ir el primero como autor principal y el resto como autores secundarios
        my $principal=1;
        while (my $aauthor=$autores_analiticas->fetchrow_hashref ) {
            my $dn1add;
            my @ar1;
            if ($principal){
                $dn1add->{'campo'}='100';
            }else{
                $dn1add->{'campo'}='700';
            }
            $dn1add->{'subcampo'}='a';
            $dn1add->{'simple'}=1;
            $dn1add->{'valor'}='cat_autor@'.$aauthor->{'author'};
            
            push(@analitica_n1,$dn1add);
        }
		$autores_analiticas->finish();
        
	#########################################################################
	my($error,$codMsg);
	my $nuevo_id1 = guardaNuevoNivel1MARC(\@analitica_n1);
	#---------------------------------------FIN NIVEL1---------------------------------------#	

	#---------------------------------------NIVEL2---------------------------------------#

		#Primero la relación
		my $relacion;
        	$relacion->{'campo'}='773';
        	$relacion->{'subcampo'}='a';
        	$relacion->{'valor'}='cat_registo_marc_n2@'.$analitica->{'id2'};
                $relacion->{'simple'}=1;
                if (($relacion->{'valor'} ne '') && ($relacion->{'valor'} ne null)){push(@analitica_n2,$relacion);}

		#Tipo ANALITICA
		my $tipo;
        	$tipo->{'campo'}='910';
        	$tipo->{'subcampo'}='a';
        	$tipo->{'valor'}='cat_ref_tipo_nivel3@ANA';
                $tipo->{'simple'}=1;
                if (($tipo->{'valor'} ne '') && ($tipo->{'valor'} ne null)){push(@analitica_n2,$tipo);}

		my $an1;
        	$an1->{'campo'}='300';
        	$an1->{'subcampo'}='a';
        	$an1->{'valor'}=$analitica->{'parts'};
                $an1->{'simple'}=1;
                if (($an1->{'valor'} ne '') && ($an1->{'valor'} ne null)){push(@analitica_n2,$an1);}

                my $an2;
                $an2->{'campo'}='856';
                $an2->{'subcampo'}='u';
                $an2->{'valor'}=$analitica->{'url'};
                $an2->{'simple'}=1;
                if (($an2->{'valor'} ne '') && ($an2->{'valor'} ne null)){push(@analitica_n2,$an2);}

	#########################################################################
	my($error,$codMsg);
	my $nuevo_id2 = guardaNuevoNivel2MARC($nuevo_id1,\@analitica_n2);
	#---------------------------------------FIN NIVEL2---------------------------------------#

	$registro++;
	}

my $drop_analiticas=$dbh->prepare("DROP TABLE `cat_analitica`,`cat_autor_analitica`,`cat_tema_analitica` ;");
 $drop_analiticas->execute();

}


=item
guardaNuevoNivel1MARC
Guarda los campos del nivel 1 en un MARC RECORD y retorna su id
=cut

sub guardaNuevoNivel1MARC {
    my ($nivel1)=@_;

    my $marc = MARC::Record->new();

    foreach my $obj(@$nivel1){
        my $campo=$obj->{'campo'};
        my $subcampo=$obj->{'subcampo'};

        if ($obj->{'simple'}){
            my $valor=$obj->{'valor'};
            if ($valor ne ''){

                    my $field;
                     if ($field=$marc->field($campo)){ #Ya existe el campo

		         if ($field->subfield($subcampo)){ #Existe el subcampo se agrega a un campo nuevo
			    $field = MARC::Field->new($campo,'','',$subcampo => $valor);
			    $marc->append_fields($field);
			  }
			  else{# se agrega el subcampo
			    $field->add_subfields( $subcampo => $valor );
			 }

                     } else { #NO existe el campo, se agrega uno nuevo
                         $field = MARC::Field->new($campo,'','',$subcampo => $valor);
                         $marc->append_fields($field);
                     }

                }
       }
       else {
            my $arr=$obj->{'valor'};
             foreach my $valor (@$arr){
                if ($valor ne ''){
                    my $field;
                     if ($field=$marc->field($campo)){ #Ya existe el campo

		         if ($field->subfield($subcampo)){ #Existe el subcampo se agrega a un campo nuevo
			    $field = MARC::Field->new($campo,'','',$subcampo => $valor);
			    $marc->append_fields($field);
			  }
			  else{# se agrega el subcampo
			    $field->add_subfields( $subcampo => $valor );
			 }

                     } else { #NO existe el campo, se agrega uno nuevo
                         $field = MARC::Field->new($campo,'','',$subcampo => $valor);
                         $marc->append_fields($field);
                     }
                }
            }
        }
    }

    my $reg_marc_1 =$dbh->prepare("INSERT INTO cat_registro_marc_n1 (marc_record) VALUES (?) ");
       $reg_marc_1->execute($marc->as_usmarc);

    my $nuevo_id1 =$dbh->prepare("SELECT MAX(id) FROM cat_registro_marc_n1; ");
       $nuevo_id1->execute();

    my $id1=$nuevo_id1->fetchrow;

    return $id1;  
}




=item
guardaNuevoNivel2MARC
Guarda los campos del nivel 2 en un MARC RECORD y retorna su id
=cut

sub guardaNuevoNivel2MARC {
    my ($id1, $nivel2)=@_;

    my $marc = MARC::Record->new();

    foreach my $obj(@$nivel2){
        my $campo=$obj->{'campo'};
        my $subcampo=$obj->{'subcampo'};

        if ($obj->{'simple'}){
            my $valor=$obj->{'valor'};
            if ($valor ne ''){
                    my $field;
                     if ($field=$marc->field($campo)){ #Ya existe el campo

		         if ($field->subfield($subcampo)){ #Existe el subcampo se agrega a un campo nuevo
			    $field = MARC::Field->new($campo,'','',$subcampo => $valor);
			    $marc->append_fields($field);
			  }
			  else{# se agrega el subcampo
			    $field->add_subfields( $subcampo => $valor );
			 }

                     } else { #NO existe el campo, se agrega uno nuevo
                         $field = MARC::Field->new($campo,'','',$subcampo => $valor);
                         $marc->append_fields($field);
                     }
                }
       }
       else {
            my $arr=$obj->{'valor'};
             foreach my $valor (@$arr){
                if ($valor ne ''){
                    my $field;
                     if ($field=$marc->field($campo)){ #Ya existe el campo

		         if ($field->subfield($subcampo)){ #Existe el subcampo se agrega a un campo nuevo
			    $field = MARC::Field->new($campo,'','',$subcampo => $valor);
			    $marc->append_fields($field);
			  }
			  else{# se agrega el subcampo
			    $field->add_subfields( $subcampo => $valor );
			 }

                     } else { #NO existe el campo, se agrega uno nuevo
                         $field = MARC::Field->new($campo,'','',$subcampo => $valor);
                         $marc->append_fields($field);
                     }
                }
            }
        }
    }

    my $reg_marc_2 =$dbh->prepare("INSERT INTO cat_registro_marc_n2 (marc_record,id1) VALUES (?,?) ");
       $reg_marc_2->execute($marc->as_usmarc,$id1);

    my $nuevo_id2 =$dbh->prepare("SELECT MAX(id) FROM cat_registro_marc_n2; ");
       $nuevo_id2->execute();

    my $id2=$nuevo_id2->fetchrow;

    return $id2;  

}


sub pasarBaseUTF8 {

my $base = C4::Context->config('database');

my $dbh = C4::Context->dbh;
my @tables = $dbh->tables;

my $sql_base = "ALTER DATABASE $base DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;";
my $sth0=$dbh->prepare($sql_base);
   $sth0->execute();

foreach my $table (@tables){
	my @t = split(/\./,$table);
	chop($t[1]);
	my $tabla=substr($t[1],1);

	my $sql_tabla = "ALTER TABLE $tabla CONVERT TO CHARACTER SET utf8;";
  	my $sth1=$dbh->prepare($sql_tabla);
  	$sth1->execute();

	my $desc = $dbh->selectall_arrayref("DESCRIBE $tabla", { Columns=>{} });
  	foreach my $row (@$desc) {
       		my $tipo = $row->{'Type'};
       		my $columna = $row->{'Field'};
		if(($tipo =~ m/char/) || ($mystring =~ m/text/)){
			my $sql_columna1="ALTER TABLE $tabla CHANGE $columna $columna BLOB;";
			my $sth2=$dbh->prepare($sql_columna1);
  			$sth2->execute();

			my $sql_columna2="ALTER TABLE $tabla CHANGE $columna $columna $tipo CHARACTER SET utf8 COLLATE utf8_general_ci ;";
			my $sth3=$dbh->prepare($sql_columna2);
  			$sth3->execute();
		}
   	}
}


}


sub actualizarMeran {
    # Aplica TODOS los SQL Updates Hasta llegar a la JAULA!
    
     for (my $version = 1; $version <= 313; $version++) {
        print "Actualizando versión ".$version."\n";
           aplicarSQL("../sqlUPDATES/2011/sql.rev".$version);
     }

    print "Actualizando version del paquete \n";
    aplicarSQL("../instalador/updates.sql");
}